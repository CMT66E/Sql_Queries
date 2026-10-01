DECLARE @AccountOperationID INT
DECLARE @AccountOperationIDs VARCHAR(200) = null

set @AccountOperationID = 2390  
set @AccountOperationIDs = '2390, 4931, 4960, 5118'

DECLARE @AccountOperationIDAll VARCHAR(200)
declare @IntTableA TABLE ([ValueA] INT NULL)

IF @AccountOperationIDs is null or @AccountOperationIDs = ''
begin
      set @AccountOperationIDAll = cast(@AccountOperationID as varchar)
	  INSERT INTO @IntTableA (ValueA) VALUES (CAST(@AccountOperationIDAll AS int))
end
else
begin
			set @AccountOperationIDAll = @AccountOperationIDs
	  
			declare @DataA varchar(50)
			set @DataA = replace(@AccountOperationIDAll, ' ', '')
			
			DECLARE @PtrA int, @LengthA int, @vA nchar, @vvA nvarchar(100)
			SELECT @LengthA = (DATALENGTH(@DataA)) + 1, @PtrA = 1
                                  
			WHILE (@PtrA < @LengthA)
			BEGIN
					SET @vA = SUBSTRING(@DataA, @PtrA, 1)                                         
					IF @vA = ','
						BEGIN
								INSERT INTO @IntTableA (ValueA) VALUES (CAST(@vvA AS int))
								SET @vvA = NULL
						END
					ELSE
						BEGIN
								SET @vvA = ISNULL(@vvA, '') + @vA                                             
						END
					SET @PtrA = @PtrA + 1
			END
			-- If the last number was not followed by a comma, add it to the result set
			IF @vvA IS NOT NULL
					INSERT INTO @IntTableA (ValueA) VALUES (CAST(@vvA AS int))
end

select ValueA from @IntTableA

--DECLARE @ReceiverAccountOperationID int
--DECLARE @ConsinorAccountOperationID int
--DECLARE @TransporterAccountOperationID int

--SELECT
--	@ConsinorAccountOperationID = AccountOperationID
--FROM AccountOperation
--WHERE AccountOperationID IN (select ValueA from @IntTableA)
--AND AccountOperationRoleTypeID = 288
--AND EffectiveDateTo IS NULL

--SELECT
--	@ReceiverAccountOperationID = AccountOperationID
--FROM AccountOperation
--WHERE AccountOperationID IN (select ValueA from @IntTableA)
--AND AccountOperationRoleTypeID = 289
--AND EffectiveDateTo IS NULL

--SELECT
--@TransporterAccountOperationID = AccountOperationID
--FROM AccountOperation
--WHERE AccountOperationID IN (select ValueA from @IntTableA)
--AND AccountOperationRoleTypeID = 290
--AND EffectiveDateTo IS NULL

SELECT DISTINCT
	CA.OWTCAID AS CAID,
	CA.CANumber AS CANo,
	Consignor.OWTCAConsignorID AS CAConsignorID,
	Consignor.ConsignorName,
	CA.ReceivingFacilityAccountOperationID,
	CA.ReceivingFacilityName,
	CA.OWTWasteCodeID AS WasteCodeID,
	CA.EffectiveDateFrom AS StartDate,
	CA.EffectiveDateTo AS EndDate,
	CA.CAStatusTypeID AS StatusID,
	CA.ReceivingFacilityAccountOperationID,
	Consignor.AccountOperationID,
	Transporter.AccountOperationID,
	CA.CAStatusTypeID
FROM OWTCA CA 
	LEFT OUTER JOIN vwOWTCAConsignor Consignor ON CA.OWTCAID = Consignor.OWTCAID
	LEFT OUTER JOIN OWTCATransporter Transporter ON CA.OWTCAID = Transporter.OWTCAID
WHERE (
CA.ReceivingFacilityAccountOperationID in (select ValueA from @IntTableA)
OR Consignor.AccountOperationID  in (select ValueA from @IntTableA) 
OR Transporter.AccountOperationID  in (select ValueA from @IntTableA)
)

--WHERE (CA.CAStatusTypeID = 281 OR CA.CAStatusTypeID = 283)
--AND (
--CA.ReceivingFacilityAccountOperationID in (select ValueA from @IntTableA)
--OR Consignor.AccountOperationID  in (select ValueA from @IntTableA) 
--OR Transporter.AccountOperationID  in (select ValueA from @IntTableA)
--)

select * from Classification where ClassificationID in (281, 282, 283)