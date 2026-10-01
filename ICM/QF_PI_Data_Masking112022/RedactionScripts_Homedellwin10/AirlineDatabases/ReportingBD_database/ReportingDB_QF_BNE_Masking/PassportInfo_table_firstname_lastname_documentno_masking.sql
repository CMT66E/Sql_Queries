USE [ReportingDB_QF_BNE]
GO 

--It takes 00:00:05 on total: 2105 records 
--used 9 '#########' to make differences from those ones from application level's masking
update PassportInfo set DocumentNumber = (case when len(isnull(DocumentNumber, '')) > 1 then substring(DocumentNumber, 1, 1) + '#########' else DocumentNumber end),
                      FirstName = (case when len(isnull(FirstName, '')) > 1 then substring(FirstName, 1, 1) + '#########' else FirstName end),
                      LastName = (case when len(isnull(LastName, '')) > 1 then substring(LastName, 1, 1) + '#######' else LastName end)
