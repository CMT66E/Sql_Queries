	--select * from tblRadiationLicenceRRM where RRMDepartmentID is not null
	--select * from tblRRMDepartment
	--select * from tblRadiationDepartment
	----------------------------------------------------------------
    --First thing is to create a temp tblRadiationDepartment table
    DECLARE @tblRadiationDepartmentTemp TABLE
	(
		[RadiationDepartmentID] [int] IDENTITY(1,1) NOT NULL,
		[RadiationLocationID] [int] NOT NULL,
		[DepartmentName] [varchar](255) NOT NULL,
		[EffectiveDateFrom] [smalldatetime] NOT NULL,
		[EffectiveDateTo] [smalldatetime] NULL,
		[DateCreated] [smalldatetime] NOT NULL,
		[CreatedBySystemUserID] [int] NOT NULL,
		[DateUpdated] [smalldatetime] NULL,
		[UpdatedBySystemUserID] [int] NULL,
		[RowTimestamp] [timestamp] NOT NULL,
		[RowID] [int] NULL
	)  
	--we insert existing tblRadiationDepartment records into this temp table to simulate the real data insert
	--insert into @tblRadiationDepartmentTemp
	--(
	--	[RadiationLocationID],
	--	[DepartmentName],
	--	[EffectiveDateFrom],
	--	[EffectiveDateTo],
	--	[DateCreated],
	--	[CreatedBySystemUserID],
	--	[DateUpdated],
	--	[UpdatedBySystemUserID],	 
	--	[RowID] 
	--)
	--select 
	--	[RadiationLocationID],
	--	[DepartmentName],
	--	[EffectiveDateFrom],
	--	[EffectiveDateTo],
	--	[DateCreated],
	--	[CreatedBySystemUserID],
	--	[DateUpdated],
	--	[UpdatedBySystemUserID],	 
	--	[RadiationDepartmentID] 
	--from tblRadiationDepartment

	--Here we insert migration data row from DM_tblRadiationDepartment
	--insert into @tblRadiationDepartmentTemp
	--(
	--	[RadiationLocationID],
	--	[DepartmentName],
	--	[EffectiveDateFrom],
	--	[EffectiveDateTo],
	--	[DateCreated],
	--	[CreatedBySystemUserID],
	--	[DateUpdated],
	--	[UpdatedBySystemUserID],	 
	--	[RowID] 
	--)
	--select 
	--	   [RadiationLocationID]
	--	  ,[DepartmentName]
	--	  ,getdate() as [EffectiveDateFrom]
	--	  ,null as [EffectiveDateTo]
	--	  ,getdate() as [DateCreated]
	--	  ,1 as [CreatedBySystemUserID]
	--	  ,null as [DateUpdated]
	--	  ,null as [UpdatedBySystemUserID]       
	--	  ,cast(RadiationDepartmentID as int) as [RowID]
	--from DM_tblRadiationDepartment
	--select * from tblRadiationDepartment
	--update tblRadiationDepartment set RowID = RadiationDepartmentID

	--insert into tblRadiationDepartment
	--(
	--	[RadiationLocationID],
	--	[DepartmentName],
	--	[EffectiveDateFrom],
	--	[EffectiveDateTo],
	--	[DateCreated],
	--	[CreatedBySystemUserID],
	--	[DateUpdated],
	--	[UpdatedBySystemUserID],	 
	--	[RowID] 
	--)
	--select 
	--	   [RadiationLocationID]
	--	  ,[DepartmentName]
	--	  ,getdate() as [EffectiveDateFrom]
	--	  ,null as [EffectiveDateTo]
	--	  ,getdate() as [DateCreated]
	--	  ,1 as [CreatedBySystemUserID]
	--	  ,null as [DateUpdated]
	--	  ,null as [UpdatedBySystemUserID]       
	--	  ,cast(RadiationDepartmentID as int) as [RowID]
	--from DM_tblRadiationDepartment

	--select * from tblRadiationDepartment order by RadiationDepartmentID asc
------------------------------------------------------------------------------------------------------------------------------
	declare @ExistingCount int
	select @ExistingCount = count(*) from tblRadiationDepartment

	--select top (@ExistingCount) * from @tblRadiationDepartmentTemp order by RadiationDepartmentID asc
	--we update those RadiationDepartmentID on table: [tblRadiationLicenceRRM] column [RRMDepartmentID]
	--begin looping
	DECLARE @MyTable TABLE
		(
			SNo int IDENTITY(1,1), 
			New_RadiationDepartmentID int,
			Old_RadiationDepartmentID int
		)    
	INSERT INTO @MyTable(New_RadiationDepartmentID, Old_RadiationDepartmentID)	  
    select RadiationDepartmentID, RowID 
	from tblRadiationDepartment order by RadiationDepartmentID asc
		  
 --   select top (@ExistingCount) RadiationDepartmentID, RowID 
	--from @tblRadiationDepartmentTemp order by RadiationDepartmentID asc
	
	select * from @MyTable
	
	declare @Cnt int
	SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	declare @TempNew_RadiationDepartmentID int
	declare @TempOld_RadiationDepartmentID int

	WHILE (1=1)
	BEGIN
   
	SELECT @TempNew_RadiationDepartmentID = New_RadiationDepartmentID, @TempOld_RadiationDepartmentID = Old_RadiationDepartmentID FROM @MyTable
	WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
	BREAK

	if exists(select * from tblRadiationLicenceRRM_BK where RRMDepartmentID = @TempOld_RadiationDepartmentID)
	begin
		print '@TempNew_RadiationDepartmentID =' + cast(@TempNew_RadiationDepartmentID as varchar)
		print '@TempOld_RadiationDepartmentID =' + cast(@TempOld_RadiationDepartmentID as varchar)
		print '---------------------------------------------'
		Update tblRadiationLicenceRRM_BK set RRMDepartmentID = @TempNew_RadiationDepartmentID where RRMDepartmentID = @TempOld_RadiationDepartmentID
	end
 		
	SELECT @Cnt = @Cnt + 1		
	END
	--end looping
	------------------------------------------------------------------
	print 'Total processed records = ' + cast(@Cnt as varchar)
	------------------------------------------------------------------
	--select * from DM_tblRadiationLicenceRRM
	--select * from tblRadiationLicenceRRM 
	--where RadiationLicenceRRMID in (select RadiationLicenceRRMID from DM_tblRadiationLicenceRRM)
	-------------------------------------------------------------------
	--select a.*, b.RadiationDepartmentID, c.DepartmentName 
	--from tblRadiationLicenceRRM a 
	--inner join DM_tblRadiationLicenceRRM b on a.RadiationLicenceRRMID = b.RadiationLicenceRRMID
	--inner join DM_tblRadiationDepartment c on b.RadiationDepartmentID = c.RadiationDepartmentID 
	-------------------------------------------------------------------
	--select * from tblRadiationLocationRRM
	--WHERE RadiationLocationRRMID in (select RadiationLocationRRMID from tblRadiationLicenceRRM) 
	-------------------------------------------------------------------