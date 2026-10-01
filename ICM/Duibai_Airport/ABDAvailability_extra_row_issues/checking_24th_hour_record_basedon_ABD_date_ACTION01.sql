
select * from ABDAvailability where ID in
(
SELECT        TOP (6) ID 
FROM            ABDAvailability
WHERE  (CAST([Date] AS Date) = '2021-02-05') and StateTimeSlotID = 24
ORDER by ID DESC
)


SELECT        *
FROM            ABDAvailability
WHERE  (CAST([Date] AS Date) = '2021-02-16') and StateTimeSlotID = 24 
and ABDStationID = 5
ORDER by ID ASC