DECLARE @FromTime DATETIME
SET @FromTime = (Select Cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),112) + ' 00:00:00.000' as datetime))

DECLARE @ToTime DATETIME
SET @ToTime =(Select cast(convert (char(8),DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),112)+ ' 23:59:59.997' as datetime))

EXEC [dbo].[AvailabilityStatesAFReport ] @FromTime,@ToTime 