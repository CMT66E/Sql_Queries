
select charindex('/', '09/08/2016') as indexValue
select substring('09/08/2016', len('09/08/2016') - charindex('/', REVERSE('09/08/2016')) + 2, 4) as Temp

SELECT REVERSE('09/08/2016')

select charindex('/', REVERSE('09/08/2016')) as indexValue
select len('09/08/2016')  as lenTemp

select len('09/08/2016') - charindex('/', REVERSE('09/08/2016')) as indexValue


select substring('09/08/2016', 7, 4) as Temp