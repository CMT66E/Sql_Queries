 declare @ConcatString varchar(50)
 set @ConcatString = '1030, 1111, 1095, 28'
 declare @selectClauseForRecord varchar(max)

 set @selectClauseForRecord = N'SELECT DISTINCT ' +  '  X.RadiationLocationID, LocationName, Street, Suburb, ' + 
'RecordNo, '  + 
'ResponsibleOfficer, ' + 
'Section, '  + 
'Postcode, '  + 
'StateCode, '  + 
'RRMNo, '  +  
'RRMType, '  + 
'Equipment '  +
'FROM dbo.viewSearchRadiationLocRRMResult X ' + 
'INNER JOIN tblInstrumentRadiationLocation A ON RecordNo = A.InstrumentID ' + 
'INNER JOIN tblInstrument B on RecordNo = B.InstrumentID ' + 
'WHERE B.InstrumentStatusID = 755 ' + 
'and X.RadiationLocationID IN(' + @ConcatString + ') and dbo.ufn_RadiationLicenceHasActiveVariation(RecordNo) = 0 and dbo.ufn_RadiationLicenceHasPendingRenewal(RecordNo) = 0'


declare @forLocationID varchar(400)
set @forLocationID = '1030'
SET @selectClauseForRecord = @selectClauseForRecord + ' AND RRMNo <> ' + convert(varchar, @forLocationID) + ' AND RRMStatusID = 785'
print '@selectClauseForRecord=' + @selectClauseForRecord 