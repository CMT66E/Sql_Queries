USE [CUSSBagDropDB_NRT]
GO

DECLARE @MyTable TABLE
(
SNo int IDENTITY(1,1), 
AbdStationID int
) 

insert into @MyTable(AbdStationID)
SELECT   [ID]
FROM [AbdStation]
where ID in
(
12,
13,
11,
14,
15,
17,
16,
18,
19,

77,
78,
87,
88,
89,
90,
91,
92,
93,
94,
105,


101,
103,
102,
104,
109,

106,
107
)
select * from @MyTable

select distinct AbdStationID from CustomerSession where DATEPART(year, LocalCreationTime) = 2022 and DATEPART(month, LocalCreationTime) = 11 and AbdStationID in
(
select AbdStationID from @MyTable
)
order by AbdStationID



select * from AbdModeHistory where AbdStationID = 113
select * from AbdStateHistory where AbdStationID = 113
select * from AbdWayfinderStateHistory where AbdStationID = 113
select * from CussSession where AbdStationID = 113 
select * from CustomerSession where ApplicationSessionId in (select ApplicationSessionId from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 ))
select * from ApplicationSession where CussSessionId in (select CussSessionId from CussSession where AbdStationID = 113 )