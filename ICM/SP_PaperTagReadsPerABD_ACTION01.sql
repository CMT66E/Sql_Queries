declare @FromDateTime DateTime = '2022/05/12 00:00:00'
declare @ToDateTime DateTime = '2022/05/18 23:59:59'    --- daily: 63  weekly: 131  monthly: 222
declare @CLVShortName nvarchar(100)  = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'
declare @Airline nvarchar(100) = '0'

SET NOCOUNT ON
SET FMTONLY OFF;

declare @TempTbl TABLE
(
	airline_code nvarchar(10) 
)

IF @Airline <> '0'
insert into @TempTbl
select rtrim(ltrim(Items)) from  dbo.Split(@Airline, ',')
        
Declare @TotalAirlineCount INT = 0

if @Area = ''   
		set @Area = '%'
	    
if CHARINDEX(',', @Airline) > 0 AND @Airline <> '0'
	select @TotalAirlineCount = count(*) from @TempTbl

drop table if exists #Temp
Select * Into #Temp from PaperTagReadLog Where PaperTagReadLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime AND PaperTagReadLog.WasReadSuccessful = 1

--select * from #Temp

drop table if exists #Temp2
If @TotalAirlineCount = 0 
begin
	Select CustomerSession.ID, CustomerSession.AbdStationID, CustomerSession.FlightID, Flight.MarketingCarrier as MarketingCarrier Into #Temp2 
	from CustomerSession inner join Flight on CustomerSession.FlightID = Flight.ID
	Where LocalTime BETWEEN @FromDateTime AND @ToDateTime 
end

drop table if exists #Temp3
If @TotalAirlineCount > 0  AND @Airline <> '0'
begin
	Select CustomerSession.ID, CustomerSession.AbdStationID, CustomerSession.FlightID, Flight.MarketingCarrier as MarketingCarrier Into #Temp3
	from CustomerSession inner join Flight on CustomerSession.FlightID = Flight.ID
	Where LocalTime BETWEEN @FromDateTime AND @ToDateTime AND MarketingCarrier IN (select airline_code from @TempTbl)
end
--select * from #Temp2

drop table if exists #Temp4
Select AbdStation.ID as AbdStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
AbdStation.PortCode, AbdStation.Identifier, AbdStation.AbdType, AbdStation.Terminal, AbdStation.Zone, AbdStation.Area, AbdStation.SubArea
Into #Temp4 from AbdStation  

--select * from #Temp4

drop table if exists #Temp5

If @TotalAirlineCount > 0  --airline filter is required
begin
	SELECT  PaperTagReadLog.PaperTagReadStepID, 
			COUNT(PaperTagReadLog.ID) AS PaperTagReads,
			AbdStation.AbdStationName,
			PaperTagReadStep.Heading, 
			isnull(PaperTagReadStep.Description, '') as Description
	FROM   #Temp PaperTagReadLog
	INNER JOIN #Temp4 AbdStation ON PaperTagReadLog.AbdStationID = AbdStation.AbdStationID 	 
	INNER JOIN PaperTagReadStep ON PaperTagReadLog.PaperTagReadStepID = PaperTagReadStep.ID AND PaperTagReadLog.WasReadSuccessful = 1
	LEFT JOIN PaperTagReadScanner ON PaperTagReadScanner.PaperTagReadLogID = PaperTagReadLog.ID
	LEFT JOIN ClvScannerType ON ClvScannerType.ID = PaperTagReadScanner.ClvScannerTypeID
	INNER JOIN #Temp3 CustomerSessionTemp ON AbdStation.AbdStationID = CustomerSessionTemp.AbdStationID	 
	WHERE (ClvScannerType.ShortName LIKE @CLVShortName)
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.AbdStationID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			--AND CustomerSessionTemp.MarketingCarrier IN (select airline_code from @TempTbl)
	GROUP BY AbdStation.AbdStationName, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, PaperTagReadLog.PaperTagReadStepID,  PaperTagReadStep.Heading,PaperTagReadStep.Description
	ORDER BY PaperTagReadStep.Heading, AbdStation.AbdStationName
end
else
begin

	SELECT  PaperTagReadLog.PaperTagReadStepID, COUNT(PaperTagReadLog.ID) AS PaperTagReads,
			AbdStation.AbdStationName,
			PaperTagReadStep.Heading, 
			isnull(PaperTagReadStep.Description, '') as [Description]
			 into #Temp5
	FROM        #Temp PaperTagReadLog
	INNER JOIN #Temp4 AbdStation ON PaperTagReadLog.AbdStationID = AbdStation.AbdStationID 	 
	INNER JOIN PaperTagReadStep ON PaperTagReadLog.PaperTagReadStepID = PaperTagReadStep.ID AND PaperTagReadLog.WasReadSuccessful = 1
	LEFT JOIN PaperTagReadScanner ON PaperTagReadScanner.PaperTagReadLogID = PaperTagReadLog.ID
	LEFT JOIN ClvScannerType ON ClvScannerType.ID = PaperTagReadScanner.ClvScannerTypeID	
	INNER JOIN #Temp2 CustomerSessionTemp ON AbdStation.AbdStationID = CustomerSessionTemp.AbdStationID			 
	WHERE (ClvScannerType.ShortName LIKE @CLVShortName)
			AND (AbdStation.Terminal LIKE @Terminal )
			AND (ISNULL(AbdStation.Area,'') LIKE @Area )
			AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
			AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.AbdStationID AS varchar(10)) + ',', @ABDStationIDs) > 0)			 
	GROUP BY AbdStation.AbdStationName, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, PaperTagReadLog.PaperTagReadStepID,  PaperTagReadStep.Heading,PaperTagReadStep.Description
	ORDER BY PaperTagReadStep.Heading, AbdStation.AbdStationName
end

select * from #Temp5 
---------------------------------------------------------
select * from #Temp5 where PaperTagReadStepID = 0
select * from #Temp5 where PaperTagReadStepID = 1
select * from #Temp5 where PaperTagReadStepID = 2
select * from #Temp5 where PaperTagReadStepID = 3
select * from #Temp5 where PaperTagReadStepID = 4