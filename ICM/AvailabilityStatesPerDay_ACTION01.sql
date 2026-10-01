declare @FromDateTime DateTime = '2022-02-01 00:00:00'
declare @ToDateTime DateTime = '2022-02-28 23:59:00'
declare @TimeSlotID int = 0
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = 'Display All ABDs'

SELECT     
ABDAvailability.Date,
@ABDStationNames AS ABDStations, 
ABDStates.ID AS AbdStateID,  
ABDStates.State, 
SUM(ABDAvailability.MinutesInState) as MinutesInState

FROM        ABDAvailability INNER JOIN
            ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
            StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
            TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID INNER JOIN
            ABDStation ON ABDStation.ID = ABDAvailability.ABDStationID
WHERE        (ABDAvailability.Date BETWEEN @FromDateTime AND @ToDateTime)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
	AND (TimeSlotHourly.ID > 4  AND TimeSlotHourly.ID < 23)
GROUP BY ABDAvailability.Date, ABDStates.ID, ABDStates.State
ORDER BY ABDAvailability.Date, ABDStates.State