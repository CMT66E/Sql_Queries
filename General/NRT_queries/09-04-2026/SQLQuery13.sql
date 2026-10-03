select * from [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
where a.ID in 
(
7960943,
8026883,
8026892,
8022641,
7999965
)

select * from [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
where a.ID in 
(
7960943,
8026883,
8026892,
8022641,
7999965
)

---------
select * from [CUSSReportingDB_NRT].[dbo].[CustomerSession] where ID in
(
13559155,
13628150,
13668047,
13675873,
13675898
)
