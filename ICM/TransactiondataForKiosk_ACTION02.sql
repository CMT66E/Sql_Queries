USE [CUSSReportingDB_STR]
GO

declare @FromDateTime Datetime = '2021-11-01 00:00:00'
declare @ToDateTime  Datetime = '2021-11-30 23:59:59'

DROP TABLE IF EXISTS #CustomerSession
DROP TABLE IF EXISTS #DocPrinted
DROP TABLE IF EXISTS #DocScanned


			Select * into #CustomerSession From CustomerSession c Where c.LocalTime BETWEEN @FromDateTime and @ToDateTime

			Select c.id As CustomersessionID,Count(ISNULL(pd.DocType,0)) AS DocPrinted into #DocPrinted from  #CustomerSession c
			Join PrintDocument pd on c.ID = pd.CustomerSessionID
			Group BY C.ID

			Select c.id As CustomersessionID,Count(ISNULL(sc.DocType,0)) AS DocScanned into #DocScanned from  #CustomerSession c
			Join ScannedDocument sc on sc.CustomerSessionID = c.id
			Group BY C.ID


			Select 
			 c.ID AS CustomerSessionID, 
			CONVERT(varchar(30),c.LocalTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),c.LocalTime, 22), 11)) As LocalTime, 
			dbo.GetAbdName(a.Identifier, a.Terminal,a.Area,a.SubArea) AS ABDStation, 
			f.MarketingCarrier,
			f.FlightNumber,
			Cast(c.SessionDuration as Decimal(10,2)) as SessionDuration, 
			CONVERT(varchar(30),c.UtcCreationTime,103) + ' ' +  LTRIM(RIGHT(CONVERT(CHAR(20),c.UtcCreationTime, 22), 11)) AS UtcCreationTime,
			CONVERT(varchar(30),c.UtcCompletionTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),c.UtcCompletionTime, 22), 11)) AS UtcCompletionTime, 
			ISNULL(sc.DocScanned,0) as DocScanned ,
			ISNULL(pd.DocPrinted,0) as DocPrinted
			from #CustomerSession c
			left Join #DocScanned sc
			on c.ID = sc.CustomerSessionID 
			left Join #DocPrinted pd on pd.CustomerSessionID = c.ID
			join AbdStation a on a.ID = c.AbdStationID
			Join Flight F on f.id = c.FlightID
			where ISNULL(sc.DocScanned,0) <> 0  or ISNULL(pd.DocPrinted,0) <> 0
