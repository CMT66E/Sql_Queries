--Script to reformat the phone numbers and mobile phone numbers in these ways which PAMLS system will be able to adapted
--Phone number : (02) 9736 2633
--Mobile number: 0425 344649
--AccountableParty Table fax number fix: change number like (89) 4567 78 to be (02) 8945 6778

DECLARE @MyFinalTable TABLE 
(
	[AccountablePartyID] [int] NULL, 
	[Surname] [varchar](60) NULL,
	[GivenName] [varchar](60) NULL,
	[OrganisationName] [varchar](128) NULL,	 
	[Phone] [varchar](20) NULL,
	[Mobile] [varchar](20) NULL,	 
	[Fax] [varchar](20) NULL
)

INSERT INTO @MyFinalTable
SELECT [AccountablePartyID]     
      ,[Surname]
      ,[GivenName]   
	  ,OrganisationName  	 
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '') as Phone	   	 
	  ,replace(replace(replace(Rtrim(Ltrim(isnull(Mobile, ''))), '(', ''), ')', ''), ' ', '') as Mobile	   	   
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '') as Fax      	 
FROM [dbo].[tblAccountableParty]
WHERE NOT ROW_ID IS NULL
AND
LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '')) < 10
and LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '')) > 0
and substring(replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', ''), 1, 1) <> '0' 
and Fax <> 'N/A'
and Fax <> 'NA'

SELECT * FROM @MyFinalTable

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	AccountablePartyID int,
	Phone varchar(20),
	Mobile varchar(20),
	Fax varchar(20)
	)    
INSERT INTO @MyTable(AccountablePartyID, Phone, Mobile, Fax)	    
SELECT [AccountablePartyID]           
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '') as Phone
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Mobile, ''))), '(', ''), ')', ''), ' ', '') as Mobile       
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '') as Fax      
FROM [dbo].[tblAccountableParty]
WHERE NOT ROW_ID IS NULL
AND
LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '')) < 10
and LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '')) > 0
and substring(replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', ''), 1, 1) <> '0' 
and Fax <> 'N/A'
and Fax <> 'NA'
 

DECLARE @AccountablePartyID INT
DECLARE @Phone varchar(20)
DECLARE @Mobile varchar(20)
DECLARE @Fax varchar(20)

DECLARE @Cnt INT
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @AccountablePartyID = AccountablePartyID, @Phone=Phone, @Mobile = Mobile, @Fax=replace(Fax, '-', '') FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK
	--initialize variables here
	 
	declare @FaxUpdate varchar(20)		 
	set @FaxUpdate = ''

    --1. Fax 
	IF LEN(@Fax) > 7
	BEGIN	    
		set @FaxUpdate = ''

		declare @FaxFirstDigit varchar(1)
	    declare @FaxFirstPart varchar(10)
		declare @FaxSecondPart varchar(10)
		declare @FaxThirdPart varchar(10)

		select @FaxFirstDigit =  SUBSTRING(@Fax, 1, 1) 
		 
		if (@FaxFirstDigit <> '0')
		begin
			  IF LEN(@Fax) = 8
			  begin				 
				set @FaxFirstPart = '(02) '

				select @FaxSecondPart = SUBSTRING(@Fax, 1, 4) 
				if LEN(@FaxSecondPart)=4
				  set @FaxSecondPart = @FaxSecondPart +' '

				select @FaxThirdPart = SUBSTRING(@Fax, 5, 4) 
				set @FaxUpdate = @FaxFirstPart + @FaxSecondPart + @FaxThirdPart
			  end

			 if LEN(@Fax) = 9
			 begin
				select @FaxFirstPart= SUBSTRING(@Fax, 1, 1) 
				if LEN(@FaxFirstPart)=1
				  set @FaxFirstPart = '(0' + @FaxFirstPart +') '

				select @FaxSecondPart = SUBSTRING(@Fax, 2, 4) 
				if LEN(@FaxSecondPart)=4
				  set @FaxSecondPart = @FaxSecondPart +' '

				select @FaxThirdPart = SUBSTRING(@Fax, 6, 4) 

				set @FaxUpdate = @FaxFirstPart + @FaxSecondPart + @FaxThirdPart
			 end
		end
	END
  
	--Update the tblAccountableParty
	Update @MyFinalTable set 	           					 
	Fax = case len(@FaxUpdate) when 0 then Fax else @FaxUpdate end
    WHERE AccountablePartyID = @AccountablePartyID

SELECT @Cnt = @Cnt + 1
		
END

SELECT * FROM @MyFinalTable

DELETE @MyTable
DELETE @MyFinalTable


   

   
