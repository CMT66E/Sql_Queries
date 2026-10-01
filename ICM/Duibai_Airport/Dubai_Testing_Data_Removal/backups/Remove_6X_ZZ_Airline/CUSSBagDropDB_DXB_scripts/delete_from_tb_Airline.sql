

------------- select action -------------------------------
  select * from [dbo].[Airline]
  where [Name] in ('6X', 'ZZ')
 
  select * from ApplicationSession where AirlineId in 
  (  
  select AirlineId from [dbo].[Airline]
  where [Name] in ('6X', 'ZZ')
  )

  select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where AirlineId in 
			  (  
			  select AirlineId from [dbo].[Airline]
			  where [Name] in ('6X', 'ZZ')
			  )
  )

  ------------- delete action -------------------------------
  delete from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where AirlineId in 
			  (  
			  select AirlineId from [dbo].[Airline]
			  where [Name] in ('6X', 'ZZ')
			  )
  )
  print 'remove testing data (277 records) from table CustomerSession succeeded'

  delete from ApplicationSession where AirlineId in 
  (  
  select AirlineId from [dbo].[Airline]
  where [Name] in ('6X', 'ZZ')
  )
  print 'remove testing data (437 records) from table ApplicationSession succeeded'

  delete from [dbo].[Airline]
  where [Name] in ('6X', 'ZZ')
  print 'remove testing data (2 records) from table Airline succeeded'

