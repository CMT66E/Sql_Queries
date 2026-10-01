update AccountOperation set EffectiveDateFrom = convert(smalldatetime,convert(varchar(8), EffectiveDateFrom, 112))

select EffectiveDateFrom, convert(smalldatetime,convert(varchar(8), EffectiveDateFrom, 112)), * from AccountOperation