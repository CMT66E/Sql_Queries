select getdate() as current_daetime
select DATEDIFF(MINUTE, getdate(), '2019-07-04 13:00:12')
select DATEDIFF(MINUTE, '2019-07-03 17:00:12', '2019-07-04 17:13:12')

select count(*) from CMOperationHistory