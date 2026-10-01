--Script to reformat the phone numbers and mobile phone numbers in these ways which PAMLS system will be able to adapted
--Phone number : (02) 9736 2633
--Mobile number: 0425 344649
--AccountableParty table

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
SELECT TOP 500 AccountablePartyID     
      ,Surname
      ,GivenName 
	  ,OrganisationName   
      ,Phone
      ,Mobile       
      ,Fax      
FROM [dbo].[tblAccountableParty]
WHERE Rtrim(Ltrim(isnull(Phone, ''))) <> '' OR Rtrim(Ltrim(isnull(Mobile, ''))) <> '' OR Rtrim(Ltrim(isnull(Fax, ''))) <> '' AND NOT ROW_ID IS NULL
ORDER BY AccountablePartyID DESC

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
WHERE Rtrim(Ltrim(isnull(Phone, ''))) <> '' OR Rtrim(Ltrim(isnull(Mobile, ''))) <> '' OR Rtrim(Ltrim(isnull(Fax, ''))) <> '' AND NOT ROW_ID IS NULL
 

DECLARE @AccountablePartyID INT
DECLARE @Phone varchar(20)
DECLARE @Mobile varchar(20)
DECLARE @Fax varchar(20)

DECLARE @Cnt INT
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @AccountablePartyID = AccountablePartyID, @Phone=Phone, @Mobile = Mobile, @Fax=Fax FROM @MyTable
WHERE SNo = @Cnt
	    
IF @@ROWCOUNT = 0
	BREAK
	--initialize variables here
	declare @PhoneUpdate varchar(20)
	declare @MobileUpdate varchar(20)
	declare @FaxUpdate varchar(20)
	
	set @PhoneUpdate = ''
	set @MobileUpdate = ''
	set @FaxUpdate = ''

    --1. Phone 
	IF LEN(@Phone) > 5
	BEGIN	    
		set @PhoneUpdate = ''

	    declare @PhoneFirstPart varchar(10)
		declare @PhoneSecondPart varchar(10)
		declare @PhoneThirdPart varchar(10)

		select @PhoneFirstPart= SUBSTRING(@Phone, 1, 2) 
		if LEN(@PhoneFirstPart)=2
		  set @PhoneFirstPart = '(' + @PhoneFirstPart +') '

		select @PhoneSecondPart = SUBSTRING(@Phone, 3, 4) 
		if LEN(@PhoneSecondPart)=4
		  set @PhoneSecondPart = @PhoneSecondPart +' '

		select @PhoneThirdPart = SUBSTRING(@Phone, 7, 4) 

		set @PhoneUpdate = @PhoneFirstPart + @PhoneSecondPart + @PhoneThirdPart
	END
	--2 Mobile
	IF LEN(@Mobile) > 5
	BEGIN	    
		set @MobileUpdate = ''

	    declare @MobileFirstPart varchar(10)
		declare @MobileSecondPart varchar(10)
		 
		select @MobileFirstPart= SUBSTRING(@Mobile, 1, 4) 
		if LEN(@MobileFirstPart)=4
		  set @MobileFirstPart = @MobileFirstPart +' '

		select @MobileSecondPart = SUBSTRING(@Mobile, 5, 6) 
		if LEN(@MobileSecondPart) > 0
		  set @MobileSecondPart = @MobileSecondPart  
 

		set @MobileUpdate = @MobileFirstPart + @MobileSecondPart 
	END
	--3 Fax
	IF LEN(@Fax) > 5
	BEGIN	    
		set @FaxUpdate = ''

	    declare @FaxFirstPart varchar(10)
		declare @FaxSecondPart varchar(10)
		declare @FaxThirdPart varchar(10)

		select @FaxFirstPart= SUBSTRING(@Fax, 1, 2) 
		if LEN(@FaxFirstPart)=2
		  set @FaxFirstPart = '(' + @FaxFirstPart +') '

		select @FaxSecondPart = SUBSTRING(@Fax, 3, 4) 
		if LEN(@FaxSecondPart)=4
		  set @FaxSecondPart = @FaxSecondPart +' '

		select @FaxThirdPart = SUBSTRING(@Fax, 7, 4) 

		set @FaxUpdate = @FaxFirstPart + @FaxSecondPart + @FaxThirdPart
	END		

	--Update the tblAccountableParty
	Update @MyFinalTable set 
	                 Phone = case len(@PhoneUpdate) when 0 then Phone else @PhoneUpdate end,
					 Mobile = case len(@MobileUpdate) when 0 then Mobile else @MobileUpdate end,
					 Fax = case len(@FaxUpdate) when 0 then Fax else @FaxUpdate end
    WHERE AccountablePartyID = @AccountablePartyID
SELECT @Cnt = @Cnt + 1
		
END

SELECT * FROM @MyFinalTable

DELETE @MyTable
DELETE @MyFinalTable


   

   
