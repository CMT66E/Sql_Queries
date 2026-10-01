  --Notes: 
  --These scripts below will insert MH and NZ airline billing data into tables: AirlineGroup and AirlineGroupMapping, also they will update Flight datatable AirlineGroupID field
  --by calling stored procedure Update_AirlineGroupID by using those newly inserted airline codes: MH and NZ
  
  --Dedicated for Singapore Airport ReportingDB database and created on 17-12-2021 Eric He

  USE ReportingDB
  GO

  if not exists(select * from [AirlineGroup] where GroupName = 'Malaysia Airlines')
  begin
     declare @TempMHAirlineGroupID int = 0 
     insert into [AirlineGroup]([GroupName], [GroupDescription]) values ('Malaysia Airlines', 'Malaysia Airlines')
	 select @TempMHAirlineGroupID = @@IDENTITY

	 if not exists(select * from AirlineGroupMapping where AirlineGroupID = @TempMHAirlineGroupID)
	    insert into AirlineGroupMapping(AirlineGroupID, AirlineCode, AirlineName) values(@TempMHAirlineGroupID, 'MH', 'Malaysia Airlines')
  end
  else
  begin
      print 'Malaysia Airlines already existing in table [AirlineGroup], no data has been inserted' 
  end

  if not exists(select * from [AirlineGroup] where GroupName = 'Air New Zealand')
  begin
     declare @TempNZAirlineGroupID int = 0 
     insert into [AirlineGroup]([GroupName], [GroupDescription]) values ('Air New Zealand', 'Air New Zealand')
	 select @TempNZAirlineGroupID = @@IDENTITY

	 if not exists(select * from AirlineGroupMapping where AirlineGroupID = @TempNZAirlineGroupID)
	    insert into AirlineGroupMapping(AirlineGroupID, AirlineCode, AirlineName) values(@TempNZAirlineGroupID, 'NZ', 'Air New Zealand')
  end
  else
  begin
      print 'Air New Zealand already existing in table [AirlineGroup], no data has been inserted' 
  end

  Go 

  exec [dbo].[Update_AirlineGroupID]

  --verification queries below:
  select * from [AirlineGroup] 
  select * from AirlineGroupMapping  
  select * from Flight where MarketingCarrier in ('MH', 'NZ')