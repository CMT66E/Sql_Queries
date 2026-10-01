select   [ABDStationID],
      max([Date]) as ABD_Reached_Date 
FROM ABDAvailability LEFT OUTER JOIN AbdStation on ABDAvailability.[ABDStationID] = AbdStation.ID
group by [ABDStationID]
order by   max([Date]) desc

select count(*) as ABDAvailabilityTotalCount from ABDAvailability
select count(*) as CustomerSessionTotalCount from CustomerSession -- 10332583

select top 10 * from CustomerSession order by ID desc -- 10369154
select top 10 * from [BagDrop_QF_New].[dbo].[CustomerSession] order by ID desc