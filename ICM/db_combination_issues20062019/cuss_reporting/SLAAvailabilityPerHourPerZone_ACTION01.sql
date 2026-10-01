declare @FromDateTime DateTime = '2019/01/04 00:00:00'
declare @ToDateTime DateTime = '2019/01/04 23:59:59'
declare @Zone nvarchar(20) = '%'
declare @Terminal nvarchar(10) = 'DEV'

    declare @portID int = 0
	If @Terminal = null
	   set @Terminal = '%'

    IF (@Terminal <> '%') AND (len(@Terminal) > 0)
	BEGIN
	    if exists(select PortID from Ports where PortAbrv like '%' + @Terminal + '%')
	      select @portID = isnull(PortID, 0) from Ports where PortAbrv like '%' + @Terminal + '%'
		else
		  select @portID = -1
	END

	

    IF (@Zone <>'%')
	BEGIN
		SELECT     SLAAvailabilityPerZone.Date, SLASevStates.ID AS SLASevStateID, SLASevStates.SevStateName, SUM(SLAAvailabilityPerZone.MinutesInState) AS MinutesInState,SLAAvailabilityPerZone.Zone 
                      
		FROM        SLAAvailabilityPerZone   INNER JOIN
							  SLASevStates ON SLAAvailabilityPerZone.SLASevStateID = SLASevStates.ID
		WHERE        (SLAAvailabilityPerZone.Date BETWEEN @FromDateTime AND @ToDateTime) AND ISNULL(SLAAvailabilityPerZone.Zone,'') LIKE @Zone
		 AND isnull(PortID, 0) = (case @portID when 0 then isnull(PortID, 0) else @portID end)
		GROUP BY SLAAvailabilityPerZone.Date, 	SLASevStates.ID, SLASevStates.SevStateName,SLAAvailabilityPerZone.Zone 
		ORDER BY SLAAvailabilityPerZone.Date
    END
	ELSE
	BEGIN
	    print '@portID = ' + cast(@portID as varchar)

		SELECT     SLAAvailabilityPerZone.Date, SLASevStates.ID AS SLASevStateID, SLASevStates.SevStateName, SUM(SLAAvailabilityPerZone.MinutesInState) AS MinutesInState,SLAAvailabilityPerZone.Zone 
                      
		FROM        SLAAvailabilityPerZone   INNER JOIN
							  SLASevStates ON SLAAvailabilityPerZone.SLASevStateID = SLASevStates.ID
		WHERE        (SLAAvailabilityPerZone.Date BETWEEN @FromDateTime AND @ToDateTime) 
		   AND isnull(PortID, 0) = (case @portID when 0 then isnull(PortID, 0) else @portID end)
		GROUP BY SLAAvailabilityPerZone.Date, 	SLASevStates.ID, SLASevStates.SevStateName,SLAAvailabilityPerZone.Zone 
		ORDER BY SLAAvailabilityPerZone.Date
	END