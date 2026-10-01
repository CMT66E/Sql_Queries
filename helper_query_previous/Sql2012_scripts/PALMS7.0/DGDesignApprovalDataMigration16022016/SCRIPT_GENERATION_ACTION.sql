DECLARE @MyTopTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABN_SHORT varchar(20),
	ABN_CORRECT varchar(20)
	)    
INSERT INTO @MyTopTable(ABN_SHORT, ABN_CORRECT)	    
SELECT  
    a.[ABN] as ABN_SHORT	   
	,b.[ABN] as ABN_CORRECT	  
FROM [PALMSDB].[dbo].[tblAccountableParty] a
INNER JOIN [PALMSMigrationDB].[dbo].[dm_tblAccountableParty] b ON a.[ROW_ID] = cast(b.AccountablePartyID as varchar)



DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABN_SHORT varchar(20),
	ABN_CORRECT varchar(20)
	)    
INSERT INTO @MyTable(ABN_SHORT, ABN_CORRECT)	    
SELECT  
    
    ABN_SHORT,	   
	ABN_CORRECT	  
FROM @MyTopTable
WHERE SNo > 50

select * from @MyTable
 

declare @SelectQuery varchar(MAX)
set @SelectQuery = ''

declare @FinalQuery varchar(MAX)
set @FinalQuery = ''
	
declare @Cnt int
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
declare @TempABN_SHORT varchar(20)
declare @TempABN_CORRECT varchar(20)

WHILE (1=1)
BEGIN


   
SELECT @TempABN_SHORT = isnull(ABN_SHORT, ''), @TempABN_CORRECT = isnull(ABN_CORRECT, '') FROM @MyTable 
WHERE SNo = @Cnt 
	    


IF @@ROWCOUNT = 0
	BREAK
	

	if exists(select * from [PALMSDB].[dbo].[tblAccountableParty] where LTRIM(RTRIM(ABN)) = @TempABN_SHORT)
	begin
	      if @SelectQuery = ''
		     set @SelectQuery = 'select ABN, ''' + isnull(@TempABN_CORRECT, '') + ''' as ABN_CORRECT FROM tblAccountableParty WHERE LTRIM(RTRIM(ABN)) = '''+ isnull(@TempABN_SHORT, '') + ''''
		  else
		     set @SelectQuery = @SelectQuery +  CHAR(13)  + 'select ABN, ''' + isnull(@TempABN_CORRECT, '') + ''' as ABN_CORRECT FROM tblAccountableParty WHERE LTRIM(RTRIM(ABN)) = '''+ isnull(@TempABN_SHORT, '') + ''''

		  if @FinalQuery = ''
		     set @FinalQuery = 'select tblAccountableParty ABN = ''' + isnull(@TempABN_CORRECT, '') + ''' WHERE LTRIM(RTRIM(ABN)) = '''+ isnull(@TempABN_SHORT, '') + ''''
		  else
		     set @FinalQuery = @FinalQuery + CHAR(13) + 'UPDATE tblAccountableParty set ABN = ''' + isnull(@TempABN_CORRECT, '') + ''' WHERE LTRIM(RTRIM(ABN)) = ''' + isnull(@TempABN_SHORT, '') + ''''	  	    
	end	 
		
SELECT @Cnt = @Cnt + 1
		
END


--print '@FinalQuery = ' + @FinalQuery
print '@SelectQuery = ' + @SelectQuery
delete @MyTable


