 declare @PickUpActualStartDate smalldatetime
 declare @PickUpActualEndDate smalldatetime

 --set @PickUpActualStartDate = null
 --set @PickUpActualEndDate = null
 
 set @PickUpActualStartDate = '2006-07-01'
 set @PickUpActualEndDate = '2007-07-01'
 


 declare @ConsignorReportingStateCode varchar(200)
 set @ConsignorReportingStateCode = 'n/a, nsw'


declare @DataA varchar(20)
set @DataA = replace(@ConsignorReportingStateCode, ' ', '') 
declare @IntTableA TABLE ([ValueA] varchar(50) NULL)

DECLARE @PtrA int 
DECLARE @LengthA int
DECLARE @vA nchar
DECLARE @vvA nvarchar(100)

SELECT @LengthA = (DATALENGTH(@DataA)) + 1, @PtrA = 1
                                  
WHILE (@PtrA < @LengthA)
BEGIN
		     
				if CHARINDEX (',', @DataA) > 0
				begin			    
					SET @vA = SUBSTRING(@DataA, @PtrA, 1)    
			 
					IF @vA = ','
						BEGIN
								INSERT INTO @IntTableA (ValueA) VALUES (CAST(@vvA AS varchar(20)))
								SET @vvA = NULL
						END
					ELSE
						BEGIN
								SET @vvA = ISNULL(@vvA, '') + @vA 						                                            
						END
			    end
			    else
				    if len(@DataA) > 0
						SET @vvA = @DataA
			  
		SET @PtrA = @PtrA + 1
END

IF @PtrA = @LengthA AND len(@vvA) > 0
BEGIN
		INSERT INTO @IntTableA (ValueA) VALUES (CAST(@vvA AS varchar(20)))
		SET @vvA = NULL
END

if exists(select * from @IntTableA)
begin
	select 
		a.OWTTCID,
		b.SiteName,
		c.Code as WasteCode,
		e.Code as WeightCode,
		a.TCNumber, 
		a.ArrivalWasteAmount, 
		d.Code as RoleCode,	
		f.Code as StatusCode,
		a.PickUpActualDate  
	from OWTTC a 
		left outer join OWTTCAssociatedEntity b on a.OWTTCID = b.OWTTCID
		left outer join OWTWasteCode c on a.OWTWasteCodeID = c.OWTWasteCodeID
		left outer join Classification d on b.AssociatedRoleTypeID = d.ClassificationID
		left outer join Classification e on a.PickupWasteAmountWeightUnitTypeID = e.ClassificationID
		left outer join Classification f on a.TCStatusTypeID = f.ClassificationID
	WHERE 
		a.ArrivalWasteAmount >= 50 
		and e.Code = 'T'
		and NOT f.Code in ('Created', 'Terminated')
		and a.ConsignorReportingStateCode in (select ValueA from @IntTableA)

		and 
		(
			a.PickUpActualDate >= (case isnull(@PickUpActualStartDate, '') when '' then a.PickUpActualDate else @PickUpActualStartDate end) 
			and 
			a.PickUpActualDate <= (case isnull(@PickUpActualEndDate, '') when '' then a.PickUpActualDate else @PickUpActualEndDate end)
		)
	
		and d.Code = 'Consignor'
end
else
begin
	select 
		a.OWTTCID,
		b.SiteName,
		c.Code as WasteCode,
		e.Code as WeightCode,
		a.TCNumber, 
		a.ArrivalWasteAmount, 
		d.Code as RoleCode,	
		f.Code as StatusCode,
		a.PickUpActualDate  
	from OWTTC a 
		left outer join OWTTCAssociatedEntity b on a.OWTTCID = b.OWTTCID
		left outer join OWTWasteCode c on a.OWTWasteCodeID = c.OWTWasteCodeID
		left outer join Classification d on b.AssociatedRoleTypeID = d.ClassificationID
		left outer join Classification e on a.PickupWasteAmountWeightUnitTypeID = e.ClassificationID
		left outer join Classification f on a.TCStatusTypeID = f.ClassificationID
	WHERE 
		a.ArrivalWasteAmount >= 50 
		and e.Code = 'T'
		and NOT f.Code in ('Created', 'Terminated')		 
		and 
		(
			a.PickUpActualDate >= (case isnull(@PickUpActualStartDate, '') when '' then a.PickUpActualDate else @PickUpActualStartDate end) 
			and 
			a.PickUpActualDate <= (case isnull(@PickUpActualEndDate, '') when '' then a.PickUpActualDate else @PickUpActualEndDate end)
		)
	
		and d.Code = 'Consignor'
end



GRANT EXECUTE ON [dbo].[uspOWTAccOpWasteCodeUpdateOffFlagUpdate] TO OWTReadWriteRole