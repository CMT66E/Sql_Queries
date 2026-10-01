declare @FromDateTime DateTime = '2023-01-01 00:00:00'
declare @ToDateTime DateTime = '2023-01-31 23:59:00'
declare @TimeSlotID int = 0
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = ' Display All ABDs'


SELECT
AbdStation.ID AS AbdStationID, 
(SELECT CASE WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') <> ''
						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.AbdType + '_' + AbdStation.SubArea + '_' + AbdStation.Identifier
					WHEN ISNULL(AbdStation.Terminal,'') <> '' AND ISNULL(AbdStation.Area,'') <> '' AND ISNULL(AbdStation.SubArea,'') = ''
						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.Area + '_' + AbdStation.AbdType  + '_' + AbdStation.Identifier
					WHEN ISNULL(AbdStation.Terminal,'') <> '' And (select Count(*) From abdstation Where  ABDType ='ABD' and Terminal <> AbdStation.Terminal) > 0
						THEN (case when LEN(AbdStation.Terminal) > 1 then 'T' else 'T0' end) + AbdStation.Terminal + '_' + AbdStation.AbdType  + '_'  + AbdStation.Identifier + '  '
					WHEN ISNULL(AbdStation.Terminal,'') ='' AND  ISNULL(AbdStation.Area,'') <> ''
						THEN AbdStation.Area + '_' + AbdStation.AbdType + '_'  + AbdStation.Identifier
					ELSE AbdStation.Identifier END) AS AbdStationName,

--dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName, 

ABDStates.ID AS AbdStateID, 
ABDStates.State, 
SUM(ABDAvailability.MinutesInState) as MinutesInState

FROM         
CustomerSession INNER JOIN 
ABDAvailability ON CustomerSession.AbdStationID = ABDAvailability.ABDStationID INNER JOIN 
ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID

WHERE     
    CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
    AND (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
	AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType,ABDStates.ID, ABDStates.State
ORDER BY AbdStation.ID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType), ABDStates.State

-----------------------------------
--declare @TempTbl TABLE
--(
--    AbdStationID int
--)

--insert into @TempTbl
--SELECT

--DISTINCT AbdStation.ID  
 
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
--GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType,ABDStates.ID, ABDStates.State
----ORDER BY AbdStation.ID, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType), ABDStates.State

--select * from @TempTbl

--select DISTINCT AbdStationID from CustomerSession
--where LocalTime BETWEEN @FromDateTime AND @ToDateTime