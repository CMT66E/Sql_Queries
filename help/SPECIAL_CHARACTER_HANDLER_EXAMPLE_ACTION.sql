declare @Temp varchar(50) 
select @Temp = ('O' + char(39) +'connor') 
print '@Temp=' + cast(@Temp as varchar)


declare @post int
select @post = charindex(char(39), @Temp)
print '@post=' + cast(@post as varchar)


if charindex(char(39), @Temp) >= 0
begin
		select @post = charindex(char(39), @Temp)
		print '@post=' + cast(@post as varchar)
		--SET @Temp = REPLACE('', '''', @Temp)
end


print '@Temp=' + cast(@Temp as varchar)

SET @Temp = substring(@Temp, @post + 1, (len(@Temp) - charindex('', @Temp))+ 1)
print '@TempB=' + cast(@Temp as varchar)

