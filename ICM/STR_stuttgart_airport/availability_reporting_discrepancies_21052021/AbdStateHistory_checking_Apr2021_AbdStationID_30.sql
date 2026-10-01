/****** Script for SelectTopNRows command from SSMS  ******/
declare @CurrentAbdStationID int = 26
SELECT [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSBagDropDB_STR].[dbo].[AbdStateHistory]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 5
and [AbdStationID] in
(
3,
5,
6,
7,
8,
9,
10,
11,
12,
13,
14,
15,
16,
21,
22,
26,
28,
29,
30
)


SELECT [ID]
      ,[AbdStationID]
      ,[State]
      ,[UtcTime]
      ,[LocalTime]
  FROM [CUSSBagDropDB_STR].[dbo].[AbdStateHistory]
WHERE DatePart(year, [LocalTime]) = 2021 and DatePart(month, [LocalTime]) = 5
and [AbdStationID] in
(
3,
5,
6,
7,
8,
9,
10,
11,
12,
13,
14,
15,
16,
21,
22,
26,
28,
29,
30
)