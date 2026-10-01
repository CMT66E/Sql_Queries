select TOP 10000 * 
FROM            ABDAvailability RIGHT OUTER JOIN
                         AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD') OR
                         (AbdStation.AbdType = 'KSK') OR
                         (AbdStation.AbdType = 'K')


--select * from ABDAvailability where ABDStateID = 188
--select * from AbdStation

----------------------------------------------------------------------------------------------
--SELECT   a.ID,
--         max(isnull([Date], '2022-05-01')) as ABD_Reached_Date
--FROM AbdStation a LEFT OUTER JOIN [ABDAvailability] b on a.ID = b.ABDStationID 
--GROUP BY a.ID
--ORDER BY a.ID 
--------------------------------------------------------------------------------------------
select   [ABDStationID],
      cast(max([Date]) as date) as ABD_Reached_Date_Short,
	  max([Date]) as ABD_Reached_Date
FROM ABDAvailability  INNER JOIN AbdStation on ABDAvailability.[ABDStationID] = AbdStation.ID
group by [ABDStationID]
order by   max([Date]) desc
--------------------------------------------------------------------------------------------
--select * from ABDAvailability where ID = 137214

--select   [ABDStationID],
--     -- cast(max([Date]) as date) as ABD_Reached_Date_Short,
--	  max([Date]) as ABD_Reached_Date
--FROM ABDAvailability
--group by [ABDStationID]
--order by  [ABDStationID] 