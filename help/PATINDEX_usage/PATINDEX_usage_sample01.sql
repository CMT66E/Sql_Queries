SELECT PATINDEX('%onthe%', 'TechOnTheNet.com');
--Result: 5        (search is not case-sensitive so it will match on 'OnThe')

SELECT PATINDEX('%T_e%', 'TechOnTheNet.com');
--Result: 7

SELECT PATINDEX('%e%com', 'TechOnTheNet.com');
--Result: 2

SELECT PATINDEX('%[aeiou]%', 'TechOnTheNet.com');
--Result: 2        (matches on the first a, e, i, o, or u character found)

SELECT PATINDEX('%z%', 'TechOnTheNet.com');
--Result: 0