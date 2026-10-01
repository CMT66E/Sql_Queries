  select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where AirlineId in (select AirlineId from dbo.Airline WHERE Name = 'AY'))
  select * from ApplicationSession where AirlineId in (select AirlineId from dbo.Airline WHERE Name = 'AY')   
  select * from dbo.Airline where Name = 'AY'
 
  select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where AirlineId in (select AirlineId from dbo.Airline WHERE Name = 'NZ'))
  select * from ApplicationSession where AirlineId in (select AirlineId from dbo.Airline WHERE Name = 'NZ')   
  select * from dbo.Airline where Name = 'NZ'