--Script to reformat the phone numbers and mobile phone numbers in these ways which PAMLS system will be able to adapted
--Phone number : (02) 9736 2633
--Mobile number: 0425 344649
--Contact Table phone number fix: change number like (89) 4567 78 to be (02) 8945 6778

DECLARE @MyFinalTable TABLE 
(
	[ContactID] [int] NULL, 
	[Surname] [varchar](60) NULL,
	[GivenName] [varchar](60) NULL,
	[OrganisationName] [varchar](128) NULL,	 
	[Phone] [varchar](20) NULL,
	[Mobile] [varchar](20) NULL,	 
	[Fax] [varchar](20) NULL
)

INSERT INTO @MyFinalTable
SELECT [ContactID]     
      ,[Surname]
      ,[GivenName]   
	  ,OrganisationName  	 
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '') as Phone	   	 
	  ,replace(replace(replace(Rtrim(Ltrim(isnull(Mobile, ''))), '(', ''), ')', ''), ' ', '') as Mobile	   	   
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '') as Fax      	 
FROM [dbo].[tblContact]
WHERE NOT ROW_ID IS NULL
AND
LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '')) < 10
and LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '')) > 0
and substring(replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', ''), 1, 1) <> '0' 
and Phone <> 'N/A'
and Phone <> 'NA'

SELECT * FROM @MyFinalTable

DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ContactID int,
	Phone varchar(20),
	Mobile varchar(20),
	Fax varchar(20)
	)    
INSERT INTO @MyTable(ContactID, Phone, Mobile, Fax)	    
SELECT [ContactID]           
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '') as Phone
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Mobile, ''))), '(', ''), ')', ''), ' ', '') as Mobile       
      ,replace(replace(replace(Rtrim(Ltrim(isnull(Fax, ''))), '(', ''), ')', ''), ' ', '') as Fax      
FROM [dbo].[tblContact]
WHERE NOT ROW_ID IS NULL
AND
LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '')) < 10
and LEN(replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', '')) > 0
and substring(replace(replace(replace(Rtrim(Ltrim(isnull(Phone, ''))), '(', ''), ')', ''), ' ', ''), 1, 1) <> '0' 
and Phone <> 'N/A'
and Phone <> 'NA'
 

DECLARE @ContactID INT
DECLARE @Phone varchar(20)
DECLARE @Mobile varchar(20)
DECLARE @Fax varchar(20)

DECLARE @Cnt INT
SELECT @Cnt = MIN(Sno) FROM @MyTable
	
WHILE (1=1)
BEGIN
   
SELECT @ContactID = ContactID, @Phone=Phone, @Mobile = Mobile, @Fax=Fax FROM @MyTable
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

		declare @PhoneFirstDigit varchar(1)
	    declare @PhoneFirstPart varchar(10)
		declare @PhoneSecondPart varchar(10)
		declare @PhoneThirdPart varchar(10)

		select @PhoneFirstDigit =  SUBSTRING(@Phone, 1, 1) 

		if (@PhoneFirstDigit <> '0')
		begin
			  IF LEN(@Phone) = 8
			  begin				 
				set @PhoneFirstPart = '(02) '

				select @PhoneSecondPart = SUBSTRING(@Phone, 1, 4) 
				if LEN(@PhoneSecondPart)=4
				  set @PhoneSecondPart = @PhoneSecondPart +' '

				select @PhoneThirdPart = SUBSTRING(@Phone, 5, 4) 
				set @PhoneUpdate = @PhoneFirstPart + @PhoneSecondPart + @PhoneThirdPart
			  end

			 if LEN(@Phone) = 9
			 begin
				select @PhoneFirstPart= SUBSTRING(@Phone, 1, 1) 
				if LEN(@PhoneFirstPart)=1
				  set @PhoneFirstPart = '(0' + @PhoneFirstPart +') '

				select @PhoneSecondPart = SUBSTRING(@Phone, 2, 4) 
				if LEN(@PhoneSecondPart)=4
				  set @PhoneSecondPart = @PhoneSecondPart +' '

				select @PhoneThirdPart = SUBSTRING(@Phone, 6, 4) 

				set @PhoneUpdate = @PhoneFirstPart + @PhoneSecondPart + @PhoneThirdPart
			 end
		end
	END
 
	--3 Fax
	--IF LEN(@Fax) > 5
	--BEGIN	    
	--	set @FaxUpdate = ''

	--    declare @FaxFirstPart varchar(10)
	--	declare @FaxSecondPart varchar(10)
	--	declare @FaxThirdPart varchar(10)

	--	select @FaxFirstPart= SUBSTRING(@Fax, 1, 2) 
	--	if LEN(@FaxFirstPart)=2
	--	  set @FaxFirstPart = '(' + @FaxFirstPart +') '

	--	select @FaxSecondPart = SUBSTRING(@Fax, 3, 4) 
	--	if LEN(@FaxSecondPart)=4
	--	  set @FaxSecondPart = @FaxSecondPart +' '

	--	select @FaxThirdPart = SUBSTRING(@Fax, 7, 4) 

	--	set @FaxUpdate = @FaxFirstPart + @FaxSecondPart + @FaxThirdPart
	--END		

	--Update the tblContact
	Update @MyFinalTable set 
	                 Phone = case len(@PhoneUpdate) when 0 then Phone else @PhoneUpdate end
					 --Mobile = case len(@MobileUpdate) when 0 then Mobile else @MobileUpdate end,
					 --Fax = case len(@FaxUpdate) when 0 then Fax else @FaxUpdate end
    WHERE ContactID = @ContactID
SELECT @Cnt = @Cnt + 1
		
END

SELECT * FROM @MyFinalTable

DELETE @MyTable
DELETE @MyFinalTable


   

   
