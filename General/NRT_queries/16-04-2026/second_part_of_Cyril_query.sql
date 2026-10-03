SELECT     
convert(date,CustomerSession.LocalTime) as Date,
cast(concat(year(CustomerSession.LocalTime),'-'
  ,case when month(CustomerSession.LocalTime) < 10 then concat('0',month(CustomerSession.LocalTime))
  else month(CustomerSession.LocalTime) end
  ,'-','01') as date) as [monthyear],
DATEPART(YEAR, CustomerSession.LocalTime) AS Year, 
DATEPART(MONTH, CustomerSession.LocalTime) AS Month, 
DATEPART(DAY, CustomerSession.LocalTime) AS Day, 
CASE WHEN (Flight.MarketingCarrier = 'GK' AND (case when concat('T',AbdStation.Terminal,AbdStation.SubArea) in ('T3D','T3C') then 'T3N' else concat('T',AbdStation.Terminal,AbdStation.SubArea) end) = 'T3N') THEN 'GK(T3N)'
      WHEN (Flight.MarketingCarrier = 'GK' AND (case when concat('T',AbdStation.Terminal,AbdStation.SubArea) in ('T3D','T3C') then 'T3N' else concat('T',AbdStation.Terminal,AbdStation.SubArea) end) = 'T3S') THEN 'GK(T3S)'
      else Flight.MarketingCarrier
      end as FlightArea,
Flight.MarketingCarrier,
CustomerSession.TimeSlot5minID,
CustomerSession.AbdStationID,
SUM(BagWeightUpdate.Weight) AS TotalWeight, 
COUNT(BagWeightUpdate.BagID) AS BagCount     
FROM  CUSSReportingDB_NRT.dbo.CustomerSession as CustomerSession INNER JOIN 
  CUSSReportingDB_NRT.dbo.BagWeightUpdate as BagWeightUpdate on CustomerSession.ID = BagWeightUpdate.CustomerSessionID INNER JOIN
  CUSSReportingDB_NRT.dbo.AbdStation as AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
  CUSSReportingDB_NRT.dbo.Flight as Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
  CUSSReportingDB_NRT.dbo.Bag as Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE datepart(year, CustomerSession.LocalTime) = 2026 and datepart(month, CustomerSession.LocalTime) = 2
--CustomerSession.LocalTime >=dateadd(month,datediff(month,0,getdate())-13,0)
and 
(
cast(concat(year(CustomerSession.LocalTime),'-'
  ,case when month(CustomerSession.LocalTime) < 10 then concat('0',month(CustomerSession.LocalTime))
  else month(CustomerSession.LocalTime) end
  ,'-','01') as date) <> 
cast(concat(year(GetDate()),'-'
  ,case when month(GetDate()) < 10 then concat('0',month(GetDate()))
  else month(GetDate()) end
  ,'-','01') as date)
)
and Flight.MarketingCarrier in ('GK')
GROUP BY 
convert(date,CustomerSession.LocalTime) ,
cast(concat(year(CustomerSession.LocalTime),'-'
  ,case when month(CustomerSession.LocalTime) < 10 then concat('0',month(CustomerSession.LocalTime))
  else month(CustomerSession.LocalTime) end
  ,'-','01') as date),
DATEPART(YEAR, CustomerSession.LocalTime), DATEPART(MONTH, CustomerSession.LocalTime), DATEPART(DAY, CustomerSession.LocalTime), Flight.MarketingCarrier,
CustomerSession.TimeSlot5minID,CustomerSession.AbdStationID,AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea