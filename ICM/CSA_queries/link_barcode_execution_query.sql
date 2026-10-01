--Execute the below query to link barcodeid with userID and activate the account. 

Declare @userId nvarchar(50) ,@barcodeID nvarchar(50) 
Select @userId='U850938',  @barcodeID='000591' 

update AspNetUsers Set status ='Active', barcodeID=@barcodeID  Where ID =@userId 
update Barcodes Set userID=@userId , expireddate='9999-12-31 23:59:59', Status ='Active'  where ID=@barcodeID 