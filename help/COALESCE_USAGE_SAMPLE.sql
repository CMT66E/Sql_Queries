    declare @DGVehicleID int
	set  @DGVehicleID = 13900

	DECLARE @MyTable TABLE
	(
		SNo int IDENTITY(1,1), 
		ClassName varchar(500),
		UNNumber varchar(500) 
	)	
	
	insert into @MyTable	
	select  c.Name, v.UNNumber 
	from tblDGVehicleClass v
	left outer join tblClassification c on v.VehicleClassID=c.ClassificationID
	where v.DGVehicleID=@DGVehicleID
	order by C.SequenceOrder
	 

	--select * from @MyTable

	declare @VehicleClass varchar(150)	
	select  @VehicleClass = COALESCE(@VehicleClass+', ' ,'') + isnull(v.ClassName, '') + (case isnull(v.UNNumber, '') when '' then '' else '/' + isnull(v.UNNumber, '') end)
	from @MyTable v

	select @VehicleClass

	delete @MyTable
