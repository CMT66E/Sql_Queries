/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[Date]
      ,[ABDStationID]
      ,[StateTimeSlotID]
      ,[ABDStateID]
      ,[MinutesInState]
  FROM [CussReportingDB_STR].[dbo].[ABDAvailability]
  WHERE ABDStationID = 1 and Date = '2021-02-14'
  order by Date desc
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT    
AbdStation.ID AS AbdStationID, 
ISNULL(MAX(DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)), '1900-1-1') AS LastDate 
FROM ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD') 
and ABDStationID = 1 
and cast([Date] as date) = '2021-02-15'
GROUP BY AbdStation.ID
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT    
AbdStation.ID AS AbdStationID, 

DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date) AS LastDate,
DATEADD(SECOND, 1, TimeSlotHourly.ToTime) as AddSecond,
DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.FromTime)) as FromTimeHourValue,
DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) as ToTimeHourValue,
DATEPART(HOUR, TimeSlotHourly.ToTime) as ToTimeHourValuePure,
(case
  when DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) = 0 and DATEPART(HOUR, TimeSlotHourly.FromTime) = '23' then DATEADD(HOUR, 24, ABDAvailability.Date)
  else DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)
end) as LastDateImproved,

DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date) AS AvailabilityAfterAddedToTimeHourValue,
ABDAvailability.*,
TimeSlotHourly.*
FROM ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD' OR AbdStation.AbdType = 'KSK' OR AbdStation.AbdType = 'K') and ABDStationID = 1 and Date = '2021-02-14'
order by ABDAvailability.StateTimeSlotID
--GROUP BY AbdStation.ID
------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT    
AbdStation.ID AS AbdStationID, 
ISNULL(MAX((case
  when DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)) = 0 and DATEPART(HOUR, TimeSlotHourly.FromTime) = '23' then DATEADD(HOUR, 24, ABDAvailability.Date)
  else DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)
end)), '1900-1-1') AS LastDate
FROM ABDAvailability INNER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID INNER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD' OR AbdStation.AbdType = 'KSK' OR AbdStation.AbdType = 'K') and ABDStationID = 1 and Date = '2021-02-14'
GROUP BY AbdStation.ID


--The following lines are the latest version LastDate fetch script for CUSS reporting engine 15-02-2021
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