
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

	DECLARE @MyTable TABLE
	(
	CustomerSessionID int, 
	LocalTime varchar(50),
	ABDStation varchar(50),
	MarketingCarrier varchar(50),
	FlightNumber varchar(50),
	SessionDuration Decimal(10,2),
	UtcCreationTime varchar(50),
	UtcCompletionTime varchar(50),
	DocScanned int,
	DocPrinted int
	)    

	insert into @MyTable
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
	 
	  
select * from @MyTable where MarketingCarrier = 'EW'                        --2135 records
select * from @MyTable where MarketingCarrier = 'EW' and FlightNumber = '0' --782 records

select a.*, c.* from @MyTable a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join AbdStation c on b.AbdStationID = c.ID
where a. MarketingCarrier = 'EW' 

--we check data based on this condition: EW is only enabled on K03 to K10
select a.*, c.* from @MyTable a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join AbdStation c on b.AbdStationID = c.ID
where a. MarketingCarrier = 'EW'  and c.Identifier in ('003', '004','005','006','007','008','009','010') 

--we check data based on this condition: EW is NOT on K03 to K10
select a.*, c.* from @MyTable a 
inner join CustomerSession b on a.CustomerSessionID = b.ID
inner join AbdStation c on b.AbdStationID = c.ID
where a. MarketingCarrier = 'EW'  and not c.Identifier in ('003', '004','005','006','007','008','009','010') 
--and a.FlightNumber <> '0'

--select * from Flight where FlightNumber in ('2964', '2536')
--select * from Flight where FlightNumber = '0'