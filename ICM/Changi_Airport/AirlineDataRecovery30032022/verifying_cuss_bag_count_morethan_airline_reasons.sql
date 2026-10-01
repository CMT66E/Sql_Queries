select count(*) as BagDropCustomerSessionCount FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] -- short day 24, 25, 26, 27, 28 in March 2022
where Datepart(year, LocalCreationTime) = 2022 and Datepart(month, LocalCreationTime) = 3 and Datepart(day, LocalCreationTime) = 14

select * from [BagDrop_SIN_ACTION].[dbo].[CustomerSession]  
where Datepart(year, LocalCreationTime) = 2022 and Datepart(month, LocalCreationTime) = 3 and Datepart(day, LocalCreationTime) = 14
--------------------------------------------------------------------------------------------------------------------------------------------------------
select count(*) as CUSSReportingDBCustomerSessionCount FROM [CUSSReportingDB_SIN].[dbo].[CustomerSession]
where Datepart(year, LocalTime) = 2022 and Datepart(month, LocalTime) = 3 and Datepart(day, LocalTime) = 14

select * FROM [CUSSReportingDB_SIN].[dbo].[CustomerSession]
where Datepart(year, LocalTime) = 2022 and Datepart(month, LocalTime) = 3 and Datepart(day, LocalTime) = 14
--------------------------------------------------------------------------------------------------------------------------------------------------------
select * FROM [CUSSReportingDB_SIN].[dbo].[CustomerSession]
where Datepart(year, LocalTime) = 2022 and Datepart(month, LocalTime) = 3 and Datepart(day, LocalTime) = 14
and NOT PNR IN
(
select PNR from [BagDrop_SIN_ACTION].[dbo].[CustomerSession]  
where Datepart(year, LocalCreationTime) = 2022 and Datepart(month, LocalCreationTime) = 3 and Datepart(day, LocalCreationTime) = 14
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

select CustomerSession.* 
from  BagWeightUpdate INNER JOIN
				CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
				Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
				Bag ON BagWeightUpdate.BagID = Bag.ID INNER JOIN
			AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
where Datepart(year, CustomerSession.LocalTime) = 2022 and Datepart(month, CustomerSession.LocalTime) = 3 and Datepart(day, CustomerSession.LocalTime) = 14
and BagWeightUpdate.Weight > 0