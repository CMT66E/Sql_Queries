declare @InstrumentID int
set @InstrumentID = 5065531 

select * from tblInstrument where InstrumentID = @InstrumentID
select * from tblInstrumentAccountableParty where InstrumentID = @InstrumentID
select * from tblInstrumentContact where InstrumentID = @InstrumentID
select * from tblDGDesignApproval where InstrumentID = @InstrumentID
select * from tblInstrumentContact where InstrumentID = @InstrumentID
select * from tblDGDesignApprovalClassUN where InstrumentID = @InstrumentID
select * from tblDGDesignApprovalTankMake where InstrumentID = @InstrumentID
select * from tblDGDesignApprovalVehicleMake where InstrumentID = @InstrumentID