  --Note: This script is dedicated for Dubai airport CUSSBagDropDB_DXB database dummy data checking process, please run them by following the step sequence of this script
  --Date: 19-02-2021 Eric He


USE [CUSSBagDropDB_DXB]
GO


   
  ---------------------------------------------------------------------------------------------------------------------------------------
  --step 1: check Flight table the number of rows of 9C carrier => total 18826 records will be updated
  select * from Flight where MarketingCarrier = '9C'   
  print 'find 9C MarketCarrier (18826 records) from table Flight'

  ---------------------------------------------------------------------------------------------------------------------------------------
  --step 2: Check dummy data from BagWeightUpdate table => --total 312 records
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
  print 'find dummy data 19212 row checked in CustomerSession and (312 records) from table BagWeightUpdate'
  ---------------------------------------------------------------------------------------------------------------------------------------
  --step 3: Check dummy data rows from CustomerSession table which airine is not 'EK' or 'FZ' => total 453 records  
				 
  select * from CustomerSession where FlightID in 
  (select ID from Flight where ID in 
			  (  
			  select ID from [dbo].[Flight]
			  where [MarketingCarrier] not in ('EK', 'FZ')
			  )
  ) 
  print 'A. find dummy data 19212 rows affected in flight table and (453 records will be removed) from table CustomerSession'

 ----------Remove dummy data rows from CustomerSession table which ApplicationSessionId linked Airline is not 'EK' or 'FZ' => total 277 records
  select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where AirlineId in 
			  (  
			  select AirlineId from [dbo].[Airline]
			  where [Name] not in ('EK', 'FZ')
			  )
  )
  print 'B. find dummy data (277 records) from table CustomerSession'
   ---------------------------------------------------------------------------------------------------------------------------------------

  --step 4: find dummy data rows from ApplicationSession which Airline is not 'EK' or 'FZ'
  select * from ApplicationSession where AirlineId in 
  (  
	  select AirlineId from [dbo].[Airline]
	  where [Name] not in ('EK', 'FZ')
  )
  print 'find testing data (437 records) from table ApplicationSession'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 5: Remove dummy data rows from Flight table
  select * from Flight where MarketingCarrier not in ('EK', 'FZ') -- total 144 records
  print 'find testing data 18970 rows searched in Flight and in (144 records) from table Flight'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 6: Remove dummy data rows from Airline table
  select * from Airline where [Name] not in ('EK', 'FZ') -- total 21 records
  print 'find testing data (21 records) from table Airline'
   ---------------------------------------------------------------------------------------------------------------------------------------