declare @FromDateTime datetime = '2019-01-01 00:00:00'
declare @ToDateTime datetime = '2019-01-01 23:59:59'
--------------------------------------------------------------------------------------------------------------------------
			declare @tblPassengersPerFlight table 
			(
			Id int identity, 
			[Year]  varchar(50),
			[Month]  varchar(50),
			[Day]  varchar(50),
			PortCode nvarchar(10),
			Identifier nvarchar(10),
			Terminal nvarchar(10), 
			Area nvarchar(10), 
			SubArea nvarchar(10), 
			AbdStationName varchar(50),
			DepartureDate datetime,
			AirlineCode nvarchar(10), 
			FlightNumber varchar(50),
			CustomerSessionID BigInt
			)

			insert into @tblPassengersPerFlight
			select distinct
				DATEPART(YEAR, BagWeightUpdate.LocalTime) AS Year, 
				DATEPART(MONTH, BagWeightUpdate.LocalTime) AS Month, 
				DATEPART(DAY, BagWeightUpdate.LocalTime) AS Day, 
				AbdStation.PortCode, 
				AbdStation.Identifier, 
				AbdStation.Terminal,
				AbdStation.Area,
				AbdStation.SubArea,	
				dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
				Flight.DepartureDate,	
				isnull(Flight.MarketingCarrier, 'xx') as AirlineCode,
				isnull(Flight.FlightNumber, 'xxx') as FlightNumber,	 
				CustomerSession.CustomerID
				--count(*) as TotalPax 								   
			FROM BagWeightUpdate INNER JOIN
				AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID INNER JOIN
				CustomerSession ON BagWeightUpdate.CustomerSessionID = CustomerSession.ID INNER JOIN
				Flight ON CustomerSession.FlightID = Flight.ID INNER JOIN 
				Bag ON BagWeightUpdate.BagID = Bag.ID
			WHERE (BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime)			 
			order by dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) desc
 
			SELECT  
			[Year], 
			[Month], 
			[Day], 
			PortCode, 
			Identifier, 
			Terminal,
			Area,
			SubArea,	
			AbdStationName, 
			DepartureDate,	
			AirlineCode,
			FlightNumber,	 
			count(CustomerSessionID) as TotalPax 	
			FROM @tblPassengersPerFlight
			GROUP BY 
 				[Year], 
				[Month], 
				[Day], 
				PortCode, 
				Identifier, 
				Terminal,
				Area,
				SubArea,	
				AbdStationName, 
				DepartureDate,	
				AirlineCode,
				FlightNumber
			order by AbdStationName, count(CustomerSessionID) desc

            delete @tblPassengersPerFlight
--------------------------------------------------------------------------------------------------------------------------