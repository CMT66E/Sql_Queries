declare @Fromdate Datetime = '2026-05-01 00:00:00' --MAY 2026 needs 16 seconds 11338
declare @Todate  Datetime = '2026-05-31 23:59:59'  --APR 2026 needs 15 seconds 14377
declare @AirlineGroupID INT  = 2
		
Select Count(DISTINCT C.ID) as TotalPaxcountCurrentMonth
from CustomerSession C 
JOIN  BagWeightUpdate B on B.CustomerSessionID = C.ID
JOIN Flight F On C.FlightID = f.ID
JOIN AirlineGroup  AG  On Ag.AirlineGroupID = F.AirlineGroupID  
WHERE  c.LocalTime between @Fromdate and @Todate
AND f.AirlineGroupID=@AirlineGroupID Group  by AG.AirlineGroupID