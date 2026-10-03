

insert into [CUSSReportingDB_NRT_MAR2026].dbo.CustomerSession(
                                 [ID]
								,[CustomerID]
								,[AbdStationID]
								,[CustomerLookupType]
								,[PNR]
								,[UtcCreationTime]
								,[FlightID]
								,[TimeSlot5minID]
								,[TimeSlot10minID]
								,[TimeSlotHourlyID]
								,[DayOfTheWeekID]							 
								,[LocalTime]
								,[UtcCompletionTime]
								,[SessionDuration]
								)
select TOP 1  
                                 14484577 as ID
								,[CustomerID]
								,[AbdStationID]
								,[CustomerLookupType]
								,[PNR]
								,[UtcCreationTime]
								,[FlightID]
								,[TimeSlot5minID]
								,[TimeSlot10minID]
								,[TimeSlotHourlyID]
								,[DayOfTheWeekID]							 
								,[LocalTime]
								,[UtcCompletionTime]
								,[SessionDuration]
from [CUSSReportingDB_NRT_MAR2026].dbo.CustomerSession order by ID desc


--delete from [CUSSReportingDB_NRT_MAR2026].dbo.CustomerSession where ID = 14484577