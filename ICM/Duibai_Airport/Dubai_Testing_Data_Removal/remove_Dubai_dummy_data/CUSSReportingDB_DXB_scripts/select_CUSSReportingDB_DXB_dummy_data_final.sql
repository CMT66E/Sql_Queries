  --Note: This script is dedicated for Dubai airport CussReportingDB_DXB database dummy data select checking process, please run them by following the step sequence of this script
  --Date: 19-02-2021 Eric He

USE [CussReportingDB_DXB]
GO

---------------------------------select action below --------------------------------
  --step 1: Select Flight table change 9C carrier to EK => total 18826 records 
  select * from Flight where MarketingCarrier = '9C'  
  print 'select 9C MarketingCarrier (18826 records) from table Flight'
---------------------------------------------------------------------------------------------------------------------------------------
  --step 2: Select dummy data from BagWeightUpdate table => total 307 records
  select * from BagWeightUpdate where CustomerSessionID in 
  (select a.ID from CustomerSession a inner join Flight b on a.FlightID = b.ID where a.FlightID in 
	  (
				  select ID from Flight where ID in 
				  (  
				  select ID from [dbo].[Flight]
				  where [MarketingCarrier] not in ('EK', 'FZ')
				  )
	  )
  ) 
  print 'select dummy data (307 records) from table BagWeightUpdate'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 3: Select dummy data rows from CustomerSession table which airine is not 'EK' or 'FZ' => total 451 records  
					   
  select * from CustomerSession where FlightID in 
  (select ID from Flight where ID in 
			  (  
			  select ID from [dbo].[Flight]
			  where [MarketingCarrier] not in ('EK', 'FZ')
			  )
  )  
  print 'select dummy data 18999 rows affected (451 records) from table CustomerSession'
  
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 4: Select dummy data rows from Flight table => total 144 records
  delete from Flight where MarketingCarrier not in ('EK', 'FZ') 
  print 'remove testing data 18970 rows affected (144 records) from table Flight succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 5: Select dummy data rows from Airline table => total 21 records
  select * from Airlines where [Airline] not in ('EK', 'FZ') 
  print 'select testing data (21 records) from table Airline'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 6: Select dummy data rows from ABDAvailability table => total 100,998 records spanning from 2020-09-08 00:00:00.000 to 2020-10-14 00:00:00.000  
  --        Purpose here: those records referred ABD Stations are no longer existing in table AbdStation
  --                      so we don't need these records staying in table ABDAvailability which it will cause lot of useless rows been inserted by CUSS reporting engine daily
  select * from   
  [dbo].[ABDAvailability]
  where AbdStationID not in (select ID from [dbo].AbdStation)
  print 'select testing data (100,998 records) from table ABDAvailability succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
 
  --step 7: Select dummy data rows from AbdStateHistory table => total 2901 records
  select * from AbdStateHistory where AbdStationID not in (select ID from [dbo].[AbdStation])
  print 'select testing data (2901 records) from table AbdStateHistory succeeded'