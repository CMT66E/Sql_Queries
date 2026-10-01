 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] order by ID desc -- 9460628
 SELECT TOP 1 * FROM [ReportingDB_SIN].[dbo].[CustomerSession] order by ID desc    -- 9448233 ==> 12,395
----------------------------------------------------------------------------------------------
 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] order by ID desc -- 10478575
 SELECT TOP 1 * FROM [ReportingDB_SIN].[dbo].[BagWeightUpdate] order by ID desc    -- 10463818 ==> 14,757

 SELECT COUNT(*) FROM [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate]   -- 10022133
 SELECT COUNT(*) FROM [ReportingDB_SIN].[dbo].[BagWeightUpdate]      -- 10022758
 ---------------------------------------------------------------------------------------------
 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[Bag] order by ID desc -- 10201619
 SELECT TOP 1 * FROM [ReportingDB_SIN].[dbo].[Bag] order by ID desc    -- 10201610   ==> 14,758
 ---------------------------------------------------------------------------------------------
 
 --insert into [ReportingDB_SIN].[dbo].[Bag]
 --select * from [BagDrop_SIN_ACTION].[dbo].[Bag] where ID > 10201619 order by ID
 ---------------------------------------------------------------------------------------------

 --SELECT TOP 10 * FROM [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] order by ID desc -- 15624254
 --SELECT TOP 10 * FROM [ReportingDB_SIN].[dbo].[BagWeightUpdate] order by ID desc    -- 10463827


 --SELECT  * FROM [ReportingDB_SIN].[dbo].[Bag] order by ID desc 