  --Note: This script is dedicated for Dubai airport CussReportingDB_DXB database dummy data removal process, please run them by following the step sequence of this script
  --Date: 19-02-2021 Eric He

USE [CussReportingDB_DXB]
GO

---------------------------------delete actions below --------------------------------
  --step 1: Update Flight table change 9C carrier to EK => total 18826 records 
  update Flight set MarketingCarrier = 'EK' where MarketingCarrier = '9C'  
  print 'update 9C to EK (0 or 18826 records) from table Flight succeeded'
---------------------------------------------------------------------------------------------------------------------------------------
  --step 2: Remove dummy data from BagWeightUpdate table => total 307 records
  delete from BagWeightUpdate where CustomerSessionID in 
  (select a.ID from CustomerSession a inner join Flight b on a.FlightID = b.ID where a.FlightID in 
	  (
				  select ID from Flight where ID in 
				  (  
				  select ID from [dbo].[Flight]
				  where [MarketingCarrier] not in ('EK', 'FZ')
				  )
	  )
  ) 
  print 'remove dummy data (0 or 307 records) from table BagWeightUpdate succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 3: Remove dummy data rows from CustomerSession table which airine is not 'EK' or 'FZ' => total 451 records  
					   
  delete from CustomerSession where FlightID in 
  (select ID from Flight where ID in 
			  (  
			  select ID from [dbo].[Flight]
			  where [MarketingCarrier] not in ('EK', 'FZ')
			  )
  )  
  print 'remove dummy data (0 or 451 records) from table CustomerSession succeeded'
  
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 4: Remove dummy data rows from Flight table => total 144 records
  delete from Flight where MarketingCarrier not in ('EK', 'FZ') 
  print 'remove testing data (0 or 144 records) from table Flight succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 5: Remove dummy data rows from Airline table => total 21 records
  delete from Airlines where [Airline] not in ('EK', 'FZ') 
  print 'remove testing data (21 records) from table Airline succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 6: Remove dummy data rows from ABDAvailability table => total 100,998 records spanning from 2020-09-08 00:00:00.000 to 2020-10-14 00:00:00.000  
  --        Purpose here: those records referred ABD Stations are no longer existing in table AbdStation
  --                      so we don't need these records staying in table ABDAvailability which it will cause lot of useless rows been inserted by CUSS reporting engine daily
  delete from   
  [dbo].[ABDAvailability]
  where AbdStationID not in (select ID from [dbo].AbdStation)
  print 'remove testing data (100,998 records) from table ABDAvailability succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
 
     --step 7: Remove dummy data rows from AbdStateHistory table => total 2901 records
	 --        Purpose here: we delete those rows in AbdStateHistory which those ABD station ID are no longer existing in AbdStation table. So when system writing data into table ApplicationSessionUsage
	 --                      it will avoid to write those useless rows into it. This will reduce the number of records it has to insert from 496,800 to 43,200 rows based on my local CUSS engine running tests.
	 
  delete from AbdStateHistory where AbdStationID not in (select ID from [dbo].[AbdStation])
  print 'remove testing data (2901 records) from table AbdStateHistory succeeded'