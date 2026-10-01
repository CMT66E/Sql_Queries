		declare @FromDateTime datetime = N'2016-01-01 00:00:00'
		declare @ToDateTime datetime = N'2019-12-31 23:59:59'
		declare @Antenna nvarchar(50) = N'%' 
		declare @Terminal nvarchar(10) = N'%'
		declare @Area nvarchar(10) = N'%'
		declare @SubArea nvarchar(10) = N'%'
		declare @ABDStationIDs nvarchar(400) = N'0'
		declare @ABDStationNames nvarchar(4000) = N'%'

DROP TABLE IF EXISTS #Temp

Select * Into #Temp from QBagTagWriteLog Where QBagTagWriteLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime

select 
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
QBagTagWriteLog.QBagTagWriteStepID,
QBagTagWriteStep.Heading, 
isnull(QBagTagWriteStep.Description,'') as Description, 
COUNT(QBagTagWriteLog.LocalLogTime) AS QBagTagWrites
from #Temp    QBagTagWriteLog 
     INNER JOIN AbdStation ON QBagTagWriteLog.AbdStationID = AbdStation.ID
     LEFT OUTER JOIN QBagTagWriteAntenna ON QBagTagWriteLog.ID = QBagTagWriteAntenna.QBagTagWriteLogID 
	 LEFT OUTER JOIN RfidAntennaType ON QBagTagWriteAntenna.RfidAntennaTypeID = RfidAntennaType.ID
	 INNER JOIN QBagTagWriteStep on QBagTagWriteLog.QBagTagWriteStepID = QBagTagWriteStep.ID AND QBagTagWriteLog.WasWriteSuccessful = 1	 
WHERE     (QBagTagWriteLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime)
		  AND (isnull(RfidAntennaType.ShortName, '') LIKE @Antenna)
		  AND (AbdStation.Terminal LIKE @Terminal )
		  AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		  AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		  AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea, QBagTagWriteLog.QBagTagWriteStepID,  
	QBagTagWriteStep.Heading, QBagTagWriteStep.Description
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), QBagTagWriteStep.Heading

SELECT 
dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea) AS AbdStationName,
QBagTagWriteLog.QBagTagWriteStepID,
QBagTagWriteStep.Heading, 
QBagTagWriteStep.Description, 
COUNT(QBagTagWriteLog.LocalLogTime) AS QBagTagWrites
FROM     #Temp    QBagTagWriteLog 
	INNER JOIN AbdStation ON QBagTagWriteLog.AbdStationID = AbdStation.ID
	LEFT OUTER JOIN QBagTagWriteAntenna ON QBagTagWriteLog.ID = QBagTagWriteAntenna.QBagTagWriteLogID 
	INNER JOIN RfidAntennaType ON QBagTagWriteAntenna.RfidAntennaTypeID = RfidAntennaType.ID 
	INNER JOIN QBagTagWriteStep on QBagTagWriteLog.QBagTagWriteStepID = QBagTagWriteStep.ID AND QBagTagWriteLog.WasWriteSuccessful = 1	  
WHERE     (QBagTagWriteLog.LocalLogTime BETWEEN @FromDateTime AND @ToDateTime)
		  AND (isnull(RfidAntennaType.ShortName, '') LIKE @Antenna)
		  AND (AbdStation.Terminal LIKE @Terminal )
		  AND (ISNULL(AbdStation.Area,'') LIKE @Area )
		  AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
		  AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
GROUP BY AbdStation.Identifier, AbdStation.Terminal, AbdStation.Area,AbdStation.SubArea, QBagTagWriteLog.QBagTagWriteStepID,  
	QBagTagWriteStep.Heading, QBagTagWriteStep.Description
ORDER BY dbo.GetAbdName(AbdStation.Identifier, AbdStation.Terminal,AbdStation.Area,AbdStation.SubArea), QBagTagWriteStep.Heading

 
