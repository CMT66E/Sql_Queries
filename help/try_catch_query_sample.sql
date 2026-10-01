BEGIN TRY
-- Generate a divide-by-zero error  
  SELECT
    1 / 0 AS Error;
END TRY
BEGIN CATCH
    select 0
  --SELECT
  --  ERROR_NUMBER() AS ErrorNumber,
  --  ERROR_STATE() AS ErrorState,
  --  ERROR_SEVERITY() AS ErrorSeverity,
  --  ERROR_PROCEDURE() AS ErrorProcedure,
  --  ERROR_LINE() AS ErrorLine,
  --  ERROR_MESSAGE() AS ErrorMessage;
END CATCH;