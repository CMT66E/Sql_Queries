declare @FromDateTime DateTime = '2021-05-01 00:00:00'
declare @ToDateTime DateTime = '2021-05-31 23:59:00'
declare @TimeSlotID int = 0
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = ' Display All ABDs'


DECLARE @MyTable TABLE
(
AbdStationID int NOT null, 
AbdStationName varchar(50),
AbdStateID int, 
[State] varchar(50),
MinutesInState int
)    

insert into @MyTable
SELECT     

AbdStation.ID AS AbdStationID, 
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea) AS AbdStationName, 
ABDStates.ID AS AbdStateID, 
ABDStates.State, 
SUM(ABDAvailability.MinutesInState) as MinutesInState

FROM         ABDAvailability INNER JOIN
						ABDStates ON ABDAvailability.ABDStateID = ABDStates.ID INNER JOIN
						StateTimeSlots ON ABDAvailability.StateTimeSlotID = StateTimeSlots.ID INNER JOIN
						TimeSlotHourly ON StateTimeSlots.TimeSlotHouryID = TimeSlotHourly.ID LEFT OUTER JOIN
						AbdStation ON ABDAvailability.AbdStationID = AbdStation.ID
WHERE        (ABDAvailability.Date  BETWEEN @FromDateTime AND @ToDateTime) 
	AND (@TimeSlotID = 0 OR ABDAvailability.StateTimeSlotID = @TimeSlotID)
	AND (AbdStation.Terminal LIKE @Terminal)
	AND (ISNULL(AbdStation.Area,'') LIKE @Area )
	AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
	AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.ID, AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea,ABDStates.ID, ABDStates.State
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), ABDStates.State

select a.*, b.KioskName from @MyTable a inner join AbdStation b on a.AbdStationID = b.ID
where AbdStateID = 3
order by AbdStationID, AbdStateID


--select * from ABDAvailability where DatePart(year, [Date]) = 2021 and DatePart(month, [Date]) = 4
--select distinct ABDStationID from ABDAvailability where DatePart(year, [Date]) = 2021 and DatePart(month, [Date]) = 4