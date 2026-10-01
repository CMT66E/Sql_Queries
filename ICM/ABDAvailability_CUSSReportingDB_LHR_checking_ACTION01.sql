select   [ABDStationID],
      max([Date]) as ABD_Reached_Date 
FROM ABDAvailability LEFT OUTER JOIN AbdStation on ABDAvailability.[ABDStationID] = AbdStation.ID
group by [ABDStationID]
order by   max([Date]) desc