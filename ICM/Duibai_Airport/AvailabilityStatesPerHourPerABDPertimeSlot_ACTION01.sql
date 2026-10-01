
	declare @Date DateTime = '2021-12-13'
	declare @timeSlotname nvarchar(10) = '8' 

	DROP TABLE IF EXISTS #Temp 

    Select * into #temp From(
	SELECT     ABDAvailability.Date, dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType) AS AbdStationName, 
		TimeSlotHourly.TimeSlotName, ABDStates.State, Cast(ABDAvailability.MinutesInState As decimal(10,4)) as MinutesInState
	FROM         ABDAvailability INNER JOIN
						  ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						  StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						  TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						  AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
	WHERE     (ABDAvailability.Date = @Date AND TimeSlotHourly.TimeSlotName=@timeSlotname)
	--ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,AbdStation.AbdType), 
		--TimeSlotHourly.ID, TimeSlotHourly.TimeSlotName, ABDStates.State
		) as T

		SELECT * FROM (
		  SELECT
			[AbdStationName],
			[Date],
			[TimeSlotName],
			[State],
			[MinutesInState]
		  FROM #temp
		) Test
		PIVOT (
		  SUM([MinutesInState])
		  FOR [State]
		  IN (
			[Running],
			[InError],
			[ManualOutOfOrder],
			[OutOfOrder],
			[HealthyNotAvailable],
			[Unknown]
		  )
		) AS PivotTable


		--update ABDAvailability set date = '2021-12-02' where date = '2021-11-17'