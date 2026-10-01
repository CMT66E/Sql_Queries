SELECT        AbdStation.ID AS AbdStationID, 
				ISNULL(MAX((case
				  when DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) = 0 and DATEPART(HOUR, TimeSlotHourly.FromTime) = '23' then DATEADD(HOUR, 24, ABDAvailability.Date)
				  else DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)
				end)), '1900-1-1') AS LastDate
FROM            ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD' OR AbdStation.AbdType = 'KSK' OR AbdStation.AbdType = 'K')
GROUP BY AbdStation.ID 
order by ISNULL(MAX((case
				  when DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) = 0 and DATEPART(HOUR, TimeSlotHourly.FromTime) = '23' then DATEADD(HOUR, 24, ABDAvailability.Date)
				  else DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)
				end)), '1900-1-1') 