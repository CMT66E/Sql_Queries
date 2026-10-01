

SELECT cast(cast(cast(EOMONTH('2022-07-15') as date) as varchar(50)) + ' 11:59:59 PM' as datetime) as EndDate
