declare @FromTime datetime = '2022-02-22 1:00:00 PM'
declare @ToTime datetime = '2022-07-31 1:00:00 PM'
declare @AbdStationID int = 54
declare @AbdStatesString varchar(4000) ='1,ManualOutOfOrder;2,Running;3,InError;4,OutOfOrder;5,HealthyNotAvailable;6,Unknown'
declare @StateTimeSlotsString varchar(4000) = '1,1;2,2;3,3;4,4;5,5;6,6;7,7;8,8;9,9;10,10;11,11;12,12;13,13;14,14;15,15;16,16;17,17;18,18;19,19;20,20;21,21;22,22;23,23;24,24'

;WITH DateTimeRange AS 
(
	SELECT @FromTime AS Date, 
		@FromTime AS FromTime,
		DATEADD(HOUR, 1, @FromTime) AS ToTime,  --add 1 hour from FromTime to be ToTime 
		DATEPART(HOUR, @FromTime) + 1 AS TimeSlotHourlyID --TimeSlotHourlyID is integer which is the value of current hour integer value plus 1
	UNION ALL
	SELECT DATEADD(DAY, 0, DATEDIFF(DAY, 0, DATEADD(HOUR, 1, FromTime))),  -- current FromTime adding 1 hour
		DATEADD(HOUR, 1, FromTime), --add 1 hour from FromTime to be FromTime
		DATEADD(HOUR, 1, ToTime),   --add 1 hour from ToTime to be ToTime
		DATEPART(HOUR, DATEADD(HOUR, 1, FromTime)) + 1 
	FROM DateTimeRange
	WHERE ToTime < @ToTime
)
SELECT * FROM DateTimeRange
OPTION (MAXRECURSION 0)	