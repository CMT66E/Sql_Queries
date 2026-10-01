Select * from AspNetUsers where
(FirstName like '%Natalie%' OR FirstName like '%Elena%'); --U400626 ; BarcodeID: 000544
--Password Exp. 2022-08-10 11:57:56
--Pin Exp. 2022-05-12 11:57:28
-- Has active barcode . Exp. 9999-12-31 23:59:59
Select * from AspNetUsers where
(FirstName like '%Gjok%' OR LastName like '%Nica%') -- U347856 ; BarcodeID: 000555
--wrong first name
--Password Exp. 2021-12-14 08:24:05
--Ping Exp. 2022-03-15 20:18:33
--prevbarcodeid same as current barcodeid; multiple other users like this but they're ok
-- active barcode . Exp. 9999-12-31 23:59:59
;

Declare @userId nvarchar(50) ,@barcodeID nvarchar(50)
Select @userId='U347856' ,@barcodeID='000555'
update AspNetUsers Set status ='Active', barcodeID=@barcodeID  Where ID =@userId
update Barcodes Set userID=@userId , expireddate='2022-03-31 23:59:59', Status ='Active'  where ID=@barcodeID

------------------------------------------------------------------------

--update AspNetUsers set FirstName = 'Gjokoa' where id = 'U347856'

Select * from AspNetUsers where id like '%U180338%' OR id like '%0721%' --U308533

Select * from AspNetUsers where id in ('U122998','U135665');
select * from Barcodes where UserId in ('U122998','U135665');
select * from AspNetUserLogins where UserId in ('U122998','U135665');
select * from AspNetUserClaims where UserId in ('U122998','U135665');
select * from AspNetUserClaims where UserId in ('U122998','U135665');
select * from AspNetUserTokens where UserId in ('U122998','U135665');
select * from UserLocation where UserId in ('U122998','U135665');
select * from APITokens where UserId in ('U122998','U135665');

DELETE from UserLocation where UserId in ('U122998','U135665');
DELETE from APITokens where UserId in ('U122998','U135665');
DELETE from AspNetUsers where id in ('U122998','U135665');

Update Barcodes set id ='NULL' where UserId in ('U754710','U102001','U400626','U374085','U202488','U126627');
Update AspNetUsers set PreviousBarcodeId = 'NULL' where PreviousBarcodeId in ('000511','000514','000521','000525','000539','000544');

--select * from Airports where UserId = 'U308533';
--select * from CMSessions where UserId = 'U308533';
--select * from Locations where UserId = 'U308533';
--select * from Countries where UserId = 'U308533';
--select * from Organizations where UserId = 'U308533';
--select * from AspNetRoles where UserId = 'U308533';
--select * from AspNetRoleClaims where UserId = 'U308533';

