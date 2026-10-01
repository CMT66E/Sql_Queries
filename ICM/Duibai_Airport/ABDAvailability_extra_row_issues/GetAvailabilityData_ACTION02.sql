SELECT        AbdStation.ID AS AbdStationID, ABDAvailability.*, ISNULL((DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)), '1900-1-1') AS LastDate,  
DATEADD(SECOND, 1, TimeSlotHourly.ToTime) as TimeSlotHourly_ToTime_Added_Second, 
DATEPART(HOUR,DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) as  TimeSlotHourly_ToTime_Added_Second_Hour,
StateTimeSlots.*,
TimeSlotHourly.*
FROM            ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD') and ABDStationID = 1107
and ABDAvailability.Date = '2021-01-28'
--GROUP BY AbdStation.ID
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT        AbdStation.ID AS AbdStationID, ABDAvailability.*, ISNULL((DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)), '1900-1-1') AS LastDate,  
DATEADD(SECOND, 1, TimeSlotHourly.ToTime) as TimeSlotHourly_ToTime_Added_Second, 
DATEPART(HOUR,DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) as  TimeSlotHourly_ToTime_Added_Second_Hour,
StateTimeSlots.*,
TimeSlotHourly.*
FROM            ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD') and ABDStationID = 1107
and ABDAvailability.Date = '2021-02-04'
--GROUP BY AbdStation.ID

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT        AbdStation.ID AS AbdStationID, ISNULL(MAX(DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)), '1900-1-1') AS LastDate 
FROM            ABDAvailability RIGHT OUTER JOIN
							AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
							StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
							TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID

				INNER JOIN AbdStation c on AbdStation.ID = c.ID
WHERE        (AbdStation.AbdType = 'ABD') and ABDStationID = 1107
and ABDAvailability.Date = '2021-02-04'
--GROUP BY AbdStation.ID, c.AbdType