 ---------------------------------------------------------
 SELECT TOP 1 * FROM [CUSSBagDropDB_SIN].[dbo].[Bag] order by ID desc       --13964637
 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[Bag] order by ID desc      --10201619 => 10216368  
  ---------------------------------------------------------
 SELECT TOP 1 * FROM [CUSSBagDropDB_SIN].[dbo].[CustomerSession] order by ID desc -- 9856257
 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] order by ID desc -- 9448242 => 9460525  
  --------------------------------------------------------- 
 SELECT TOP 1 * FROM [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] order by ID desc  -- 13964636
 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] order by ID desc -- 10463827 => 10478575
 ---------------------------------------------------------
 SELECT TOP 1 * FROM [CUSSBagDropDB_SIN].[dbo].[AbdStation] order by ID desc  -- 264
 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[AbdStation] order by ID desc -- 143003 => 143003 
 ---------------------------------------------------------
 SELECT TOP 1 * FROM [CUSSBagDropDB_SIN].[dbo].[Flight] order by ID desc  --  316660
 SELECT TOP 1 * FROM [BagDrop_SIN_ACTION].[dbo].[Flight] order by ID desc --  308062 => 308155 
 ---------------------------------------------------------

 SELECT * FROM [BagDrop_SIN_ACTION].[dbo].[CustomerSession] where ID > 9448242 -- inserted 2289 records
 SELECT * FROM [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] where ID > 10463827--inserted 5,150,436 records which is completely wrong
 SELECT * FROM [BagDrop_SIN_ACTION].[dbo].[Bag] where UBI = '8888899999' --inserted 5,150,436 records which is completely wrong


 SELECT * FROM [CUSSBagDropDB_SIN].[dbo].[CustomerSession] where ID = 9844500
 SELECT * FROM [CUSSBagDropDB_SIN].[dbo].[BagWeightUpdate] where CustomerSessionID = 9460545

 SELECT * FROM [BagDrop_SIN_ACTION].[dbo].[BagWeightUpdate] where CustomerSessionID = 9460525