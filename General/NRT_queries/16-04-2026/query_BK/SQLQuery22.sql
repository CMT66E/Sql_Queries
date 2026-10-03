USE ReportingDB_NRT_FEB2026
GO 

SELECT     
BagWeightUpdate.ID   
FROM  dbo.CustomerSession as CustomerSession INNER JOIN 
  dbo.BagWeightUpdate as BagWeightUpdate on CustomerSession.ID = BagWeightUpdate.CustomerSessionID INNER JOIN
  dbo.AbdStation as AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
  dbo.Flight as Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
  dbo.Bag as Bag ON BagWeightUpdate.BagID = Bag.ID
WHERE 
--datepart(year, CustomerSession.LocalTime) = 2026 and datepart(month, CustomerSession.LocalTime) = 2
cast(concat(year(CustomerSession.LocalTime),'-'
  ,case when month(CustomerSession.LocalTime) < 10 then concat('0',month(CustomerSession.LocalTime))
  else month(CustomerSession.LocalTime) end
  ,'-','01') as date) = '2026-02-01 00:00:00.000'

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
and Flight.MarketingCarrier ='NH'
and not BagWeightUpdate.ID in
(
	SELECT     
	BagWeightUpdate.BagID   
	FROM  ReportingDB_NRT.dbo.CustomerSession as CustomerSession INNER JOIN 
  	  ReportingDB_NRT.dbo.BagWeightUpdate as BagWeightUpdate on CustomerSession.ID = BagWeightUpdate.CustomerSessionID INNER JOIN
  	  ReportingDB_NRT.dbo.AbdStation as AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
  	  ReportingDB_NRT.dbo.Flight as Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
  	  ReportingDB_NRT.dbo.Bag as Bag ON BagWeightUpdate.BagID = Bag.ID
	WHERE 
	--datepart(year, CustomerSession.LocalTime) = 2026 and datepart(month, CustomerSession.LocalTime) = 2
	cast(concat(year(CustomerSession.LocalTime),'-'
  	  ,case when month(CustomerSession.LocalTime) < 10 then concat('0',month(CustomerSession.LocalTime))
  	  else month(CustomerSession.LocalTime) end
  	  ,'-','01') as date) = '2026-02-01 00:00:00.000'
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
	and Flight.MarketingCarrier ='NH'
)
 