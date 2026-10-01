
-- define the target database below only once
USE ReportingDB
GO

--define the version variables below
declare @ExpectedPreviousVersion nvarchar(25) = '12.1i1'
declare @PatchVersion nvarchar(25) = '12.1i2'

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

Print 'BEGIN PATCHING'
--------------------------- no need change above ---------------------------

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO 
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalBagsPerFlight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalBagsPerFlight]
GO

CREATE PROCEDURE [dbo].[TotalBagsPerFlight]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime
)
WITH RECOMPILE
AS

BEGIN
            --define table variable for holding temp data
			declare @tblRecordsHolder table 
			(
			[Year] int, 
			[Month] int,
			[Day] int,
			Airport varchar(50),
			ScheduleDate DateTIme,
			AirlineCode varchar(10),
			TotalBags int
			) 

			insert into @tblRecordsHolder
			SELECT     
				DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
				DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
				DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
				AbdStation.PortCode as Airport, 
				Flight.DepartureDate as ScheduleDate,	
				isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx') as AirlineCode,	  	 
				COUNT(BagWeightUpdate.LocalTime) AS Bags						   
			FROM         BagWeightUpdate INNER JOIN
									AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
									CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
									Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
									Bag ON BagWeightUpdate.BagID = Bag.ID
			WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
			GROUP BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime),
				AbdStation.PortCode, 	
				AbdStation.Identifier, 
				AbdStation.Terminal,
				AbdStation.Area,
				AbdStation.SubArea,
				isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx'), 
				Flight.DepartureDate
			ORDER BY DATEPART(YEAR, BagWeightUpdate.LocalTime), DATEPART(MONTH, BagWeightUpdate.LocalTime), DATEPART(DAY, BagWeightUpdate.LocalTime), 
				isnull(Flight.MarketingCarrier, 'xx') + isnull(Flight.FlightNumber, 'xxx'), Flight.DepartureDate 

			--finally fetch the data we need 
			select
				[Year], 
				[Month],
				[Day],
				Airport,
				ScheduleDate,
				AirlineCode,
				sum(TotalBags) as TotalBags 
			from @tblRecordsHolder
			group by [Year], 
					 [Month],
					 [Day],
					 Airport,
					 ScheduleDate,
					 AirlineCode
			order by ScheduleDate desc, sum(TotalBags) desc
END
GO
Print 'Create SP TotalBagsPerFlight'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsagePerABDPerCustomerSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UsagePerABDPerCustomerSession]
GO
CREATE PROCEDURE [dbo].[UsagePerABDPerCustomerSession]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime
)
WITH RECOMPILE
AS

BEGIN
    SELECT DISTINCT   
	DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
	DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
	DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
	AbdStation.PortCode, 
	AbdStation.Identifier, 
	AbdStation.Terminal,
	AbdStation.Area,
	AbdStation.SubArea,	
	dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	CustomerSession.ID as CustomersessionID,
	CustomerSession.PNR,
	isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
	isnull(Flight.FlightNumber, 'xxx') as FlightNumber,
	@FromDateTime as Startdate,
	@ToDateTime as EndDate,  
	CustomerSession.SessionDuration 						   
	FROM         BagWeightUpdate INNER JOIN
							AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
							CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
							Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
							Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
	ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), isnull(Flight.MarketingCarrier, 'xx'), isnull(Flight.FlightNumber, 'xxx') desc
END

GO
Print 'Create SP UsagePerABDPerCustomerSession'


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TotalPassengersPerFlight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TotalPassengersPerFlight]
GO
CREATE PROCEDURE [dbo].[TotalPassengersPerFlight]
(
	@FromDateTime DateTime,
	@ToDateTime DateTime
)
WITH RECOMPILE
AS

BEGIN
		SELECT DISTINCT   
			DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
			DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
			DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
			AbdStation.PortCode, 
			AbdStation.Identifier, 
			AbdStation.Terminal,
			AbdStation.Area,
			AbdStation.SubArea,	
			dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
			Flight.DepartureDate,	
			isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
			isnull(Flight.FlightNumber, 'xxx') as FlightNumber,	 
			count(CustomerSession.CustomerID) as TotalPax 						   
		FROM         BagWeightUpdate INNER JOIN
								AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
								CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
								Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
								Bag ON BagWeightUpdate.BagID = Bag.ID
		WHERE     (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)
		group by
			DATEPART(YEAR, BagWeightUpdate.LocalTime), 
			DATEPART(MONTH, BagWeightUpdate.LocalTime), 
			DATEPART(DAY, BagWeightUpdate.LocalTime), 
			AbdStation.PortCode, 
			AbdStation.Identifier, 
			AbdStation.Terminal,
			AbdStation.Area,
			AbdStation.SubArea,	
			dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea),
			Flight.DepartureDate,	
			isnull(Flight.MarketingCarrier, 'xx'),
			isnull(Flight.FlightNumber, 'xxx')
		order by Flight.DepartureDate desc, count(CustomerSession.CustomerID) desc
END
GO
Print 'Create SP TotalPassengersPerFlight'


------------------------------------------ no need change below ------------------------------------------
Print 'END PATCHING'

declare @SuccessVersion nvarchar(25)
select @SuccessVersion = PatchVersion from #tbPatchVersion --get the patch version number from temp table
-- Post-patch version deployment recording
Exec dbo.RecordVersionDeployment @SuccessVersion
Print 'Recorded DB version deployment for: ' + @SuccessVersion
------------------------------------------ no need change above ------------------------------------------