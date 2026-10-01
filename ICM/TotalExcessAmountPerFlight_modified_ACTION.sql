		    declare @FromDateTime DateTime = '2019/03/10 00:00:00'
	        declare @ToDateTime DateTime = '2019/03/24 23:59:59'

			SELECT 
			CustomerSession.ID,
			BagWeightUpdate.LocalTime,
			isnull(Flight.MarketingCarrier + Flight.FlightNumber, 'X') AS FlightName,
			isnull(Flight.BoardPoint + ' - ' + Flight.OffPoint, '') as FlightRoute,
			cast(ExcessDetailsLog.TotalExcessValue as int) AS TotalExcessValue 
			
			FROM BagWeightUpdate
			JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession ON ExcessDetailsLog.CustomerSessionID = CustomerSession.ID
			LEFT OUTER JOIN Flight ON CustomerSession.FlightID = Flight.ID
			 
			WHERE 
			--CustomerSession.ID = 700034
		 --   and 
			BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime


			--1. get all CustomerSession IDs which meets the timeframe in table: ExcessDetailsLog
			declare @tblCustomerSessionID table (Id int) 
			insert into @tblCustomerSessionID
			SELECT 
			isnull(CustomerSession.ID, 0)
			FROM BagWeightUpdate
			JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession ON ExcessDetailsLog.CustomerSessionID = CustomerSession.ID
			LEFT OUTER JOIN Flight ON CustomerSession.FlightID = Flight.ID			 
			WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime


			select * from @tblCustomerSessionID

			--2. get all records not in table: ExcessTierLog put into table 
			declare @tblExcessRecords table 
			(
			Id int identity, 
			FlightName varchar(50),
			FlightRoute varchar(50),
			ExcessValue BigInt
			) 

			--records from table: ExcessDetailsLog
			insert into @tblExcessRecords(FlightName, FlightRoute, ExcessValue)
			select 	isnull(Flight.MarketingCarrier + Flight.FlightNumber, 'X') AS FlightName,
			isnull(Flight.BoardPoint + ' - ' + Flight.OffPoint, '') as FlightRoute,
			cast(ExcessDetailsLog.TotalExcessValue as int) AS ExcessValue 			
			FROM BagWeightUpdate
			JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession cs ON ExcessDetailsLog.CustomerSessionID = cs.ID
			LEFT OUTER JOIN Flight ON cs.FlightID = Flight.ID			 
			WHERE cs.ID in (select Id from  @tblCustomerSessionID) and Not cs.ID in (select CustomerSessionID from ExcessTierLog)

			select * from @tblExcessRecords

			--records from table: ExcessTierLog
			insert into @tblExcessRecords(FlightName, FlightRoute, ExcessValue)
			select isnull(et.Company + cast(et.Flightnumber as varchar), '') as FlightName,
			isnull(et.Origin + ' - ' + et.Destination, '') as FlightRoute,
			cast(et.ChargeValueMoney as BigInt) AS ExcessValue 
			from ExcessTierLog et
			where et.CustomerSessionID in (select Id from  @tblCustomerSessionID)

			select * from @tblExcessRecords
		 
			select 
			isnull(er.FlightName, 'X') AS FlightName,
			isnull(er.FlightRoute, '') as FlightRoute,
			cast(sum(er.ExcessValue) as int) AS TotalExcessValue, 
			count(er.FlightName) AS NumberOfExcess
			FROM @tblExcessRecords as er
			GROUP BY FlightName, FlightRoute
			ORDER BY TotalExcessValue DESC