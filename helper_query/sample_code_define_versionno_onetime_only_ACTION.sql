
declare @ExpectedPreviousVersion nvarchar(25) = '11.4a2'
declare @PatchVersion nvarchar(25) = '12.1i1'

--------------------------- no need change below ---------------------------
--start keep the new patch version value into temp table
If(OBJECT_ID('tempdb..#tbPatchVersion') Is Not Null)
begin
    Drop Table #tbPatchVersion
end
create table #tbPatchVersion
(
	ID int IDENTITY PRIMARY KEY,
	PatchVersion Varchar(50) 
)
insert into #tbPatchVersion 
select @PatchVersion  
--end  

-- Pre-patch version check
Declare @CurrentVersion nvarchar(25)
Exec dbo.GetCurrentVersion @CurrentVersion Output

Print 'Current DB version is: ' + @CurrentVersion
Print ''

If (@CurrentVersion <> @ExpectedPreviousVersion AND @CurrentVersion <> @PatchVersion)
Begin
	Print 'Patching aborted because current database version is not ' + @ExpectedPreviousVersion + ' or ' + @PatchVersion + '.'
	Raiserror ('Patch aborted.',20, 10) With Log
	Return
End

IF @CurrentVersion = @PatchVersion
BEGIN
	Print 'Patching aborted because current database version is  ' + @CurrentVersion + ' same as  patch version : ' + @PatchVersion + '.'
	Raiserror ('Patch aborted.',20, 10) With Log
	Return
END
GO 
--------------------------- no need change above ---------------------------

Print 'BEGIN PATCHING'

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO 
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalExcessAmountPerFlight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalExcessAmountPerFlight]
GO

CREATE PROCEDURE [dbo].[TotalExcessAmountPerFlight]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@FlightNumber Varchar(50)
	)
	WITH RECOMPILE
AS
BEGIN      
			--1. get all CustomerSession IDs which meets the timeframe in table: ExcessDetailsLog
			declare @tblCustomerSessionID table (Id int) 
			insert into @tblCustomerSessionID
			SELECT distinct
			isnull(CustomerSession.ID, 0)
			FROM BagWeightUpdate
			JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession ON ExcessDetailsLog.CustomerSessionID = CustomerSession.ID
			LEFT OUTER JOIN Flight ON CustomerSession.FlightID = Flight.ID			 
			WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
 
			--2. get all records not in table: ExcessTierLog put into table 
			declare @tblExcessRecords table 
			(
			Id int identity, 
			CustomerSessionID BigInt,
			FlightName varchar(50),
			FlightRoute varchar(50),
			ExcessValue BigInt,
			FlightNumber varchar(50)
			) 

			--records from table: ExcessDetailsLog
			insert into @tblExcessRecords(CustomerSessionID, FlightName, FlightRoute, ExcessValue, FlightNumber)
			select distinct
			custId.Id,
			isnull(Flight.MarketingCarrier + Flight.FlightNumber, 'X') AS FlightName,
			isnull(Flight.BoardPoint + ' - ' + Flight.OffPoint, '') as FlightRoute,
			cast(ExcessDetailsLog.TotalExcessValue as int) AS ExcessValue,
			CAST(Flight.FlightNumber AS nvarchar(100)) as FlightNumber			
			FROM @tblCustomerSessionID custId INNER JOIN BagWeightUpdate on custId.Id = BagWeightUpdate.CustomerSessionID
			INNER JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession cs ON ExcessDetailsLog.CustomerSessionID = cs.ID
			LEFT OUTER JOIN Flight ON cs.FlightID = Flight.ID			 
			WHERE Not cs.ID in (select CustomerSessionID from ExcessTierLog)

			--records from table: ExcessTierLog
			insert into @tblExcessRecords(CustomerSessionID, FlightName, FlightRoute, ExcessValue, FlightNumber)
			select 
			et.CustomerSessionID, 
			isnull(et.Company + cast(et.Flightnumber as varchar), '') as FlightName,
			isnull(et.Origin + ' - ' + et.Destination, '') as FlightRoute,
			cast(et.ChargeValueMoney as BigInt) AS ExcessValue,
			CAST(et.FlightNumber AS nvarchar(100)) as FlightNumber			 
			from ExcessTierLog et
			where et.CustomerSessionID in (select Id from  @tblCustomerSessionID)

			--final results
			select 
			isnull(er.FlightName, 'X') AS FlightName,
			isnull(er.FlightRoute, '') as FlightRoute,
			cast(sum(er.ExcessValue) as int) AS TotalExcessValue, 
			count(er.FlightName) AS NumberOfExcess
			FROM @tblExcessRecords as er
			WHERE (CAST(er.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
			GROUP BY FlightName, FlightRoute
			ORDER BY TotalExcessValue DESC
END

Print 'Create SP TotalExcessAmountPerFlight'

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalExcessCalculationError]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalExcessCalculationError]
GO

CREATE  PROCEDURE [dbo].[TotalExcessCalculationError]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime,
	@Terminal nvarchar(10),
	@Area nvarchar(10),
	@SubArea nvarchar(10),
	@ABDStationIDs varchar(400),
	@ABDStationNames varchar(4000),
	@TotalBagAccepted int out
	)
		WITH RECOMPILE
AS
	SET @TotalBagAccepted = (SELECT COUNT(BagWeightUpdate.ID) 
								FROM BagWeightUpdate
								JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
								WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
									AND (AbdStation.Terminal LIKE @Terminal )
									AND (ISNULL(AbdStation.Area,'') LIKE @Area )
									AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
									AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0))

	SELECT 

	FaultType.ID AS FaultTypeID, 
	FaultType.ShortName, 
	COUNT(ABDErrorLog.ID) as NumberOfErrors, 	
	@ABDStationNames AS ABDStations	
		  
	FROM ABDErrorLog 
		JOIN FaultType ON ABDErrorLog.FaultTypeID = FaultType.ID 
		JOIN AbdStation ON ABDErrorLog.AbdStationID = AbdStation.ID
	WHERE        (ABDErrorLog.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime)
		AND (AbdStation.Terminal LIKE @Terminal )
		AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		AND FaultType.ID IN (SELECT ID
								FROM FaultType
							WHERE lower([Description]) like '%excess%' and lower([Description]) <> 'excessbagdetected')

	GROUP BY FaultType.ID,FaultType.ShortName
	ORDER BY COUNT(ABDErrorLog.ID) DESC


Print 'Create SP TotalExcessCalculationError'
GO

Print 'END PATCHING'

------------------------------------------ no need change below ------------------------------------------
declare @SuccessVersion nvarchar(25)
select @SuccessVersion = PatchVersion from #tbPatchVersion --get the patch version number from temp table
-- Post-patch version deployment recording
Exec dbo.RecordVersionDeployment @SuccessVersion
Print 'Recorded DB version deployment for: ' + @SuccessVersion
------------------------------------------ no need change above ------------------------------------------