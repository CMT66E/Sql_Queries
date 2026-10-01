SELECT TOP 10  [ID]
FROM [CUSSBagDropDB_CDG].[dbo].[CustomerSession]
order by ID desc
-- max ID: 23840884 23840883 23840882

----------------------------------------------------------
SELECT TOP 10  [ID]
FROM [CUSSReportingDB_CDG].[dbo].[CustomerSession]
order by ID desc
-- max ID: 23069323 23069322 23069321


-- 23840884 - 23069323 = 771,561
--------------------------------------------------------------------------------------------------------
SELECT TOP 500  [ID], *
FROM [CUSSBagDropDB_CDG].[dbo].[BagWeightUpdate] a
order by a.ID desc
-- max ID: 21590534

----------------------------------------------------------
SELECT TOP 500  [ID], *
FROM [CUSSReportingDB_CDG].[dbo].[BagWeightUpdate] a
order by a.ID desc
-- max ID: 21590646
-- 21590646 - 21590534 = 112