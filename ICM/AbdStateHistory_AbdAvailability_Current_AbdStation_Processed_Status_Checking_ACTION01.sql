SELECT        AbdStation.ID AS AbdStationID, 
ISNULL(MAX(AbdStateHistory.ID), 0) AS LastProcessedID
FROM            AbdStateHistory RIGHT OUTER JOIN
                         AbdStation ON AbdStateHistory.AbdStationID = AbdStation.ID
WHERE        (AbdStation.AbdType = 'ABD') OR
                         (AbdStation.AbdType = 'KSK') OR
                         (AbdStation.AbdType = 'K')
GROUP BY AbdStation.ID 

------------------------------------------------------------------------------------

SELECT        AbdStation.ID AS AbdStationID, ISNULL(MAX((CASE WHEN DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) = 0 AND DATEPART(HOUR, TimeSlotHourly.FromTime) = '23' THEN DATEADD(HOUR, 24, 
                         ABDAvailability.Date) ELSE DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date) END)), '1900-1-1') AS LastDate
FROM            ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD') OR
                         (AbdStation.AbdType = 'KSK') OR
                         (AbdStation.AbdType = 'K')
GROUP BY AbdStation.ID
