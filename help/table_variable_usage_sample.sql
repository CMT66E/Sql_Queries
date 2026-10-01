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
delete from @Table1

GO  -- if you put go here then the whole section above it will be an indenpendent compiling group variable here @Table1 will not be referred below it

