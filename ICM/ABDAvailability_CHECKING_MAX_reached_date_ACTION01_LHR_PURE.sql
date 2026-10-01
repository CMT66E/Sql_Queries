select   [ABDStationID],
      cast(max([Date]) as date) as ABD_Reached_Date_Short,
	  max([Date]) as ABD_Reached_Date
FROM ABDAvailability  INNER JOIN AbdStation on ABDAvailability.[ABDStationID] = AbdStation.ID
group by [ABDStationID]
order by   max([Date]) desc  --41678 -> 2022-07-30