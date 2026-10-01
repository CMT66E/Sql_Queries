IF OBJECT_ID('tempdb..##TempABDs') is not null
	DROP TABLE [dbo].[##TempABDs]

 
SELECT        AbdStation.ID AS AbdStationID, 
              ISNULL(MAX(AbdStateHistory.ID), 0) AS LastProcessedID 
INTO ##TempABDs 
FROM            AbdStateHistory RIGHT OUTER JOIN
                         AbdStation ON AbdStateHistory.AbdStationID = AbdStation.ID
WHERE        (AbdStation.AbdType = 'ABD') OR
                         (AbdStation.AbdType = 'KSK') OR
                         (AbdStation.AbdType = 'K')
GROUP BY AbdStation.ID 

select * from [##TempABDs]  