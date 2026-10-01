 
select 
NSWDesignApprovalID, 
cast((case when NSWDesignApprovalID = 0 then '' when NSWDesignApprovalID <= 2000 then cast(NSWDesignApprovalID as varchar) else '' end) as varchar) as [OldLicenceNumber], 
* 
from [dbo].[tblDGDesignApproval] WHERE InstrumentID = 5065518

select * from tblDGDesignApproval where InstrumentID = 5065519
select * from tblInstrumentAccountableParty where InstrumentID = 5065519
select * from tblInstrumentContact where InstrumentID = 5065519
select * from tblDGDesignApprovalClassUN where InstrumentID = 5065519
select * from tblDGDesignApprovalTankMake where InstrumentID = 5065519
select * from tblDGDesignApprovalVehicleMake where InstrumentID = 5065519

delete from tblInstrumentAccountableParty where InstrumentID = 5065519
delete from tblInstrumentContact where InstrumentID = 5065519
delete from tblDGDesignApprovalClassUN where InstrumentID = 5065519
delete from tblDGDesignApprovalTankMake where InstrumentID = 5065519
delete from tblDGDesignApprovalVehicleMake where InstrumentID = 5065519
delete from tblDGDesignApproval where InstrumentID = 5065519