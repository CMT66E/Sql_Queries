/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[UBI]
      ,[BagTagType]
  FROM [CUSSBagDropDB_SIN].[dbo].[Bag]
  order by ID desc

SELECT TOP (1000) *
  FROM [BagDrop_SIN_ACTION].[dbo].[Bag]
  order by ID desc

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[BaggageGroupID]
      ,[UBI]
      ,[BagTagType]
  FROM [BagDrop_SIN_ACTION].[dbo].[Bag] where BaggageGroupID = 6481392

  select * from [BagDrop_SIN_ACTION].[dbo].[BaggageGroup] where ID = 6481392 