declare @FromDateTime DateTime = '2018-01-01'
declare @ToDateTime DateTime = '2020-10-10'
--result: 2019-06-19 13:44:59.557

DROP TABLE IF EXISTS #TemptabPerHour

SELECT     Bag.ID, ISNULL(Bag.BagTagType,'') AS BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
                      bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
                      tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
INTO #TemptabPerHour
FROM         BagWeightUpdate AS bagt INNER JOIN
                          (SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
                      AS TransactionTime
FROM         CustomerSession INNER JOIN
                      BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
                      CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
                      CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
                      CustomerSession.SessionDuration
) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
Bag ON bagt.BagID = Bag.ID

SELECT     TimeSlotHourly.TimeSlotName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime,Min(TransactionTime.TransactionTime) AS MinTransactionTime, 
			MAX(TransactionTime.TransactionTime) AS MaxTransactionTime  , 'All' AS ABDStation, TransactionTime.UtcCreationTime
FROM        #TemptabPerHour as  TransactionTime INNER JOIN
                      TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
                      Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE 
Datepart(year, TransactionTime.UtcCreationTime) + '-' + Datepart(month, TransactionTime.UtcCreationTime) + '-' + Datepart(day, TransactionTime.UtcCreationTime)
  in (SELECT DISTINCT Datepart(year, ABDAvailability.Date) + '-' + Datepart(month, ABDAvailability.Date) + '-' + Datepart(day, ABDAvailability.Date)
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						  AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID)
GROUP BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName, TransactionTime.UtcCreationTime
ORDER BY TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName, TransactionTime.UtcCreationTime

--AND CustomerSession.LocalTime in 

--(SELECT ABDAvailability.Date
--	FROM         ABDAvailability INNER JOIN
--						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
--						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
--						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
--						  AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID)
 
 

-----------------------------------------------------------
SELECT      count(TransactionTime.UtcCreationTime), cast(TransactionTime.UtcCreationTime as date)
FROM        #TemptabPerHour as  TransactionTime INNER JOIN
                      TimeSlotHourly ON TransactionTime.TimeSlotHourlyID = TimeSlotHourly.ID INNER JOIN
                      Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
                      ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
WHERE 
Datepart(year, TransactionTime.UtcCreationTime) + '-' + Datepart(month, TransactionTime.UtcCreationTime) + '-' + Datepart(day, TransactionTime.UtcCreationTime)
  in (SELECT DISTINCT Datepart(year, ABDAvailability.Date) + '-' + Datepart(month, ABDAvailability.Date) + '-' + Datepart(day, ABDAvailability.Date)
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						  AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID)
GROUP BY  cast(TransactionTime.UtcCreationTime as date)
ORDER BY  count(TransactionTime.UtcCreationTime)

