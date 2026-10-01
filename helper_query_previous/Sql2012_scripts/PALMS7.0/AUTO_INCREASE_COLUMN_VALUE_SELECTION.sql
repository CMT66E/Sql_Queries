Declare @TemptblAddress Table
(
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[Address] [varchar](100) NULL,
	[Suburb] [varchar](50) NOT NULL,
	[Postcode] [varchar](10) NULL,
	[StateCode] [varchar](20) NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBySystemUserID] [int] NULL,
	[RowTimestamp] [timestamp] NOT NULL,
	[OverseasAddressFlag] [bit] NOT NULL,
	[Country] [varchar](100) NULL,
	[PrefixAddress] [varchar](100) NULL,
	[ROW_ID] [nvarchar](15) NULL
)

--we called these lines at the top
--delete from dbo.dm_tblAddress
--where [Suburb] is null

INSERT INTO @TemptblAddress (
	   -- [AddressID] THIS IS Auto-Identity
	   [ROW_ID] -- instead stick the source table's ID in Row_ID.
      ,[Address]
      ,[Suburb]
      ,[Postcode]
      ,[StateCode]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[OverseasAddressFlag]
      ,[Country]
      ,[PrefixAddress]
)
SELECT 
	   (ROW_NUMBER() OVER( ORDER BY ROW_ID ) + @TempNewAddressID) as [AddressID] -- store this in ROW_ID
      ,[Address]
      ,[Suburb]
      ,[Postcode]
      ,[StateCode]
	  , getdate() AS DateCreated -- missing from source.
      ,1 as [CreatedBySystemUserID]
      ,GETDATE() as [DateUpdated]
      ,1 as [UpdatedBySystemUserID]
      ,(case Country when null then 0 when '' then 0 else 1 end) as [OverseasAddressFlag]
      ,[Country]
      ,'' as [PrefixAddress]
  FROM dbo.dm_tblAddress
  order by addressID