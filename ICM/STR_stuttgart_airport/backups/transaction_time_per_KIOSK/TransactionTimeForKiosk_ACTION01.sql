declare     @FromDateTime DateTime = '2021-01-01 00:00:00'
declare     @ToDateTime DateTime = '2021-01-31 23:59:59'
declare     @FlightNumber nvarchar(100) = '%'
declare     @BoardPass nvarchar(25) = '%'
declare     @Airline nvarchar(25) = '%'
declare     @Terminal nvarchar(10) = '%'
declare     @Area nvarchar(10) = '%'
declare     @SubArea nvarchar(10) = '%'
declare     @ABDStationIDs varchar(400) = '0'
declare     @ABDStationNames varchar(4000) = 'Display All ABDs'


			 
				BEGIN
				IF OBJECT_ID('tempdb..##tempCusSessionKiosk') is not null
						DROP TABLE [dbo].[##tempCusSessionKiosk]

				IF OBJECT_ID('tempdb..##temptab') is not null
						DROP TABLE [dbo].[##temptab]		
				Select * into ##tempCusSessionKiosk  from CustomerSession Where LocalTime BETWEEN @FromDateTime AND @ToDateTime
 
 select * from ##tempCusSessionKiosk where SessionDuration > 3600
 --update ##tempCusSessionKiosk set SessionDuration = 3600 where SessionDuration > 3600
  select * from ##tempCusSessionKiosk where SessionDuration = 3600

				SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
									  CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
									  CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
									  CustomerSession.SessionDuration
									  INTO ##temptab
				FROM       ##tempCusSessionKiosk  CustomerSession 


				declare @TransactionTimeForKiosk table 
				(
				[AbdStationName]  varchar(50),
				[AvgSessionDuration] float,
				[MinSessionDuration] float,
				[MaxSessionDuration] float,
				[NumberOfCustomerTransactions] bigint
				)

				insert into  @TransactionTimeForKiosk
				SELECT     
				dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName, 
				Round(AVG(TransactionTimeKiosk.SessionDuration),0,2) AS AvgSessionDuration, 
				MIN(TransactionTimeKiosk.SessionDuration) AS MinSessionDuration, 
				MAX(TransactionTimeKiosk.SessionDuration) AS MaxSessionDuration,
				COUNT(TransactionTimeKiosk.ID) AS NumberOfCustomerTransactions

				FROM  ##temptab  AS TransactionTimeKiosk INNER JOIN
									  AbdStation ON TransactionTimeKiosk.AbdStationID = AbdStation.ID INNER JOIN
									  Flight ON TransactionTimeKiosk.FlightID = Flight.ID 
				WHERE     (CAST(Flight.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
					AND (Flight.MarketingCarrier LIKE @Airline)
					AND (AbdStation.Terminal LIKE @Terminal)
					AND (ISNULL(AbdStation.Area,'') LIKE @Area )		
					AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea ) 
					AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
				GROUP BY AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType
				ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType)

				select [AbdStationName],  
				isnull([AvgSessionDuration], 0) as AvgSessionDuration,
				isnull([MinSessionDuration], 0) as MinSessionDuration,
				isnull([MaxSessionDuration], 0) as MaxSessionDuration,
				isnull([NumberOfCustomerTransactions], 0) as NumberOfCustomerTransactions
				 from 
				 @TransactionTimeForKiosk 

				 END