SELECT TOP 10 *
FROM [BagDrop_QF_New].[dbo].[CustomerSession]
order by ID desc

SELECT TOP 10 *
FROM [ReportingDB_QF_New].[dbo].[CustomerSession]
order by ID desc

--original [BagDrop_QF_New] 5824027 -> [ReportingDB_QF_New] 5823690 = 337 records need to be transferred
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 10 *
FROM [BagDrop_QF_New].[dbo].[CustomerSessionTimeOnEachScreen]
order by ID desc

SELECT TOP 10 *
FROM [ReportingDB_QF_New].[dbo].[CustomerSessionTimeOnEachScreen]
order by ID desc
--original [BagDrop_QF_New] 78359474 -> [ReportingDB_QF_New] 78347517 = 11,957 records need to be transferred
--------------------------------------------------------------------------------------------------------------------