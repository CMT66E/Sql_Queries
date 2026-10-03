select dateadd(month,datediff(month,0,getdate())-13,0) as Temp1

declare @CurrentDateTime DateTime = '2026/03/16 00:00:00 AM'
select dateadd(month,datediff(month,0,@CurrentDateTime)-13,0) as Temp2