declare @tempDiff  int 
set  @tempDiff = DATEDIFF(MONTH, '1900-01-01', GETDATE())  --month data calculation =1471
set  @tempDiff = DATEDIFF(MONTH, 0, GETDATE())             --month data calculation =1471

--0 means 1900-01-01 in Sql server

print 'month data calculation =' + cast(@tempDiff as varchar)