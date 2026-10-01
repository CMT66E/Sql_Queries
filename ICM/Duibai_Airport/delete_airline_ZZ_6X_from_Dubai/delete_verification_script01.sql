/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[Airline]
      ,[ColorR]
      ,[ColorB]
      ,[ColorG]
      ,[AirlineHeading]
      ,[AirlineDescription]
      ,[GridColumnWidth]
  FROM [CussReportingDB_DXB].[dbo].[Airlines]


DELETE FROM dbo.Airlines WHERE Airline = 'ZZ' OR Airline = '6X' 

INSERT INTO dbo.Airlines (ID, Airline, ColorR, ColorB, ColorG, AirlineHeading, AirlineDescription, GridColumnWidth)
VALUES (2, 'ZZ', 0, 0, 255, 'ZZ', 'ZZ', 80)
GO

INSERT INTO dbo.Airlines (ID, Airline, ColorR, ColorB, ColorG, AirlineHeading, AirlineDescription, GridColumnWidth)
VALUES (3, '6X', 0, 0, 255, '6X', '6X', 80)
GO