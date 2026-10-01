USE [PALMSDB]
GO

/****** Object:  Table [dbo].[tblRadiationLicenceRRM]    Script Date: 23/11/2015 2:12:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblRadiationLicenceRRM_BK](
	[RadiationLicenceRRMID] [int] IDENTITY(1,1) NOT NULL,
	[RRMStatusID] [smallint] NOT NULL,
	[RRMTypeID] [smallint] NOT NULL,
	[RRMPurposeID] [smallint] NULL,
	[RRMID] [smallint] NULL,
	[WorkArea] [varchar](255) NULL,
	[RRMSecurityClassificationID] [smallint] NULL,
	[LaboratoryClassificationID] [smallint] NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBySystemUserID] [int] NULL,
	[RowTimestamp] [timestamp] NOT NULL,
	[ROW_ID] [nvarchar](15) NULL,
	[OldAssetNumber] [nvarchar](50) NULL,
	[RRMDepartmentID] [smallint] NULL,
 CONSTRAINT [PKXtblRadiationLicenceRRM_BK] PRIMARY KEY CLUSTERED 
(
	[RadiationLicenceRRMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblRadiationLicenceRRM_BK]  WITH CHECK ADD  CONSTRAINT [FKCtblRRMTypetblRadiationLicenceRRM_BK] FOREIGN KEY([RRMTypeID])
REFERENCES [dbo].[tblRRMType] ([RRMTypeID])
GO

ALTER TABLE [dbo].[tblRadiationLicenceRRM_BK] CHECK CONSTRAINT [FKCtblRRMTypetblRadiationLicenceRRM_BK]
GO


