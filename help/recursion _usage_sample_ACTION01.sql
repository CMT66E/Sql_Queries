DECLARE
    @startDate DATETIME,
    @endDate DATETIME
 
SET @startDate = '11/10/2011'
SET @endDate = '03/25/2012'
 
; WITH CTE AS (
    SELECT
        YEAR(@startDate) AS 'yr',
        MONTH(@startDate) AS 'mm',
        DATENAME(mm, @startDate) AS 'mon',
        DATEPART(d,@startDate) AS 'dd',
        @startDate 'new_date'
    UNION ALL
    SELECT
        YEAR(new_date) AS 'yr',
        MONTH(new_date) AS 'mm',
        DATENAME(mm, new_date) AS 'mon',
        DATEPART(d,@startDate) AS 'dd',
        DATEADD(d,1,new_date) 'new_date'
    FROM CTE
    WHERE new_date < @endDate
    )
SELECT yr AS 'Year', mon AS 'Month', count(dd) AS 'Days'
FROM CTE
GROUP BY mon, yr, mm
ORDER BY yr, mm
OPTION (MAXRECURSION 1000)