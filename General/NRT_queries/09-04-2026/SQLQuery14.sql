select * from [CUSSReportingDB_NRT].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT].[dbo].[Flight] c on b.FlightID = c.ID
where a.ID in 
(
8144380,
8026265,
8028355,
7962670,
7962702,
7962703,
7967777,
7967780,
7970749,
8001674,
8001681,
7980375,
7984320,
8167274
)

select * from [CUSSReportingDB_NRT_FEB2026].[dbo].[BagWeightUpdate] a 
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[CustomerSession] b on a.CustomerSessionID = b.ID
inner join [CUSSReportingDB_NRT_FEB2026].[dbo].[Flight] c on b.FlightID = c.ID
where a.ID in 
(
8144380,
8026265,
8028355,
7962670,
7962702,
7962703,
7967777,
7967780,
7970749,
8001674,
8001681,
7980375,
7984320,
8167274
)
