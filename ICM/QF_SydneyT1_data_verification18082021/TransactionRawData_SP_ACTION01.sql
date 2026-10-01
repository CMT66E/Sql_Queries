
declare @FromDate DateTime = '2021/05/01 00:00:00'
declare @ToDate DateTime = '2021/05/31 23:59:59'

DECLARE @TempCustomerSesion TABLE
(
BagID BIGINT, 
CustomerSessionID  BIGINT, 
LocalTime VARCHAR(100),
ABDStation VARCHAR(100),
TransactionTime decimal(10, 2),
MarketingCarrier  VARCHAR(100),
FlightNumber  VARCHAR(100),
PNR  VARCHAR(100),
SessionDuration decimal(10, 2),
BagCount int,
UtcCreationTime VARCHAR(100),
UtcCompletionTime VARCHAR(100),
Weight decimal(10, 0),
IsHeavyBag  VARCHAR(10)
)

INSERT INTO @TempCustomerSesion
SELECT     bagt.BagID, 
			tempt.ID AS CustomerSessionID, 
			CONVERT(varchar(30),tempt.LocalTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),tempt.LocalTime, 22), 11)) As LocalTime, 
			dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS ABDStation, 
			Cast(tempt.TransactionTime as Decimal(10,2))TransactionTime, 
			Flight.MarketingCarrier,
			Flight.FlightNumber,
			tempt.PNR, 
			Cast(tempt.SessionDuration as Decimal(10,2)) as SessionDuration, 
			tempt.BagCount,
			CONVERT(varchar(30),tempt.UtcCreationTime,103) + ' ' +  LTRIM(RIGHT(CONVERT(CHAR(20),tempt.UtcCreationTime, 22), 11)) AS UtcCreationTime,
			CONVERT(varchar(30),tempt.UtcCompletionTime,103) + ' ' + LTRIM(RIGHT(CONVERT(CHAR(20),tempt.UtcCompletionTime, 22), 11)) AS UtcCompletionTime, 
			bagt.Weight, 
			CAST(CASE WHEN bagt.Weight < 23 THEN 'No' ELSE 'H' END AS CHAR) AS IsHeavyBag
FROM         BagWeightUpdate AS bagt INNER JOIN
							(SELECT     CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
													CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
													CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
													CustomerSession.SessionDuration, COUNT(BagWeightUpdate.BagID) AS BagCount, 
													CustomerSession.SessionDuration / COUNT(BagWeightUpdate.BagID) AS TransactionTime
							FROM          CustomerSession INNER JOIN
													BagWeightUpdate ON CustomerSession.ID = BagWeightUpdate.CustomerSessionID
							GROUP BY CustomerSession.ID, CustomerSession.CustomerID, CustomerSession.AbdStationID, CustomerSession.CustomerLookupType, CustomerSession.PNR, 
													CustomerSession.UtcCreationTime, CustomerSession.FlightID, CustomerSession.TimeSlot5minID, CustomerSession.TimeSlot10minID, 
													CustomerSession.TimeSlotHourlyID, CustomerSession.DayOfTheWeekID, CustomerSession.LocalTime, CustomerSession.UtcCompletionTime, 
													CustomerSession.SessionDuration
														HAVING      (CustomerSession.LocalTime >= @FromDate
														) AND CustomerSession.LocalTime <= @ToDate
														) AS tempt ON bagt.CustomerSessionID = tempt.ID INNER JOIN
						Bag ON bagt.BagID = Bag.ID INNER JOIN
						Flight ON tempt.FlightID = Flight.ID INNER JOIN
						AbdStation ON tempt.AbdStationID = AbdStation.ID
ORDER BY tempt.UtcCreationTime

select DISTINCT 
a.PNR as PNR, 
a.MarketingCarrier + a.FlightNumber as QF_Flight,
substring(a.LocalTime, 0, 11) as LocalTime,
b.UBI from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID


select 
count(b.UBI),
b.UBI from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID
group by b.UBI
having count(b.UBI) > 1

select 
a.PNR as PNR, 
a.MarketingCarrier + a.FlightNumber as QF_Flight,
a.LocalTime as LocalTime,
b.UBI from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID
WHERE 
b.UBI in
(
'10CAC2002575440F',
'10CAC2002575C01F',
'10CAC2002575C0B6',
'10CAC20025764E3D',
'10CAC200257BF90E',
'10CAC200257D05FB',
'10CAC200257DBFE2'
)

 
select distinct b.UBI from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID
where not b.UBI in
(
SELECT  
      [BAG_UBI_ID]       
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  WHERE not [BAG_UBI_ID] is null
  --not [PNR_REF] is null 
  --and datepart(year, [ACTIVITY_TSMP_UT+10]) = 2021 and datepart(month, [ACTIVITY_TSMP_UT+10]) = 5
)


select a.*, b.UBI from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID
where b.UBI in 
(
select distinct b.UBI from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID
where not b.UBI in
(
SELECT  
      [BAG_UBI_ID]       
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  WHERE not [BAG_UBI_ID] is null
  --not [PNR_REF] is null 
  --and datepart(year, [ACTIVITY_TSMP_UT+10]) = 2021 and datepart(month, [ACTIVITY_TSMP_UT+10]) = 5
)
)


select distinct a.PNR from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID
where b.UBI in 
(
select distinct b.UBI from @TempCustomerSesion a inner join Bag b on a.BagID = b.ID
where not b.UBI in
(
SELECT  
      [BAG_UBI_ID]       
  FROM [CUSSReportingDB].[dbo].[QantasMay2021DataSheet]
  WHERE not [BAG_UBI_ID] is null
  --not [PNR_REF] is null 
  --and datepart(year, [ACTIVITY_TSMP_UT+10]) = 2021 and datepart(month, [ACTIVITY_TSMP_UT+10]) = 5
)
)