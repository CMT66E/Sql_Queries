

---start looping and insert records into tblRadiationConditionForDocument based on those new rows in table: tblRadiationCondition
---so we can make sure all new rows added into tblRadiationCondition will be shown on table: tblRadiationConditionForDocument
-- 23-09-2014 Eric He
	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ConditionName varchar(50)
	)    
	INSERT INTO @MyTable(ConditionName)	    
	select A.ConditionName from tblRadiationCondition A where 
															a.EffectiveDateFrom <= GETDATE() AND (a.EffectiveDateTo IS NULL OR a.EffectiveDateTo >= GETDATE())
															and
															isnull(A.ConditionName, '') not in (select isnull(ConditionName, '') from tblRadiationConditionForDocument)
	DECLARE @ConditionName VARCHAR(50)
	DECLARE @RadiationConditionForDocumentID INT
    DECLARE @Cnt INT
	SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	WHILE (1=1)
	BEGIN
   
	SELECT @ConditionName = ConditionName FROM @MyTable
	WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

		select @RadiationConditionForDocumentID = max([RadiationConditionForDocumentID]) + 1 from tblRadiationConditionForDocument
		
		insert into tblRadiationConditionForDocument([RadiationConditionForDocumentID], [ConditionName], [Description], [DateCreated], [CreatedBySystemUserID], [DateUpdated], [UpdatedBySystemUserID])
		select 
			   @RadiationConditionForDocumentID
			  ,A.[ConditionName]
			  ,A.[Description]      
			  ,A.[DateCreated]
			  ,A.[CreatedBySystemUserID]
			  ,A.[DateUpdated]
			  ,A.[UpdatedBySystemUserID]
		from tblRadiationCondition A where A.ConditionName = @ConditionName
		
	SELECT @Cnt = @Cnt + 1		
	END
---end modification on 23-09-2014

--if exists(select A.* from tblRadiationCondition A where 
--a.EffectiveDateFrom <= GETDATE() AND (a.EffectiveDateTo IS NULL OR a.EffectiveDateTo >= GETDATE())
--and
--isnull(A.ConditionName, '') not in (select isnull(ConditionName, '') from tblRadiationConditionForDocument))
--begin
--    insert into tblRadiationConditionForDocument([RadiationConditionForDocumentID], [ConditionName], [Description], [DateCreated], [CreatedBySystemUserID], [DateUpdated], [UpdatedBySystemUserID])
--	select 
--	       (select max([RadiationConditionForDocumentID]) + 1 from tblRadiationConditionForDocument) as [RadiationConditionForDocumentID]
--		  ,A.[ConditionName]
--		  ,A.[Description]      
--		  ,A.[DateCreated]
--		  ,A.[CreatedBySystemUserID]
--		  ,A.[DateUpdated]
--		  ,A.[UpdatedBySystemUserID]
--	from tblRadiationCondition A 
--	where 
--		a.EffectiveDateFrom <= GETDATE() AND (a.EffectiveDateTo IS NULL OR a.EffectiveDateTo >= GETDATE())
--		and
--		isnull(A.ConditionName, '') not in (select isnull(ConditionName, '') from tblRadiationConditionForDocument) 
--end