  --Note: This script is dedicated for Dubai airport CUSSBagDropDB_DXB database dummy data removal process, please run them by following the step sequence of this script
  --Date: 19-02-2021 Eric He

USE [CUSSBagDropDB_DXB]
GO

   
  ---------------------------------------------------------------------------------------------------------------------------------------
  --step 1: Update Flight table change 9C carrier to EK => total 18826 records will be updated
  update Flight set MarketingCarrier = 'EK' where MarketingCarrier = '9C'   
  print 'update 9C to EK (18826 records) from table Flight succeeded'

  ---------------------------------------------------------------------------------------------------------------------------------------
  --step 2: Remove dummy data from BagWeightUpdate table => --total 312 records
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
  print 'remove dummy data (312 records) from table BagWeightUpdate succeeded'
  ---------------------------------------------------------------------------------------------------------------------------------------
  --step 3: Remove dummy data rows from CustomerSession table which airine is not 'EK' or 'FZ' => total 453 records  
				 
  delete from CustomerSession where FlightID in 
  (select ID from Flight where ID in 
			  (  
			  select ID from [dbo].[Flight]
			  where [MarketingCarrier] not in ('EK', 'FZ')
			  )
  ) 
  print 'A. remove dummy data (453 records) from table CustomerSession succeeded'

 ----------Remove dummy data rows from CustomerSession table which ApplicationSessionId linked Airline is not 'EK' or 'FZ' => total 277 records
  delete from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where AirlineId in 
			  (  
			  select AirlineId from [dbo].[Airline]
			  where [Name] not in ('EK', 'FZ')
			  )
  )
  print 'B. remove dummy data (277 records) from table CustomerSession succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------

  --step 4: Remove dummy data rows from ApplicationSession which Airline is not 'EK' or 'FZ'
  delete from ApplicationSession where AirlineId in 
  (  
	  select AirlineId from [dbo].[Airline]
	  where [Name] not in ('EK', 'FZ')
  )
  print 'remove testing data (437 records) from table ApplicationSession succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 5: Remove dummy data rows from Flight table
  delete from Flight where MarketingCarrier not in ('EK', 'FZ') -- total 144 records
  print 'remove testing data (144 records) from table Flight succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 6: Remove dummy data rows from Airline table
  delete from Airline where [Name] not in ('EK', 'FZ') -- total 21 records
  print 'remove testing data (21 records) from table Airline succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------