DECLARE @FromDate DATETIME
DECLARE @ToDate DATETIME

if @FromDate <> ''
   SET @FromDate =  DATEADD(MONTH, 1, @FromDate)  --add one more month from current @FromDate value

if @ToDate <> ''
   SET @ToDate =  DATEADD(MONTH, 1, @ToDate)      --add one more month from current @ToDate value