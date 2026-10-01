USE [CUSSBagDropDB]
GO

/****** Object:  Table [dbo].[TransactionRecordData]    Script Date: 8/13/2021 4:10:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransactionRecordData](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AbdstationID] [int] NULL,
	[Reportedtime] [datetime] NULL,
	[TransactionDescription] [nvarchar](200) NULL
) ON [PRIMARY]
GO


