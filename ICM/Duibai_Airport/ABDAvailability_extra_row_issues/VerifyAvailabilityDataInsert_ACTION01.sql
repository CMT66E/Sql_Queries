SELECT    
AbdStation.ID AS AbdStationID, 
ISNULL(MAX(DATEADD(HOUR, DATEPART(HOUR, DATEADD(SECOND, 1, TimeSlotHourly.ToTime)), ABDAvailability.Date)), '1900-1-1') AS LastDate

FROM CussReportingDB_DXB.dbo.ABDAvailability RIGHT OUTER JOIN
                         CussReportingDB_DXB.dbo.AbdStation ON ABDAvailability.ABDStationID = AbdStation.ID LEFT OUTER JOIN
                         CussReportingDB_DXB.dbo.StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID LEFT OUTER JOIN
                         CussReportingDB_DXB.dbo.TimeSlotHourly ON TimeSlotHourly.ID = StateTimeSlots.TimeSlotHouryID
WHERE        (AbdStation.AbdType = 'ABD' OR AbdStation.AbdType = 'KSK' OR AbdStation.AbdType = 'K')
GROUP BY AbdStation.ID

select * from CussReportingDB_DXB.dbo.ABDAvailability
where ([Date] = '2021-02-19')
order by ABDStationID asc
--------------------------------------------------------------------------------------------------------------------------------------
--Database: CussReportingDB_DXB
select * from CussReportingDB_DXB.dbo.ABDAvailability
where ABDStationID = 1107
and ([Date] = '2021-02-20')
order by [Date], [StateTimeSlotID] 

select * from CussReportingDB_DXB.dbo.ABDAvailability
where ABDStationID = 1038 
and ([Date] = '2021-02-21')
order by [Date], [StateTimeSlotID] 
-----------------------------------------------------------------
--Database: CussReportingDB_DXB_PURE
select * from CussReportingDB_DXB_PURE.dbo.ABDAvailability
where ABDStationID = 1107
and ([Date] = '2021-02-20')
order by [Date], [StateTimeSlotID] 

select * from CussReportingDB_DXB_PURE.dbo.ABDAvailability
where ABDStationID = 1038 
and ([Date] = '2021-02-21')
order by [Date], [StateTimeSlotID] 

------------------------------------------------------------------------------------------

--Database: CUSSReportingDB_STR 
select * from CUSSReportingDB_STR.dbo.ABDAvailability
where ABDStationID = 1
and ([Date] = '2021-02-20')
order by [Date], [StateTimeSlotID] 

select * from CUSSReportingDB_STR.dbo.ABDAvailability
where ABDStationID = 1
and ([Date] = '2021-02-21')
order by [Date], [StateTimeSlotID] 
-----------------------------------------------------------------
--Database: CUSSReportingDB_STR_PURE
select * from CUSSReportingDB_STR_PURE.dbo.ABDAvailability
where ABDStationID = 24 
and ([Date] = '2021-02-20')
order by [Date], [StateTimeSlotID] 

select * from CUSSReportingDB_STR_PURE.dbo.ABDAvailability
where ABDStationID = 24 
and ([Date] = '2021-02-21')
order by [Date], [StateTimeSlotID] 
-----------------------------------------------------------------
--Database: CUSSReportingDB_AMM
select * from CUSSReportingDB_AMM.dbo.ABDAvailability
where ABDStationID = 6
and ([Date] = '2021-02-20')
order by [Date], [StateTimeSlotID] 

select * from CUSSReportingDB_AMM.dbo.ABDAvailability
where ABDStationID = 6 
and ([Date] = '2021-02-21')
order by [Date], [StateTimeSlotID] 
--------------------------------------------------------------------------------------------------------------------------------------
--currently records as below
--13-02-2021 02:03AM   schedule task has been run:
--maxToTime = 2/13/2021 01:00:00 AM