	declare @FromDateTime DateTime = '2022/03/01 00:00:00'
	declare @ToDateTime DateTime = '2022/03/01 23:59:59'
	declare @Airline nvarchar(50) = '%'
	declare @CUSSApplicationID int = 0
	declare @Terminal nvarchar(10) = '%'
	declare @Area nvarchar(10) = '%'
	declare @SubArea nvarchar(10) = '%'
	declare @ABDStationIDs varchar(400) = '0'
	declare @ABDStationNames varchar(4000) = 'Display All ABDs'

----------------------------------------------------
IF OBJECT_ID('tempdb..##TempApplicationSessionUsage') is not null
	DROP TABLE [dbo].[##TempApplicationSessionUsage]
----------------------------------------------------

	SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
	ApplicationSessionUsage.AirlineID, Airlines.Airline,  
	ApplicationSessionUsage.CussApplicationID, CussApplications.Application AS CussApplication,	 
	SUM(ApplicationSessionUsage.MinutesInState) AS MinutesInState
    INTO [##TempApplicationSessionUsage]
FROM         ApplicationSessionUsage INNER JOIN
                      Airlines ON ApplicationSessionUsage.AirlineID = Airlines.ID INNER JOIN
                      AbdStation ON ApplicationSessionUsage.ABDStationID = AbdStation.ID INNER JOIN 
                      CussApplications ON ApplicationSessionUsage.CussApplicationID = CussApplications.CussApplicationID
WHERE     (ApplicationSessionUsage.Date BETWEEN @FromDateTime AND @ToDateTime) 
	AND (Airlines.Airline LIKE @Airline)
	AND (@CUSSApplicationID = 0 OR ApplicationSessionUsage.CussApplicationID = @CUSSApplicationID)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )		
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea ) 
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType, Airlines.Airline,ApplicationSessionUsage.AirlineID, ApplicationSessionUsage.CussApplicationID, CussApplications.Application
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea), Airlines.Airline, CussApplications.Application

 

--loop through to remove the duplicated values
DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	AbdStationName varchar(50)
	)    
INSERT INTO @MyTable(AbdStationName)	    
select AbdStationName 
from [##TempApplicationSessionUsage] 
group by AbdStationName
having count(*) > 1

--select * from @MyTable
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempAbdStationName varchar(50)
 

WHILE (1=1)
BEGIN
   
SELECT @TempAbdStationName = AbdStationName FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK



	if exists(select * from [##TempApplicationSessionUsage] where cast(AbdStationName as varchar) = cast(@TempAbdStationName as varchar))
	begin		 
		--Get Max value of MinutesInState
		declare @TempMax as float
		select @TempMax = max(isnull(MinutesInState, 0)) from [##TempApplicationSessionUsage] where AbdStationName = @TempAbdStationName
		delete from [##TempApplicationSessionUsage] where AbdStationName = @TempAbdStationName and MinutesInState < @TempMax 
	end
 
SELECT @Cnt = @Cnt + 1
		
END
--end loop

select 
AbdStationName,
AirlineID,
Airline,
CussApplicationID,
CussApplication,
SUM(MinutesInState) AS MinutesInState
from [##TempApplicationSessionUsage]
group by
AbdStationName, 
AirlineID,
Airline,
CussApplicationID,
CussApplication