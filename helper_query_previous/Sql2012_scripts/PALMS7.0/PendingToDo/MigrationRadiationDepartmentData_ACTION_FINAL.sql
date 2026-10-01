USE [PALMSDB]
GO

/****** Object:  Table [dbo].[tblRadiationDepartment]    Script Date: 23/11/2015 11:14:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblRadiationDepartment](
	[RadiationDepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[RadiationLocationID] [int] NOT NULL,
	[DepartmentName] [varchar](255) NOT NULL,
	[EffectiveDateFrom] [smalldatetime] NOT NULL,
	[EffectiveDateTo] [smalldatetime] NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[CreatedBySystemUserID] [int] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[UpdatedBySystemUserID] [int] NULL,
	[RowTimestamp] [timestamp] NOT NULL,
	[RowID] [int] NULL,
 CONSTRAINT [PKXtblRadiationDepartment] PRIMARY KEY CLUSTERED 
(
	[RadiationDepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--here we check the table: tblRadiationDepartment if there are some records then we update its RowID to be the same as its RadiationDepartmentID value
--this is used to handle the existing data records in table: tblRadiationDepartment
if exists(select * from tblRadiationDepartment)
begin
   update tblRadiationDepartment set RowID = RadiationDepartmentID
end 

--we start to insert all records from database: PALMSMigrationDB table DM_tblRadiationDepartment into table: tblRadiationDepartment
insert into tblRadiationDepartment
(
	[RadiationLocationID],
	[DepartmentName],
	[EffectiveDateFrom],
	[EffectiveDateTo],
	[DateCreated],
	[CreatedBySystemUserID],
	[DateUpdated],
	[UpdatedBySystemUserID],	 
	[RowID] 
)
select 
		[RadiationLocationID]
		,[DepartmentName]
		,getdate() as [EffectiveDateFrom]
		,null as [EffectiveDateTo]
		,getdate() as [DateCreated]
		,1 as [CreatedBySystemUserID]
		,null as [DateUpdated]
		,null as [UpdatedBySystemUserID]       
		,cast(RadiationDepartmentID as int) as [RowID]
from OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSMigrationDB].[dbo].[DM_tblRadiationDepartment]

--here we start to update all those records in table:tblRadiationLicenceRRM 
update a set a.RRMDepartmentID = c.RadiationDepartmentID
FROM [dbo].[tblRadiationLicenceRRM] a 
INNER JOIN OPENDATASOURCE('SQLOLEDB', 'DRIVER={SQL Server};SERVER=GOULBDB32;UID=PALMSDB_RW;PWD=rw2palmsdB').[PALMSMigrationDB].[dbo].[DM_tblRadiationLicenceRRM] b
on a.RadiationLicenceRRMID = b.RadiationLicenceRRMID
INNER JOIN [dbo].[tblRadiationDepartment] c on b.RadiationDepartmentID = c.RowID
WHERE c.RadiationLocationID in (select RadiationLocationID from tblRadiationLocation)

--we need update the following SPs:
--[uspRadiationLocationGetReferenceData]
--[uspRadiationGetLocationByID]
--[uspRadiationUnlinkedRRMGet]
--[uspRadiationLicenceReportData]
--[uspRadiationGetRRMByInstrumentIDForReport]

