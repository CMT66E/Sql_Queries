
SELECT a.[ID]
      ,[CustomerID]
      ,a.[AbdStationID]
      ,[CustomerLookupType]
      ,[PNR]
      ,[UtcCreationTime]
      ,[FlightID]
      ,a.[TimeSlot5minID]
      ,a.[TimeSlot10minID]
      ,a.[TimeSlotHourlyID]
      ,a.[DayOfTheWeekID]
      ,a.[LocalTime]
      ,[UtcCompletionTime]
      ,[SessionDuration]
      ,[SessionEndReasonID]
      ,[SessionEndPageID]
      ,[MachineTime]
      ,[PaxTime]
      ,[DcsTime]
      ,[BhsTime]
      ,[CsaTime]
      ,[NumberOfTubs]
      ,[IsReceiptPrinted]
	  ,b.*
	  ,c.*
	  ,d.*
  FROM [ReportingDB].[dbo].[CustomerSession] a inner join BagWeightUpdate b on a.ID = b.CustomerSessionID
  inner join AbdStation c on b.AbdStationID = c.ID
  inner join Flight d on a.FlightID =d.ID
  where 
  DATEPART(year, a.LocalTime) = 2021 and DATEPART(month, a.LocalTime) = 5 --total 4944
  and 
  --ID = 1649199
  a.PNR ='6MUHZL' --or PNR = '5EG29Y'


  select max(ID) from [BagDrop].[dbo].[CustomerSession] --order by ID desc
  select * from [BagDrop].[dbo].[CustomerSession] where ID = 1590302

  select max(ID) from [ReportingDB].[dbo].[CustomerSession] --order by ID desc
  select * from [ReportingDB].[dbo].[CustomerSession] where ID = 1590302