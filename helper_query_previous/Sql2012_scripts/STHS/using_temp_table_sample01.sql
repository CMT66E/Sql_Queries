DECLARE @TotalStudents INT
SELECT @TotalStudents = COUNT(*) from ToBeDeletedTemp WHERE IS_ELS = 0

DECLARE @TotalClasses INT
SELECT @TotalClasses = COUNT(*) from temp_class WHERE IS_ELS = 0

SELECT @TotalStudents 
SELECT @TotalClasses

SELECT @TotalStudents/@TotalClasses as TEMP  


UPDATE ToBeDeletedTemp SET IS_ELS = 1
WHERE STU_ID IN (SELECT TOP 15 STU_ID FROM ToBeDeletedTemp ORDER BY STU_ID ASC)

SELECT class_id FROM temp_class WHERE IS_ELS = 1

DECLARE @NoStuPerClass INT
SET @NoStuPerClass = 27

declare @STU_INFO_TEMP table 
( 
  STU_ID INT,
  GIVEN_NAME varchar(50),
  FAMILY_NAME varchar(50),
  SUBURB varchar(50),
  POSTCODE varchar(10), 
  TRAVEL_ROUTES varchar(50),
  IS_ELS bit,
  ASSIGN_CLASS_ID INT NULL 
)
 
INSERT INTO @STU_INFO_TEMP
SELECT *, null as ASSIGN_CLASS_ID FROM [ToBeDeletedTemp]

SELECT TOP 6 [TRAVEL_ROUTES], 
(case when COUNT(*) <= @NoStuPerClass then COUNT(*) else @NoStuPerClass end) as STU_COUNT, 
(case when @NoStuPerClass - COUNT(*) <=0 then 0 else @NoStuPerClass - COUNT(*) end) as STU_SHORT,
0 as IS_DONE  
FROM @STU_INFO_TEMP
WHERE NOT [TRAVEL_ROUTES] is null  AND ASSIGN_CLASS_ID IS NULL AND IS_ELS = 0
GROUP BY [TRAVEL_ROUTES]
ORDER BY COUNT(*) DESC