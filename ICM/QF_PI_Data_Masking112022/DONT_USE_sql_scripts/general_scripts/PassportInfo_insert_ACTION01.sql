USE [BagDrop]
GO

INSERT INTO [dbo].[PassportInfo]
           ([AbdStationID]
           ,[CustomerSessionID]
           ,[DocumentNumber]
           ,[FirstName]
           ,[LastName]
           ,[Gender]
           ,[DOB]
           ,[Expiry]
           ,[Issuer]
           ,[Nationality]
           ,[Type]
           ,[IsPassportPhotoRetrieved]
           ,[IsRFIDPhoto]
           ,[IsVerifiedSucessfully]
           ,[LocalCreationTime])
 VALUES
           (
			 9 
			,666666 
			,'GI750195' 
			,'JAMES' 
			,'BOND' 
			,'F'
			,'1966-03-20'
			,'2024-09-11'
			,'CAN' 
			,'CAN' 
			,'PASSPORT'
			,1  
			,0  
			,1  
			,'2019-02-22 10:46:53.057'
		   )
GO

--update [PassportInfo] set FirstName = 'Eric' where ID = 89085
--
alter table PassportInfo disable trigger [trigger_passportinfo_insert]
alter table PassportInfo enable trigger [trigger_passportinfo_insert]

