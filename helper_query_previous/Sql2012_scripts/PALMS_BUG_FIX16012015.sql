declare @PrimaryInstrumentID   int
declare @NoticeID              int
declare @ResponsibleUserID     int
declare @CreatedByUserID       int

set @PrimaryInstrumentID = 20362
set @NoticeID = 1526943
set @ResponsibleUserID = 1274
set @CreatedByUserID = 1399

     	SET NOCOUNT ON;
     	Declare @ReportPeriodID           int;
        Set @ReportPeriodID = -1
     			    
		--BEGIN TRAN

		   Declare @noPendingNotices         int;
		   Declare @tblPendingNotice table (instrumentID     int, 
										    noticeId         int,
										    noticeTemplateId int,
										    noticeType       varchar(100))
		
		   Insert into @tblPendingNotice     
             Exec dbo.uspGetSystemPendingNotice @PrimaryInstrumentID, @noPendingNotices Output  
         
           Select @noPendingNotices = COUNT(*)
             From @tblPendingNotice
           --Where noticeTemplateId = 391     --Surrender notice template
         
print '@noPendingNotices=' + cast(@noPendingNotices as varchar)

           If ( @noPendingNotices = 1 )
             BEGIN
                 Declare @Note  varchar(255)
                 Declare @SequenceNo    smallint

                 Set @Note  = 'This licence was surrendered by notice ' + LTrim(Rtrim(str(@NoticeID))) + ' on ' + dbo.ufn_PALMSFormatDate(GETDATE())  
   
                 Select @SequenceNo = isNull(MAX(SequenceNo),0)
                   From tblPOEOLicenceDocNote   
                  Where InstrumentID = @PrimaryInstrumentID  
               
                 Set @SequenceNo = @SequenceNo + 1       

				 Insert Into dbo.tblPOEOLicenceDocNote
						   ([InstrumentID]
						   ,[SequenceNo]
						   ,[Note]
						   ,[DateCreated]
						   ,[CreatedBySystemUserID]
						   ,[DateUpdated]
						   ,[UpdatedBySystemUserID])
		              VALUES
						   (@PrimaryInstrumentID
						   ,@SequenceNo 
						   ,@Note 
						   ,GETDATE() 
						   ,@CreatedByUserID
						   ,null
						   ,null)

             END 
             		
		--COMMIT TRAN
       -- Select isNull(ReportingPeriodID,-1) as ReportingPeriodID
		 if exists(Select ReportingPeriodID
          From dbo.tblReportingPeriod 
         Where InstrumentID = @PrimaryInstrumentID		     
           and EndDate is null)
		      Select isNull(ReportingPeriodID,-1) as ReportingPeriodID
			  From dbo.tblReportingPeriod 
              Where InstrumentID = @PrimaryInstrumentID		     
              and EndDate is null
		else
		      Select -1 as ReportingPeriodID

 
		