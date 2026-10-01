declare @FromDateTime datetime = '2019-06-01'
declare @ToDateTime datetime = '2019-06-30'
declare @BdsServerTypeID INT = 0
declare @Terminal nvarchar(10)  = '%'
declare @Area nvarchar(10)  = '%'
declare @SubArea nvarchar(10)  = '%'
declare @ABDStationIDs varchar(400)  = '0'
declare @ABDStationNames varchar(4000)  = '%'

SELECT     Bag.ID, Bag.BagTagType, tempt.ID AS CustomerSessionID, tempt.AbdStationID, tempt.CustomerLookupType, tempt.FlightID, tempt.CustomerID, tempt.PNR, 
						bagt.TimeSlot5minID, bagt.TimeSlot10minID, bagt.TimeSlotHourlyID, bagt.DayOfTheWeekID, bagt.LocalTime, tempt.SessionDuration, tempt.BagCount, 
						tempt.TransactionTime, tempt.UtcCreationTime, tempt.UtcCompletionTime
INTO  #tempTab
FROM         BagWeightUpdate AS bagt INNER JOIN
							(SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
						CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
						CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
						CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) 
						AS TransactionTime
FROM         CustomerSession INNER JOIN
						BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID AND BagWeightUpdate.UtcTime BETWEEN CustomerSession.UtcCreationTime AND CustomerSession.UtcCompletionTime
WHERE CustomerSession.LocalTime BETWEEN @FromDateTime AND @ToDateTime
GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
						CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
						CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
						CustomerSession.SessionDuration
) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
	Bag ON bagt.BagID = Bag.ID
 
select * from #tempTab


declare @rwCount int
Select @rwCount = count(AbdStationID) from BdsAbdMapping


If @BdsServerTypeID = 0
BEGIN
	IF @rwCount > 0
	BEGIN	 
		SELECT      B.ServerName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
								MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
		FROM         #tempTab AS TransactionTime INNER JOIN
								Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
								ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
								JOIN BdsAbdMapping ON ABDStation.ID = BdsAbdMapping.AbdStationID
								JOIN BDSServerType B ON B.ID = BdsAbdMapping.BdsServerID
		WHERE  (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		Group by B.ServerName
	END
	ELSE
	BEGIN
		SELECT      dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) as ServerName, 
		CONVERT(DECIMAL(10,2),AVG(TransactionTime.TransactionTime)) AS AvgTransactionTime, 
		MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
		MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
		FROM         #tempTab AS TransactionTime INNER JOIN
								Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
								ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
		WHERE  (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		Group by dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)
	END
END
ELSE
BEGIN
    IF @rwCount > 0
	BEGIN
		SELECT      B.ServerName,AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
									MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
			FROM         #tempTab AS TransactionTime INNER JOIN
									Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
									ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
									JOIN BdsAbdMapping ON ABDStation.ID = BdsAbdMapping.AbdStationID
									JOIN BDSServerType B ON B.ID = BdsAbdMapping.BdsServerID
		WHERE B.ID = @BdsServerTypeID 
					AND (AbdStation.Terminal LIKE @Terminal )
					AND (ISNULL(AbdStation.Area,'') LIKE @Area )
					AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
					AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		Group by B.ServerName
	END
	ELSE
	BEGIN
		SELECT  dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) as ServerName, AVG(TransactionTime.TransactionTime) AS AvgTransactionTime, MIN(TransactionTime.TransactionTime) AS MinTransactionTime, 
									MAX(TransactionTime.TransactionTime) AS MaxTransactionTime
			FROM         #tempTab AS TransactionTime INNER JOIN
									Flight ON TransactionTime.FlightID = Flight.ID INNER JOIN
									ABDStation ON ABDStation.ID = TransactionTime.ABDStationID
		WHERE AbdStation.ID = @BdsServerTypeID 
					AND (AbdStation.Terminal LIKE @Terminal )
					AND (ISNULL(AbdStation.Area,'') LIKE @Area )
					AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
					AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
		Group by dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea)
	END
END

DROP TABLE #tempTab