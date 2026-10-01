  select * from CustomerSession where ID in (select CussApplicationId from ApplicationSessionUsageProcess where AirlineId in (select AirlineId from dbo.Airlines WHERE Airline = 'ZZ'))
  select * from ApplicationSessionUsageProcess where AirlineId in (select AirlineId from dbo.Airlines WHERE Airline = 'ZZ')   
  select * from dbo.Airlines where Airline = 'ZZ'
 
  select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where AirlineId in (select AirlineId from dbo.Airline WHERE Name = '6X'))
  select * from ApplicationSession where AirlineId in (select AirlineId from dbo.Airline WHERE Name = '6X')   
  select * from dbo.Airline where Name = '6X'