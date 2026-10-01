 
declare @ParentInstrumentID int = 5068515   
select * from tblInstrumentTransporterLocation where InstrumentID = @ParentInstrumentID
SELECT [TransporterLocationID]
      ,[LocationName]
      ,[AddressID]
      ,[AdditionalAddressInformation]
      ,[Notes]
      ,[EffectiveDateFrom]
      ,[EffectiveDateTo]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]      
  FROM [tblTransporterLocation]
  WHERE [TransporterLocationID] in (select [TransporterLocationID] from tblInstrumentTransporterLocation where InstrumentID = @ParentInstrumentID)


select * from tblInstrumentContact where InstrumentID = @ParentInstrumentID
select * from tblContact where ContactID in (select ContactID from tblInstrumentContact where InstrumentID = @ParentInstrumentID)