select * from AccountOperation where  AccountOperationPermit = cast(20976 as varchar) 
and AccountOperationRoleTypeID = 290 
and SiteID = 23703 
and CustomerID = 15225 
and EffectiveDateTo is null  

select * from AccountOperation where  AccountOperationPermit = cast(13071 as varchar)
select * from Individual where AccountOperationID in (23834, 23841)

select * from Customer where CustomerID in (15287, 15287) 
select * from Customer where PALMSAccountablePartyID = 8228

select AccountOperationID from AccountOperation where AccountOperationPermit = cast(20976 as varchar) and AccountOperationRoleTypeID = 290 and SiteID = 23703 and CustomerID = 15225 and EffectiveDateTo is null and NSWLicenceFlag = 0 and ConsignmentAuthorisationCreateFlag= 0 and ApprovalMultipleWasteCAFlag = 0



      SELECT
        AccountOperationID as TransporterAccountOperationID
      FROM AccountOperation
      WHERE AccountOperationPermit = CAST(20976 AS varchar(10))
      AND AccountOperationRoleTypeID = 290
      AND EffectiveDateTo IS NULL

select * from OWTAccountOperationWasteCode
      WHERE AccountOperationID = 23856


declare @IsRecordTypeReceiver int
select  @IsRecordTypeReceiver = [dbo].[ufn_PALMSReceiverRecordExistNew](20989)
select @IsRecordTypeReceiver as temp


select * from Customer where PALMSAccountablePartyID = 1390
select * from AccountOPeration where CustomerID in (7491)
-------------------------------------------------------------------------------------------------
--23897 new accountoperationID
--16033 old accountoperationID

select * from AccountOPeration where AccountOPerationPermit = cast(7100 as varchar) 
select * from AccountOPeration where AccountOperationID = 1175 
select * from Customer where CustomerID = 1054 
select * from [Site] where SiteID = 1162
select * from [Individual] where AccountOPerationID in (1175)
select * from OWTAccountOperationWasteCode where AccountOPerationID in (1175)
--------------------------------------------------------------------------------------------------
select * from AccountOPeration where AccountOPerationPermit = cast(13071 as varchar) 

        SELECT
          *
        FROM AccountOperation
        WHERE AccountOperationPermit = CAST(10060 AS varchar(10))
        AND AccountOperationRoleTypeID = 289
        AND EffectiveDateTo IS NULL

select * from AccountOPeration where AccountOperationID in (57, 2420, 2476) 
select * from Customer where PALMSAccountablePartyID in (820, 821)
select top 10 * from Customer where TradingName like '%Constance Kwan Yee Wong%'

select * from Customer where CustomerID = 57 
 
select * from [Site] where SiteID = 120
select * from [Individual] where AccountOPerationID in (2420)

select a.*, b.* from OWTAccountOperationWasteCode a 
left outer join OWTCTWaste b on a.OWTWasteCodeID = b.OWTWasteCodeID
where AccountOPerationID in (1159)

select * from OWTCTWaste
--------------------------------------------------------------------------------------------------
select a.*, b.OWTCAID, c.description, b.* from OWTCATransporter a 
left outer join OWTCA b on a.OWTCAID = b.OWTCAID
left outer join Classification c on b.CAStatusTypeID = c.ClassificationID
where a.AccountOPerationID in (1159)

select * from Classification where ClassificationID in (281, 283) 

SELECT
			  OWTCAID
			FROM OWTCA
			WHERE CAStatusTypeID IN (281, 283)


-------------------------------------------------------------------------------------------------

select * from individual where AccountOperationID in (3182, 3915)

select * from Customer where CustomerID in (57) 
select * from Customer where PALMSAccountablePartyID in (4178, 27655) 
select CustomerID from Customer where PALMSAccountablePartyID = 27655

select * from OWTAccountOperationWasteCode where AccountOPerationID in (1159, 4168)
select * from [Site] where SiteID in (5206)
select * from [Individual] where AccountOPerationID in (5484, 23887)


-------------------------------------------------------------------------------------------------
        declare @InstrumentID int = 7100
	    DECLARE @MyTableLoop TABLE 
        (
        SNo int IDENTITY (1, 1),
        AccountOperationID int 
        )
		INSERT INTO @MyTableLoop(AccountOperationID)
        SELECT AccountOperationID
        FROM AccountOperation
        WHERE AccountOperationPermit = CAST(@InstrumentID AS varchar(10))
        AND AccountOperationRoleTypeID = 290
        --AND EffectiveDateTo IS NULL

		select * from @MyTableLoop