--select top 10 a.* from OWTTC a 
--select top 10 b.* from OWTTCAssociatedEntity b
--select top 10 c.* from OWTWasteCode c

--select d.* from Classification d
--select e.* from Classification e
--select f.* from Classification f

 
 declare @PickUpActualStartDate smalldatetime
 declare @PickUpActualEndDate smalldatetime

 declare @ConsignorReportingStateCode varchar(200)
 set @ConsignorReportingStateCode = 'interstate'


		declare @DataA varchar(20)
		set @DataA = replace(@ConsignorReportingStateCode, ' ', '')

print '@DataA=' + @DataA


		declare @IntTableA TABLE ([ValueA] varchar(50) NULL)

		DECLARE @PtrA int 
		DECLARE @LengthA int
		DECLARE @vA nchar
		DECLARE @vvA nvarchar(100)

		SELECT @LengthA = (DATALENGTH(@DataA)) + 1, @PtrA = 1
                                  
		WHILE (@PtrA < @LengthA)
		BEGIN
		        print '@PtrA=' + cast(@PtrA as varchar)
				print '@LengthA=' + cast (@LengthA as varchar)				 

				if CHARINDEX (',', @DataA) > 0
				begin
					SET @vvA = SUBSTRING(@DataA, @PtrA, CHARINDEX (',', @DataA)-1)    
					print '@vvA=' + cast(@vvA as varchar)   
				                                  
					IF @vvA = ','
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

select * from @IntTableA

--select 
--	a.OWTTCID,
--	b.SiteName,
--	c.Code as WasteCode,
--	e.Code as WeightCode,
--	a.TCNumber, 
--	a.ArrivalWasteAmount, 
--	d.Code,	
--	f.Code,
--	a.PickUpActualDate  
--from OWTTC a 
--	left outer join OWTTCAssociatedEntity b on a.OWTTCID = b.OWTTCID
--	left outer join OWTWasteCode c on a.OWTWasteCodeID = c.OWTWasteCodeID
--	left outer join Classification d on b.AssociatedRoleTypeID = d.ClassificationID
--	left outer join Classification e on a.PickupWasteAmountWeightUnitTypeID = e.ClassificationID
--	left outer join Classification f on a.TCStatusTypeID = f.ClassificationID
--WHERE 
--	    a.ArrivalWasteAmount >= 50 
--	and e.Code = 'T'
--	and NOT f.Code in ('Created', 'Terminated')
--	and a.ConsignorReportingStateCode in (select ValueA from @IntTableA)
--	and (a.PickUpActualDate > '2006-07-01' and a.PickUpActualDate < '2014-07-01')
--	and d.Code = 'Consignor'



 --declare @PickUpActualStartDate smalldatetime
 --declare @PickUpActualEndDate smalldatetime
 --set @PickUpActualStartDate = '2006-07-01'
 --set @PickUpActualEndDate = '2014-07-01'

 --SELECT DATEDIFF(day,'2014-07-01','2014-07-01') AS DiffDate