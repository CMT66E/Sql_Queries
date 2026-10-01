declare @encrypt varbinary(200) 
select @encrypt = EncryptByPassPhrase('key', 'abc' )
select @encrypt 
 
select convert(varchar(100),DecryptByPassPhrase('key', @encrypt ))
