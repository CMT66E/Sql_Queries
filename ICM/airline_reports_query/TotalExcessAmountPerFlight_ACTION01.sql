declare @FromDateTime DateTime = '2019/02/01 00:00:00'
declare @ToDateTime DateTime = '2019/02/28 23:59:59'
declare @FlightNumber Varchar(50) = '%'

			declare @tblCustomerSessionID table (Id int) 
			insert into @tblCustomerSessionID
			SELECT distinct
			isnull(CustomerSession.ID, 0)
			FROM BagWeightUpdate
			JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession ON ExcessDetailsLog.CustomerSessionID = CustomerSession.ID
			LEFT OUTER JOIN Flight ON CustomerSession.FlightID = Flight.ID			 
			WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
  
 
			--2. get all records not in table: ExcessTierLog put into table 
			declare @tblExcessRecords table 
			(
			Id int identity, 
			CustomerSessionID BigInt,
			FlightName varchar(50),
			FlightRoute varchar(50),
			ExcessValue BigInt,
			FlightNumber varchar(50)
			) 

			--records from table: ExcessDetailsLog
			insert into @tblExcessRecords(CustomerSessionID, FlightName, FlightRoute, ExcessValue, FlightNumber)
			select distinct
			custId.Id,
			isnull(Flight.MarketingCarrier + Flight.FlightNumber, 'X') AS FlightName,
			isnull(Flight.BoardPoint + ' - ' + Flight.OffPoint, '') as FlightRoute,
			cast(ExcessDetailsLog.TotalExcessValue as int) AS ExcessValue,
			CAST(Flight.FlightNumber AS nvarchar(100)) as FlightNumber			
			FROM @tblCustomerSessionID custId INNER JOIN BagWeightUpdate on custId.Id = BagWeightUpdate.CustomerSessionID
			INNER JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
			INNER JOIN ExcessDetailsLog ON BagWeightUpdate.CustomerSessionID = ExcessDetailsLog.CustomerSessionID
			LEFT OUTER JOIN CustomerSession cs ON ExcessDetailsLog.CustomerSessionID = cs.ID
			LEFT OUTER JOIN Flight ON cs.FlightID = Flight.ID			 
			WHERE Not cs.ID in (select CustomerSessionID from ExcessTierLog)

			--records from table: ExcessTierLog
			insert into @tblExcessRecords(CustomerSessionID, FlightName, FlightRoute, ExcessValue, FlightNumber)
			select 
			et.CustomerSessionID, 
			isnull(et.Company + cast(et.Flightnumber as varchar), '') as FlightName,
			isnull(et.Origin + ' - ' + et.Destination, '') as FlightRoute,
			cast(et.ChargeValueMoney as BigInt) AS ExcessValue,
			CAST(et.FlightNumber AS nvarchar(100)) as FlightNumber			 
			from ExcessTierLog et
			where et.CustomerSessionID in (select Id from  @tblCustomerSessionID)

			--final results
			select 
			isnull(er.FlightName, 'X') AS FlightName,
			isnull(er.FlightRoute, '') as FlightRoute,
			cast(sum(er.ExcessValue) as int) AS TotalExcessValue, 
			count(er.FlightName) AS NumberOfExcess
			FROM @tblExcessRecords as er
			WHERE (CAST(er.FlightNumber AS nvarchar(100)) LIKE @FlightNumber) 
			GROUP BY FlightName, FlightRoute
			ORDER BY TotalExcessValue DESC