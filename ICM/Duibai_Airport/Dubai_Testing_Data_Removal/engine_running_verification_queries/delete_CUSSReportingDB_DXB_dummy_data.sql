select * from Flight where MarketingCarrier = '9C' 
select * from Flight where MarketingCarrier not in ('EK', 'FZ')
select * from Airlines where [Airline] not in ('EK', 'FZ')

   select * from BagWeightUpdate where CustomerSessionID in 
  (select a.ID from CustomerSession a inner join Flight b on a.FlightID = b.ID where a.FlightID in 
	  (
				  select ID from Flight where ID in 
				  (  
				  select ID from [dbo].[Flight]
				  where [MarketingCarrier] not in ('EK', 'FZ')
				  )
	  )
  ) --307 records

select * from CustomerSession where FlightID in 
  (select ID from Flight where ID in 
			  (  
			  select ID from [dbo].[Flight]
			  where [MarketingCarrier] not in ('EK', 'FZ')
			  )
  ) 

---------------------------------delete action below --------------------------------
  --step 1: Update Flight table change 9C carrier to EK
  update Flight set MarketingCarrier = 'EK' where MarketingCarrier = '9C'  --total 18826 records will be updated
  print 'update 9C to EK (18826 records) from table Flight succeeded'
---------------------------------------------------------------------------------------------------------------------------------------
  --step 2: Remove dummy data from BagWeightUpdate table
  delete from BagWeightUpdate where CustomerSessionID in 
  (select a.ID from CustomerSession a inner join Flight b on a.FlightID = b.ID where a.FlightID in 
	  (
				  select ID from Flight where ID in 
				  (  
				  select ID from [dbo].[Flight]
				  where [MarketingCarrier] not in ('EK', 'FZ')
				  )
	  )
  ) --total 307 records
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 3: Remove dummy data rows from CustomerSession table which airine is not 'EK' or 'FZ'
					   
  delete from CustomerSession where FlightID in 
  (select ID from Flight where ID in 
			  (  
			  select ID from [dbo].[Flight]
			  where [MarketingCarrier] not in ('EK', 'FZ')
			  )
  ) --total 451 records  
  print 'remove dummy data (451 records) from table CustomerSession succeeded'
  
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 4: Remove dummy data rows from Flight table
  delete from Flight where MarketingCarrier not in ('EK', 'FZ') -- total 144 records
  print 'remove testing data (144 records) from table Flight succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------
  --step 5: Remove dummy data rows from Airline table
  delete from Airlines where [Airline] not in ('EK', 'FZ') -- total 21 records
  print 'remove testing data (21 records) from table Airline succeeded'
   ---------------------------------------------------------------------------------------------------------------------------------------