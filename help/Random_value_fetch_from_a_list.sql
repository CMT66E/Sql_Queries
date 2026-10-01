
DECLARE @Values TABLE (Value INT);

INSERT INTO @Values
VALUES
(27),(16),(31),(6),(11),(19),(4),
(14),(23),(18),(9),(24),(26),(13),(15),
(3),(25),(30),(22),(20),(7),(12),(5),
(2),(21),(29),(17),(8),(10),(28),(1);

SELECT TOP 1 Value FROM @Values ORDER BY NEWID();
