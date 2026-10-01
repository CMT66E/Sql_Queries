
declare @InstrumentID int = 5024599
--original data
select * from tblBURadiationLicenceCondition where InstrumentID = @InstrumentID

--current data
select * from tblRadiationLicenceCondition where InstrumentID = @InstrumentID

select * from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationConditionID not in (select RadiationConditionID from tblBURadiationLicenceCondition where InstrumentID = @InstrumentID)


select * from tblRACReferral where InstrumentID = @InstrumentID and RadiationConditionID in (select RadiationConditionID from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationConditionID not in (select RadiationConditionID from tblBURadiationLicenceCondition where InstrumentID = @InstrumentID))

select * from tblRadiationLicenceExemptionCondition where InstrumentID = @InstrumentID and RadiationConditionID in (select RadiationConditionID from tblRadiationLicenceCondition where InstrumentID = @InstrumentID and RadiationConditionID not in (select RadiationConditionID from tblBURadiationLicenceCondition where InstrumentID = @InstrumentID)) 


------------------------------------------------------------------------
select * from tblRadiationLicenceFreeTextQualification where InstrumentID = 5007701 


select a.instrumentID, count(*) from tblBURadiationLicenceCondition a 
inner join tblInstrument b on a.InstrumentID = b.InstrumentID
inner join tblRadiationLicence c on a.InstrumentID = c.InstrumentID
where b.instrumentTypeID = 750 and c.RadiationLicenceTypeID = 795
group by a.instrumentID
having count(*) > 1


--current data
select a.*, b.* from tblRadiationLicenceCondition a 
inner join tblInstrument b on a.InstrumentID = b.InstrumentID
inner join tblRadiationLicence c on a.InstrumentID = c.InstrumentID
where b.instrumentTypeID = 750 and c.RadiationLicenceTypeID = 795


select a.instrumentID, count(*) from tblRadiationLicenceCondition a 
inner join tblInstrument b on a.InstrumentID = b.InstrumentID
inner join tblRadiationLicence c on a.InstrumentID = c.InstrumentID
where b.instrumentTypeID = 750 and c.RadiationLicenceTypeID = 795
group by a.instrumentID
having count(*) > 1

-- temp table					
                    DECLARE @MyTable1 TABLE -- old records
					(
						SNo int IDENTITY(1,1), 
						InstrumentID int,
						RecCount int,
						Flag varchar(5)
					)    
					insert into @MyTable1(InstrumentID, RecCount, Flag)
					select a.instrumentID, count(*), 'A' as Flag from tblBURadiationLicenceCondition a 
					inner join tblInstrument b on a.InstrumentID = b.InstrumentID
					inner join tblRadiationLicence c on a.InstrumentID = c.InstrumentID
					where b.instrumentTypeID = 750 and c.RadiationLicenceTypeID = 795
					group by a.instrumentID
					having count(*) > 1

                    DECLARE @MyTable2 TABLE -- new records
					(
						SNo int IDENTITY(1,1), 
						InstrumentID int,
						RecCount int,
						Flag varchar(5)
					) 
                    insert into @MyTable2(InstrumentID, RecCount, Flag)
					select a.instrumentID, count(*), 'B' as flag from tblRadiationLicenceCondition a 
					inner join tblInstrument b on a.InstrumentID = b.InstrumentID
					inner join tblRadiationLicence c on a.InstrumentID = c.InstrumentID
					where b.instrumentTypeID = 750 and c.RadiationLicenceTypeID = 795
					group by a.instrumentID
					having count(*) > 1


					select * from @MyTable1 order by instrumentID
					select * from @MyTable2 order by instrumentID

					select a.*, b.RecCount from @MyTable1 a  inner join @MyTable2 b on a.instrumentID = b.instrumentID
					where a.RecCount < b.RecCount