DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
ClassName varchar(500) 
)	
	
insert into @MyTable	
select  c.Name 
from tblDGVehicleClass v
inner join tblClassification c on v.VehicleClassID=c.ClassificationID
where v.DGVehicleID=10831
order by C.SequenceOrder

declare @VehicleClass varchar(150)	
select  @VehicleClass = COALESCE(@VehicleClass+', ' ,'') + v.ClassName
from @MyTable v

delete @MyTable

print '@VehicleClass=' + @VehicleClass
		 