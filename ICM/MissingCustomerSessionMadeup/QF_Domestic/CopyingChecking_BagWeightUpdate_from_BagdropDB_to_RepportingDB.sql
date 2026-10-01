USE BagDropDB_QF_NEW
Go

-- total 657 records
declare @FromDateTime DateTime = '2022/11/19 00:00:00'

SELECT a.*
  FROM [BagDropDB_QF_NEW].[dbo].[BagWeightUpdate] a 
  inner join CustomerSession b on a.CustomerSessionID = b.ID
  inner join AbdStation c on b.AbdStationID = c.ID
where DATEPART(year, a.[LocalTime])= DATEPART(year, @FromDateTime) 
  and DATEPART(month, a.[LocalTime])= DATEPART(month, @FromDateTime)
  and DATEPART(day, a.[LocalTime]) in (19, 20, 21)
  and c.PortCode = 'WLG'
  and a.Weight > 0
  and NOT a.ID in
  (
	SELECT a.ID
	  FROM [ReportingDB_QF_New].[dbo].[BagWeightUpdate] a 
	  inner join CustomerSession b on a.ID = b.AbdStationID
	  inner join AbdStation c on b.AbdStationID = c.ID
	where DATEPART(year, a.[LocalTime])= DATEPART(year, @FromDateTime) 
	  and DATEPART(month, a.[LocalTime])= DATEPART(month, @FromDateTime)
	  and DATEPART(day, a.[LocalTime]) in (19, 20, 21)
	  and c.PortCode = 'WLG'
	  and a.Weight > 0
  )
----------------------------------------------------------------------
USE ReportingDB_QF_New
Go

-- MostFrequentSessionEndPerReasonPerScreen_SSISReports
declare @FromDateTime DateTime = '2022/11/19 00:00:00'

SELECT a.*
  FROM [ReportingDB_QF_New].[dbo].[BagWeightUpdate] a 
  inner join CustomerSession b on a.CustomerSessionID = b.ID
  inner join AbdStation c on b.AbdStationID = c.ID
where DATEPART(year, a.[LocalTime])= DATEPART(year, @FromDateTime) 
  and DATEPART(month, a.[LocalTime])= DATEPART(month, @FromDateTime)
  and DATEPART(day, a.[LocalTime]) in (19, 20, 21)
  and c.PortCode = 'WLG'
  and a.Weight > 0