USE [PALMSDB]
GO
/****** Object:  StoredProcedure [dbo].[uspLinkLocations]    Script Date: 16/05/2016 3:57:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[uspLinkLocations]
	@tblLocation tblInstrumentLocationType Readonly,@InstrumentID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	BEGIN TRY
	DECLARE	@InstrumentLocationID Int
	DECLARE @RowAction char(1)
	DECLARE @CntLocation INT
	DECLARE @Cnt INT
	DECLARE @RtnVal int
	
	declare @IsTransporterLicence bit
	DECLARE	@TempInstrumentID Int
	set @IsTransporterLicence = 0
	select @IsTransporterLicence = [dbo].[ufn_IsTransporterPOEOLicence] (@InstrumentID) 
	
    --If there is no record in dataset do not proceed
	SELECT @CntLocation = 0
	SELECT @CntLocation = COUNT(*) FROM @tblLocation
	
	IF @CntLocation <= 0
		RETURN 0
 
		-- loop through Location records
		SET @Cnt = 1
		WHILE @Cnt <= @CntLocation
			BEGIN
				SELECT @RowAction = ''
				SELECT @InstrumentLocationID = InstrumentLocationID, @TempInstrumentID= InstrumentID, @RowAction = Action
				FROM @tblLocation WHERE Sno =  @Cnt
						
				IF (@RowAction='I' OR @RowAction='U') AND @InstrumentLocationID < 0  --Insert new record
  				   BEGIN
						if @IsTransporterLicence = 0
						begin
							INSERT INTO tblInstrumentLocation(
											 InstrumentID,
											 LocationID,
											 DateCreated,
											 CreatedBySystemUserID)
							SELECT 			 @InstrumentID,
											 LocationID,
											 GetDate(),
											 CreatedBySystemUserID
							FROM @tblLocation
							Where InstrumentLocationID = @InstrumentLocationID

							--Because it is premises licence then we remove InstrumentTransporterLocation records if it has any
							--if exists(select TransporterLocationID from tblInstrumentTransporterLocation where InstrumentID = @InstrumentID)
							--   delete from tblInstrumentTransporterLocation where InstrumentID = @InstrumentID
						end

						if @IsTransporterLicence = 1 and @TempInstrumentID = -1 --if this has been added as brand new licence then we insert records into tblInstrumentTransporterLocation
						begin
							INSERT INTO tblInstrumentTransporterLocation(
											 InstrumentID,
											 TransporterLocationID,
											 DateCreated,
											 CreatedBySystemUserID)
							SELECT 			 @InstrumentID,
											 LocationID,
											 GetDate(),
											 CreatedBySystemUserID
							FROM @tblLocation
							Where InstrumentLocationID = @InstrumentLocationID

							--Because it is transporter licence then we remove InstrumentLocation records if it has any
							--if exists(select LocationID from tblInstrumentLocation where InstrumentID = @InstrumentID)
							--   delete from tblInstrumentLocation where InstrumentID = @InstrumentID
						end
					END 
				ELSE IF (@RowAction='I' OR @RowAction='U') AND @InstrumentLocationID > 0  --update record
					BEGIN

					  if @IsTransporterLicence = 0
					  begin
						UPDATE tblInstrumentLocation
						SET DateUpdated = GetDate(),
							UpdatedBySystemUserID = Temp.UpdatedBySystemUserID
						FROM tblInstrumentLocation IC
						JOIN @tblLocation Temp ON IC.InstrumentLocationID = Temp.InstrumentLocationID
						Where IC.InstrumentLocationID = @InstrumentLocationID
					  end

					  if @IsTransporterLicence = 1
					  begin
						UPDATE tblInstrumentTransporterLocation
						SET DateUpdated = GetDate(),
							UpdatedBySystemUserID = Temp.UpdatedBySystemUserID
						FROM tblInstrumentTransporterLocation IC
						JOIN @tblLocation Temp ON IC.InstrumentTransporterLocationID = Temp.InstrumentLocationID
						Where IC.InstrumentTransporterLocationID = @InstrumentLocationID
					  end

					END
				ELSE IF @RowAction='D' AND @InstrumentLocationID > 0  --Delete record	
				  BEGIN 

					 if @IsTransporterLicence = 0
					   DELETE FROM tblInstrumentLocation
					   WHERE InstrumentLocationID = @InstrumentLocationID

					 if @IsTransporterLicence = 1
					   DELETE FROM tblInstrumentTransporterLocation
					   WHERE InstrumentTransporterLocationID = @InstrumentLocationID
				  END  
				  Select @Cnt = @Cnt + 1
			END -- End of loop
  

      RETURN 0
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(2000)
		
		SET @ErrorMessage = dbo.ufn_GetErrorText()
		
		RAISERROR (@ErrorMessage , 16, 1)
		RETURN 1
	END CATCH
END



