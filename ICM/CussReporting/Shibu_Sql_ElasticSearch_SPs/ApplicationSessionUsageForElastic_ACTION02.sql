    DECLARE @FromDateTime DATETIME ='2021-10-07 00:00:00.000'
	DECLARE @ToDateTime DATETIME ='2021-10-07 00:00:00.000'

 -----Select @FromDateTime='2021-08-03 00:00:00.000',@ToDateTime='2021-08-03 00:00:00.000'
    DROP TABLE IF EXISTS #temp


    Select * into #temp From(
	SELECT   ApplicationSessionUsage.Date,  dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName, 
     Airlines.Airline,  
     CussApplications.Application AS CussApplication,
	 SUM(ApplicationSessionUsage.MinutesInState) AS MinutesInState
	FROM         ApplicationSessionUsage INNER JOIN
						  Airlines ON ApplicationSessionUsage.AirlineID = Airlines.ID INNER JOIN
						  AbdStation ON ApplicationSessionUsage.ABDStationID = AbdStation.ID INNER JOIN 
						  CussApplications ON ApplicationSessionUsage.CussApplicationID = CussApplications.CussApplicationID
	WHERE     (ApplicationSessionUsage.Date BETWEEN @FromDateTime AND @ToDateTime) 
	GROUP BY ApplicationSessionUsage.Date,AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType, Airlines.Airline, CussApplications.Application
	) Z
	
	--start test line
		  SELECT
			[AbdStationName],
			[Date],
			[Airline],
			[CussApplication],
			[MinutesInState]
		  FROM #temp
	--end test line

	SELECT  [AbdStationName],
			[Date],
			[Airline],
            isnull([ICM-AirApp], 0) as [ICM-AirApp],
			isnull([SSK], 0) as [SSK],
			isnull([ABD], 0) as [ABD]			
			FROM (
		  SELECT
			[AbdStationName],
			[Date],
			[Airline],
			[CussApplication],
			[MinutesInState]
		  FROM #temp
		) Test
		PIVOT (
		  SUM([MinutesInState])
		  FOR [CussApplication]
		  IN (
			[ICM-AirApp],
			[SSK],
			[ABD]
		  )
		) AS PivotTable
