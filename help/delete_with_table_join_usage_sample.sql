-- Create table1
DECLARE @Table1 TABLE
(
Col1 INT, 
Col2 INT, 
Col3 VARCHAR(100)
)

INSERT INTO @Table1 (Col1, Col2, Col3)
SELECT 1, 11, 'First'
UNION ALL
SELECT 11, 12, 'Second'
UNION ALL
SELECT 21, 13, 'Third'
UNION ALL
SELECT 31, 14, 'Fourth'

select * from @Table1
 


-- Create table2
DECLARE @Table2 TABLE
(
Col1 INT, 
Col2 INT, 
Col3 VARCHAR(100)
)

INSERT INTO @Table2 (Col1, Col2, Col3)
SELECT 1, 21, 'Two-One'
UNION ALL
SELECT 11, 22, 'Two-Two'
UNION ALL
SELECT 21, 23, 'Two-Three'
UNION ALL
SELECT 31, 24, 'Two-Four'

select * from @Table2


-- Delete data from Table1
DELETE @Table1
FROM @Table1 t1
INNER JOIN @Table2 t2 ON t1.Col1 = t2.Col1
WHERE t2.Col3 IN ('Two-Three','Two-Four')


select * from @Table1
GO  -- if you put go here then the whole section above it will be an indenpendent compiling group variable here @Table1 will not be referred below it