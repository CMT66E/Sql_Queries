
--If you use CHARINDEX to find something please make sure it is great than 0 not
declare @ABDStationIDs varchar(100) = ',4,5,6,7,8,'

declare @IndexValue int
declare @comaInput varchar(100)

set @comaInput = ',' + CAST(5 AS varchar(10)) + ',' -- such as ,6,
set @IndexValue = CHARINDEX(@comaInput, @ABDStationIDs)

print '@IndexValue =' + cast(@IndexValue as varchar)

SELECT CHARINDEX('c', 'Customer') AS MatchPosition;



print '@IndexValue =' + cast(CHARINDEX(',', ',QF,') as varchar)
