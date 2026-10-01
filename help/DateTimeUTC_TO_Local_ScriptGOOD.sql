 

SELECT CONVERT(datetime, 
               SWITCHOFFSET(CONVERT(datetimeoffset, 
                                    '2021-10-14 05:30:51.867'), 
                            DATENAME(TzOffset, SYSDATETIMEOFFSET()))) 
       AS ColumnInLocalTime