USE SampleDB;
GO
-- Create Table
CREATE TABLE dbo.Customer_data
(Customer_id int constraint Pkey3 Primary Key NOT NULL,
Customer_Name varchar(100) NOT NULL,
Credit_card_number varchar(25) NOT NULL)
-- Populate Table
INSERT INTO dbo.Customer_data 
VALUES (74112,'MSSQLTips2','2147-4574-8475')
GO
INSERT INTO dbo.Customer_data 
VALUES (74113,'MSSQLTips3','4574-8475-2147')
GO
INSERT INTO dbo.Customer_data 
VALUES (74114,'MSSQLTips4','2147-8475-4574')
GO
INSERT INTO dbo.Customer_data 
VALUES (74115,'MSSQLTips5','2157-1544-8875')
GO
-- Verify data
SELECT * 
FROM dbo.Customer_data
GO

select Customer_id, Customer_Name, Credit_card_number, [dbo].[ufn_EncryptString](cast(Customer_data.Credit_card_number as varchar)) as EncryptedCreditCardNo 
from dbo.Customer_data

select [dbo].[ufn_EncryptString](cast('2157-1544-8875' as varbinary)) as EncryptedCreditCardNo 

select Customer_id, Customer_Name, Credit_card_number, [dbo].[ufn_EncryptString](cast(Customer_data.Credit_card_number as varchar)) as EncryptedCreditCardNo,
[dbo].[ufn_DecryptString]([dbo].[ufn_EncryptString](cast(Customer_data.Credit_card_number as varchar))) as DecryptedCreditCardNo
from dbo.Customer_data

---------------------------------------------------------------------------------
SELECT dbo.Encrypt2String(65536) 
SELECT dbo.Decrypt2Number('DSYQ')
---------------------------------------------------------------------------------
/****** Script for SelectTopNRows command from SSMS  ******/
--insert into  login_details
--select 1,'smith',EncryptByPassPhrase('8','ABC') union all
--select 2,'jean',EncryptByPassPhrase('8','DEF') union all
--select 3,'michael',EncryptByPassPhrase('8','GHI')

SELECT TOP (1000) [uid]
      ,[username]
      ,[password]
FROM [SampleDB].[dbo].[login_details]

SELECT uid,username,
DECRYPTBYPASSPHRASE ('8',password)as DecryptedPassword
FROM login_details

SELECT uid,username,
CONVERT(varchar(50),DECRYPTBYPASSPHRASE ('8',password)) as Password
FROM login_details
---------------------------------------------------------------------------------