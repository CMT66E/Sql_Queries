
declare @FromDateTime DateTime = '2021-04-01 00:00:00'
declare @ToDateTime DateTime = '2021-04-30 23:59:00'
declare @TimeSlotID int = 0
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = ' Display All ABDs'



SELECT     AbdStation.ID AS AbdStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType) AS AbdStationName, 
	ABDStates.ID AS AbdStateID, ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
FROM         ABDAvailability INNER JOIN
						ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
	AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	--AND AbdStation.AbdType = 'K'
	--AND ABDStates.ID = 3 
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	AND AbdStation.AbdType ='K'
	AND AbdStation.KioskName in (  SELECT  distinct  
      [KioskName]   
  FROM [CUSSReportingDB_STR].[dbo].[AbdStation]
  WHERE Terminal = 'STR1' and [AbdType] ='K')
 
GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,ABDStates.ID, AbdStation.AbdType, ABDStates.State
ORDER BY SUM(ABDAvailability.MinutesInState) desc, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType), ABDStates.State
-------------------
SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType) AS AbdStationName, 
	ABDStates.ID AS AbdStateID, ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
FROM         ABDAvailability INNER JOIN
						ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
	AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	--AND AbdStation.AbdType = 'K'
	--AND ABDStates.ID = 3 
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	AND AbdStation.AbdType ='K'
	AND AbdStation.KioskName in (  SELECT  distinct  
      [KioskName]   
  FROM [CUSSReportingDB_STR].[dbo].[AbdStation]
  WHERE Terminal = 'STR1' and [AbdType] ='K')
 
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,ABDStates.ID, AbdStation.AbdType, ABDStates.State
having  SUM(ABDAvailability.MinutesInState) > 0
ORDER BY SUM(ABDAvailability.MinutesInState) desc, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType), ABDStates.State

	DECLARE @MyTable TABLE
	(
	AbdStationID int IDENTITY(1,1), 
	AbdStationName varchar(50),
	AbdStateID int,
	[State] varchar(50),
	MinutesInState float 
	)    

insert into @MyTable
SELECT     dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType) AS AbdStationName, 
	ABDStates.ID AS AbdStateID, ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
FROM         ABDAvailability INNER JOIN
						ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
	AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea ) 
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	AND AbdStation.AbdType ='K'
	AND AbdStation.KioskName in (  SELECT  distinct  
      [KioskName]   
  FROM [CUSSReportingDB_STR].[dbo].[AbdStation]
  WHERE Terminal = 'STR1' and [AbdType] ='K')
 
GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,ABDStates.ID, AbdStation.AbdType, ABDStates.State
having  SUM(ABDAvailability.MinutesInState) > 0
ORDER BY SUM(ABDAvailability.MinutesInState) desc, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea, AbdStation.AbdType), ABDStates.State

select AbdStationID, AbdStationName, AbdStateID, [State], MinutesInState from @MyTable order by AbdStationName
-------------------------

--SELECT     AbdStation.ID AS AbdStationID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
--ABDStates.ID AS AbdStateID, ABDStates.State, SUM(ABDAvailability.MinutesInState) as MinutesInState
--FROM         ABDAvailability INNER JOIN
--					ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
--					StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
--					TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
--					AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
--WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
--AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
--AND (AbdStation.Terminal LIKE @Terminal)
--AND (ISNULL(AbdStation.Area,'') LIKE @Area )
--AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
--AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

--AND ABDStates.ID = 3 
----AND MinutesInState > 0

--GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,ABDStates.ID, ABDStates.State
--ORDER BY  AbdStation.ID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), ABDStates.State

--------------------------------

--select * from AbdStation where ID in
--(
--	SELECT     AbdStation.ID  
--FROM         ABDAvailability INNER JOIN
--						ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
--						StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
--						TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
--						AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
--WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
--	AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
--	AND (AbdStation.Terminal LIKE @Terminal)
--	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
--	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
--	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)

--	AND ABDStates.ID = 3 and MinutesInState > 0

--GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,ABDStates.ID, ABDStates.State
	 
--)