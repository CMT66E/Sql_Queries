SELECT        DATEADD(DAY, DATEDIFF(DAY, 0, MIN(LocalTime)), 0) AS FirstDate
FROM            AbdStateHistory
WHERE        (AbdStationID = 49521)

-- Note: Here 0 means default Start Date which is 1900-01-01

SELECT MIN(LocalTime), DATEDIFF(DAY, 0, MIN(LocalTime)), DATEADD(DAY, DATEDIFF(DAY, 0, MIN(LocalTime)), 0), cast(cast(MIN(LocalTime) as date) as datetime)
FROM            AbdStateHistory
WHERE        (AbdStationID = 49521)


--Note: Here 0 means default Start Date which is 1900-01-01
select getdate() as Today,  DATEDIFF(DAY, 0, getdate()) as DayZeroDiff, DATEDIFF(DAY, '1900-01-01', getdate()) as DayZeroDiff_1900