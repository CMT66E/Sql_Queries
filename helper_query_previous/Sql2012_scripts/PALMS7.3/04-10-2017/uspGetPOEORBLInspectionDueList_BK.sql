    
USE [PALMSDB]
GO
/****** Object:  StoredProcedure [dbo].[uspGetPOEORBLInspectionDueList]    Script Date: 4/10/2017 11:20:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================
-- Author:		Eric He
-- Create date: 04-10-2017
-- Description:	For POEO licence RBL data risk level 1 to level 3 we need generate it inspection due date data for the end users
-- ==========================================================
ALTER PROCEDURE [dbo].[uspGetPOEORBLInspectionDueList] 
	 
AS
BEGIN	
	
	declare @FinalInspection table
	( 
		InstrumentID int null,
		NextInspectionDueDate datetime null
	)

	DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	LicenceNo int 
	)    
	INSERT INTO @MyTable(LicenceNo)	    
	select distinct d.InstrumentID as LicenceNo 
	from tblNotice a inner join tblInstrument b on a.InstrumentID = b.InstrumentID 
	inner join tblNotice c on a.InstrumentID = c.InstrumentID
	inner join tblInstrumentNotice d on c.InstrumentID = d.NoticeInstrumentID
	where a.NoticeTemplateID = 532 and b.InstrumentStatusID in (11, 12) 
	and d.InstrumentID in (select InstrumentID from tblPOEOLicenceEnvironmentalRiskLevel where EnvironmentalRiskLevelID in (713, 714, 715))

    declare @Cnt int
    SELECT @Cnt = MIN(Sno) FROM @MyTable
	
	declare @TempLicenceNo int
	declare @TempNextInspectionDueDate date 

	WHILE (1=1)
	BEGIN
   
	SELECT @TempLicenceNo = LicenceNo FROM @MyTable WHERE SNo = @Cnt
	    
	IF @@ROWCOUNT = 0
		BREAK

		if @TempLicenceNo > 0
		begin
			  --print '---------------------------------------------------------'
			  --print '@TempLicenceNo =' + cast(@TempLicenceNo as varchar)		 
			  --print '---------------------------------------------------------'
		 

			  declare @MyTableInspectionLBL table
			  (
				SNo int IDENTITY(1,1),
				InspectionNo int null,
				NextInspectionDueDate datetime null,
				InspectedDate datetime null,
				Officer varchar(100) null,
				[Level] varchar(10) null,
				Comments varchar(1000) null
			  )
			  insert into @MyTableInspectionLBL
			  exec [uspGetPOEORBLInspectionData] @TempLicenceNo
			   
			  select @TempNextInspectionDueDate = NextInspectionDueDate	from @MyTableInspectionLBL where InspectionNo is null

			  insert into @FinalInspection(InstrumentID, NextInspectionDueDate)
			  select @TempLicenceNo as InstrumentID, @TempNextInspectionDueDate as NextInspectionDueDate 


			  delete @MyTableInspectionLBL
		end
	 
	SELECT @Cnt = @Cnt + 1
		
	END

	select InstrumentID, NextInspectionDueDate from @FinalInspection

	delete @MyTable
	delete @FinalInspection
END	