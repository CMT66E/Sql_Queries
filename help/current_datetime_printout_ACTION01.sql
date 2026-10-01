declare @currentStartDateTime as Datetime 


select @currentStartDateTime = GetDate()
print '@currentStartDateTime = ' + cast(@currentStartDateTime as varchar)
GO
declare @currentEndDateTime as Datetime 
select @currentEndDateTime = GetDate()
print '@currentEndDateTime = ' + cast(@currentEndDateTime as varchar)