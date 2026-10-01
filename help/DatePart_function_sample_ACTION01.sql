select TOP 1 C.ID from CustomerSession C Where C.SessionDuration is null and DatePart(year, localTime) = DatePart(year, GETDATE())
select DatePart(year, GETDATE()) as ThisYear
select * from CustomerSession C Where C.SessionDuration is null and DatePart(year, localTime) = DatePart(year, GETDATE())

select count(*) from CustomerSession where DatePart(year, localTime) < DatePart(year, GETDATE())
