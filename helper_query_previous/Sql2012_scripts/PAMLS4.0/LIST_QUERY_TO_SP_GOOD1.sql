



 declare @OriginStateCode varchar(200) = null
 declare @ArrivalStartDate smalldatetime = null
 declare @ArrivalEndDate smalldatetime = null

 set @ArrivalStartDate = '2006-07-01'
 set @ArrivalEndDate = '2007-07-01'
 set @OriginStateCode = 'interstate'

 declare @DataA varchar(20)

			set @DataA = replace(@OriginStateCode, ' ', '') 
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

select * from @IntTableA

			if exists(select * from @IntTableA)
			begin
			         if exists(select * from @IntTableA where ValueA = 'INTERSTATE')
					 begin
						 
						 delete from @IntTableA where ValueA = 'INTERSTATE'
						 declare @LeftCount int
						 select @LeftCount = Count(*) from @IntTableA

print '@LeftCount= ' + cast(@LeftCount as varchar)

						 if @LeftCount > 0 
						 begin
							 SELECT 
							 OWTTC.OWTTCID,
							 OWTTC.PickUpActualDate, 
							 OWTTC.ConsignorReportingStateCode, 
							 Classification.Code as StatusCode, 
							 OWTTC.TCNumber, 
							 OWTWasteCode.Code as WasteCode, 
							 OWTTC.ArrivalWasteAmount, 
							 Classification_1.Code as WeightCode, 
							 OWTWasteDescriptionUnit.UnitConversionFactor, 
							 OWTTC.ArrivalDate, 
							 OWTWasteCode.WasteGroup, 
							 Classification_2.Code as ConsignorCode, 
							 Classification_3.Code as TransporterCode, 
							 Classification_4.Name as ReceivingFacilityCode
							 FROM   (((((((((WDS.dbo.OWTTC OWTTC 
							 INNER JOIN WDS.dbo.Classification Classification ON OWTTC.TCStatusTypeID=Classification.ClassificationID) 
							 INNER JOIN WDS.dbo.OWTWasteCode OWTWasteCode ON OWTTC.OWTWasteCodeID=OWTWasteCode.OWTWasteCodeID) 
							 INNER JOIN WDS.dbo.Classification Classification_1 ON OWTTC.ArrivalWasteAmountWeightUnitTypeID=Classification_1.ClassificationID) 
							 INNER JOIN WDS.dbo.OWTWasteDescriptionUnit OWTWasteDescriptionUnit ON (OWTTC.ArrivalWasteAmountWeightUnitTypeID=OWTWasteDescriptionUnit.WeightUnitTypeID) AND (OWTTC.OWTWasteDescriptionID=OWTWasteDescriptionUnit.OWTWasteDescriptionID)) 
							 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_1 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_1.OWTTCID) 
							 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity ON OWTTC.OWTTCID=OWTTCAssociatedEntity.OWTTCID) 
							 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_2 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_2.OWTTCID) 
							 LEFT OUTER JOIN WDS.dbo.Classification Classification_4 ON OWTTCAssociatedEntity_2.AssociatedRoleTypeID=Classification_4.ClassificationID) 
							 LEFT OUTER JOIN WDS.dbo.Classification Classification_3 ON OWTTCAssociatedEntity_1.AssociatedRoleTypeID=Classification_3.ClassificationID) 
							 LEFT OUTER JOIN WDS.dbo.Classification Classification_2 ON OWTTCAssociatedEntity.AssociatedRoleTypeID=Classification_2.ClassificationID
							 WHERE  					 
							 NOT (Classification.Code='Created' OR Classification.Code='Pickedup' OR Classification.Code='Terminated') 					 
							 AND Classification_2.Code='Consignor' 
							 AND Classification_3.Code='Transporter' 
							 AND Classification_4.Name='ReceivingFacility'					 
							 AND
								 OWTTC.ConsignorReportingStateCode in (select ValueA from @IntTableA)
							 AND 
								 NOT (OWTTC.ConsignorReportingStateCode='n/a' OR OWTTC.ConsignorReportingStateCode='NSW') 
							 AND 
								(
									OWTTC.ArrivalDate >= (case isnull(@ArrivalStartDate, '') when '' then OWTTC.ArrivalDate else @ArrivalStartDate end) 
									and 
									OWTTC.ArrivalDate<= (case isnull(@ArrivalEndDate, '') when '' then OWTTC.ArrivalDate else @ArrivalEndDate end)
								)
							ORDER BY OWTTC.ConsignorReportingStateCode, OWTWasteCode.WasteGroup, OWTWasteCode.Code 	
						end	
						else
						begin
							 SELECT 
							 OWTTC.OWTTCID,
							 OWTTC.PickUpActualDate, 
							 OWTTC.ConsignorReportingStateCode, 
							 Classification.Code as StatusCode, 
							 OWTTC.TCNumber, 
							 OWTWasteCode.Code as WasteCode, 
							 OWTTC.ArrivalWasteAmount, 
							 Classification_1.Code as WeightCode, 
							 OWTWasteDescriptionUnit.UnitConversionFactor, 
							 OWTTC.ArrivalDate, 
							 OWTWasteCode.WasteGroup, 
							 Classification_2.Code as ConsignorCode, 
							 Classification_3.Code as TransporterCode, 
							 Classification_4.Name as ReceivingFacilityCode
							 FROM   (((((((((WDS.dbo.OWTTC OWTTC 
							 INNER JOIN WDS.dbo.Classification Classification ON OWTTC.TCStatusTypeID=Classification.ClassificationID) 
							 INNER JOIN WDS.dbo.OWTWasteCode OWTWasteCode ON OWTTC.OWTWasteCodeID=OWTWasteCode.OWTWasteCodeID) 
							 INNER JOIN WDS.dbo.Classification Classification_1 ON OWTTC.ArrivalWasteAmountWeightUnitTypeID=Classification_1.ClassificationID) 
							 INNER JOIN WDS.dbo.OWTWasteDescriptionUnit OWTWasteDescriptionUnit ON (OWTTC.ArrivalWasteAmountWeightUnitTypeID=OWTWasteDescriptionUnit.WeightUnitTypeID) AND (OWTTC.OWTWasteDescriptionID=OWTWasteDescriptionUnit.OWTWasteDescriptionID)) 
							 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_1 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_1.OWTTCID) 
							 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity ON OWTTC.OWTTCID=OWTTCAssociatedEntity.OWTTCID) 
							 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_2 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_2.OWTTCID) 
							 LEFT OUTER JOIN WDS.dbo.Classification Classification_4 ON OWTTCAssociatedEntity_2.AssociatedRoleTypeID=Classification_4.ClassificationID) 
							 LEFT OUTER JOIN WDS.dbo.Classification Classification_3 ON OWTTCAssociatedEntity_1.AssociatedRoleTypeID=Classification_3.ClassificationID) 
							 LEFT OUTER JOIN WDS.dbo.Classification Classification_2 ON OWTTCAssociatedEntity.AssociatedRoleTypeID=Classification_2.ClassificationID
							 WHERE  					 
							 NOT (Classification.Code='Created' OR Classification.Code='Pickedup' OR Classification.Code='Terminated') 					 
							 AND Classification_2.Code='Consignor' 
							 AND Classification_3.Code='Transporter' 
							 AND Classification_4.Name='ReceivingFacility'					 							 
							 AND 
								 NOT (OWTTC.ConsignorReportingStateCode='n/a' OR OWTTC.ConsignorReportingStateCode='NSW') 
							 AND 
								(
									OWTTC.ArrivalDate >= (case isnull(@ArrivalStartDate, '') when '' then OWTTC.ArrivalDate else @ArrivalStartDate end) 
									and 
									OWTTC.ArrivalDate<= (case isnull(@ArrivalEndDate, '') when '' then OWTTC.ArrivalDate else @ArrivalEndDate end)
								)
							ORDER BY OWTTC.ConsignorReportingStateCode, OWTWasteCode.WasteGroup, OWTWasteCode.Code
						end
					 end
				  else
					begin
						 SELECT 
						 OWTTC.OWTTCID,
						 OWTTC.PickUpActualDate, 
						 OWTTC.ConsignorReportingStateCode, 
						 Classification.Code as StatusCode, 
						 OWTTC.TCNumber, 
						 OWTWasteCode.Code as WasteCode, 
						 OWTTC.ArrivalWasteAmount, 
						 Classification_1.Code as WeightCode, 
						 OWTWasteDescriptionUnit.UnitConversionFactor, 
						 OWTTC.ArrivalDate, 
						 OWTWasteCode.WasteGroup, 
						 Classification_2.Code as ConsignorCode, 
						 Classification_3.Code as TransporterCode, 
						 Classification_4.Name as ReceivingFacilityCode
						 FROM   (((((((((WDS.dbo.OWTTC OWTTC 
						 INNER JOIN WDS.dbo.Classification Classification ON OWTTC.TCStatusTypeID=Classification.ClassificationID) 
						 INNER JOIN WDS.dbo.OWTWasteCode OWTWasteCode ON OWTTC.OWTWasteCodeID=OWTWasteCode.OWTWasteCodeID) 
						 INNER JOIN WDS.dbo.Classification Classification_1 ON OWTTC.ArrivalWasteAmountWeightUnitTypeID=Classification_1.ClassificationID) 
						 INNER JOIN WDS.dbo.OWTWasteDescriptionUnit OWTWasteDescriptionUnit ON (OWTTC.ArrivalWasteAmountWeightUnitTypeID=OWTWasteDescriptionUnit.WeightUnitTypeID) AND (OWTTC.OWTWasteDescriptionID=OWTWasteDescriptionUnit.OWTWasteDescriptionID)) 
						 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_1 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_1.OWTTCID) 
						 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity ON OWTTC.OWTTCID=OWTTCAssociatedEntity.OWTTCID) 
						 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_2 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_2.OWTTCID) 
						 LEFT OUTER JOIN WDS.dbo.Classification Classification_4 ON OWTTCAssociatedEntity_2.AssociatedRoleTypeID=Classification_4.ClassificationID) 
						 LEFT OUTER JOIN WDS.dbo.Classification Classification_3 ON OWTTCAssociatedEntity_1.AssociatedRoleTypeID=Classification_3.ClassificationID) 
						 LEFT OUTER JOIN WDS.dbo.Classification Classification_2 ON OWTTCAssociatedEntity.AssociatedRoleTypeID=Classification_2.ClassificationID
						 WHERE  					 
						 NOT (Classification.Code='Created' OR Classification.Code='Pickedup' OR Classification.Code='Terminated') 					 
						 AND Classification_2.Code='Consignor' 
						 AND Classification_3.Code='Transporter' 
						 AND Classification_4.Name='ReceivingFacility'					 
						 AND
							 OWTTC.ConsignorReportingStateCode in (select ValueA from @IntTableA)
						 AND 
							(
								OWTTC.ArrivalDate >= (case isnull(@ArrivalStartDate, '') when '' then OWTTC.ArrivalDate else @ArrivalStartDate end) 
								and 
								OWTTC.ArrivalDate<= (case isnull(@ArrivalEndDate, '') when '' then OWTTC.ArrivalDate else @ArrivalEndDate end)
							)
						ORDER BY OWTTC.ConsignorReportingStateCode, OWTWasteCode.WasteGroup, OWTWasteCode.Code 			
					end		 
			end
			else
			begin
					 SELECT 
					 OWTTC.OWTTCID,
					 OWTTC.PickUpActualDate, 
					 OWTTC.ConsignorReportingStateCode, 
					 Classification.Code as StatusCode, 
					 OWTTC.TCNumber, 
					 OWTWasteCode.Code as WasteCode, 
					 OWTTC.ArrivalWasteAmount, 
					 Classification_1.Code as WeightCode, 
					 OWTWasteDescriptionUnit.UnitConversionFactor, 
					 OWTTC.ArrivalDate, 
					 OWTWasteCode.WasteGroup, 
					 Classification_2.Code as ConsignorCode, 
					 Classification_3.Code as TransporterCode, 
					 Classification_4.Name as ReceivingFacilityCode
					 FROM   (((((((((WDS.dbo.OWTTC OWTTC 
					 INNER JOIN WDS.dbo.Classification Classification ON OWTTC.TCStatusTypeID=Classification.ClassificationID) 
					 INNER JOIN WDS.dbo.OWTWasteCode OWTWasteCode ON OWTTC.OWTWasteCodeID=OWTWasteCode.OWTWasteCodeID) 
					 INNER JOIN WDS.dbo.Classification Classification_1 ON OWTTC.ArrivalWasteAmountWeightUnitTypeID=Classification_1.ClassificationID) 
					 INNER JOIN WDS.dbo.OWTWasteDescriptionUnit OWTWasteDescriptionUnit ON (OWTTC.ArrivalWasteAmountWeightUnitTypeID=OWTWasteDescriptionUnit.WeightUnitTypeID) AND (OWTTC.OWTWasteDescriptionID=OWTWasteDescriptionUnit.OWTWasteDescriptionID)) 
					 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_1 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_1.OWTTCID) 
					 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity ON OWTTC.OWTTCID=OWTTCAssociatedEntity.OWTTCID) 
					 LEFT OUTER JOIN WDS.dbo.OWTTCAssociatedEntity OWTTCAssociatedEntity_2 ON OWTTC.OWTTCID=OWTTCAssociatedEntity_2.OWTTCID) 
					 LEFT OUTER JOIN WDS.dbo.Classification Classification_4 ON OWTTCAssociatedEntity_2.AssociatedRoleTypeID=Classification_4.ClassificationID) 
					 LEFT OUTER JOIN WDS.dbo.Classification Classification_3 ON OWTTCAssociatedEntity_1.AssociatedRoleTypeID=Classification_3.ClassificationID) 
					 LEFT OUTER JOIN WDS.dbo.Classification Classification_2 ON OWTTCAssociatedEntity.AssociatedRoleTypeID=Classification_2.ClassificationID
					 WHERE  					 
					 NOT (Classification.Code='Created' OR Classification.Code='Pickedup' OR Classification.Code='Terminated') 					 
					 AND Classification_2.Code='Consignor' 
					 AND Classification_3.Code='Transporter' 
					 AND Classification_4.Name='ReceivingFacility'					 		             
					 AND 
						(
							OWTTC.ArrivalDate >= (case isnull(@ArrivalStartDate, '') when '' then OWTTC.ArrivalDate else @ArrivalStartDate end) 
							and 
							OWTTC.ArrivalDate<= (case isnull(@ArrivalEndDate, '') when '' then OWTTC.ArrivalDate else @ArrivalEndDate end)
						)
					ORDER BY OWTTC.ConsignorReportingStateCode, OWTWasteCode.WasteGroup, OWTWasteCode.Code 
			end