--If you use CHARINDEX to find something please make sure it is great than 0 not
declare @ABDStationIDs varchar(100) = '4,5,6,7,8'

declare @IndexValue int
set @IndexValue = CHARINDEX(',' + CAST(5 AS varchar(10)) + ',', @ABDStationIDs)

print '@IndexValue =' + cast(@IndexValue as varchar)

--------------------------------------------------------------------------------------------------
		declare @FromDateTime datetime = N'2019/05/01 00:00:00'
		declare @ToDateTime datetime = N'2019/05/30 23:59:59'

set @ABDStationIDs = '382953'
SELECT  BagWeightUpdate.*, AbdStation.*
								FROM BagWeightUpdate
								JOIN AbdStation ON BagWeightUpdate.AbdStationID = AbdStation.ID
								WHERE BagWeightUpdate.LocalTime BETWEEN @FromDateTime AND @ToDateTime
									AND (AbdStation.Terminal LIKE '%' )
									AND (ISNULL(AbdStation.Area,'') LIKE '%' )
									AND (ISNULL(AbdStation.SubArea,'') LIKE '%' )
									AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) >= 0
								)
