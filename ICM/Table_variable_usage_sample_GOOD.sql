
DECLARE @MyTable TABLE
	(
	SNo int IDENTITY(1,1), 
	ABDStationID int,
	ABD_Reached_Date datetime
	)   

INSERT INTO @MyTable(ABDStationID, ABD_Reached_Date)	    
select   [ABDStationID],
      max([Date]) as ABD_Reached_Date 
FROM            ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD') OR
                         (AbdStation.AbdType = 'KSK') OR
                         (AbdStation.AbdType = 'K')
GROUP BY [ABDStationID]

select * from @MyTable