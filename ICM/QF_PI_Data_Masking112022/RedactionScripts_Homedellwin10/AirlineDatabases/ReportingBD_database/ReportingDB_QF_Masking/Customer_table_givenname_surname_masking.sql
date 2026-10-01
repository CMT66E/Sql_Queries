USE [ReportingDB_QF]
GO 

--It takes 00:05:11 on total: 8,025,161 records which is fatser than I thought definitely
--used 9 '#########' to make differences from those ones from application level's masking
update [Customer] set GivenName = (case when len(isnull(GivenName, '')) > 1 then substring(GivenName, 1, 1) + '#########' else GivenName end),
                      Surname = (case when len(isnull(Surname, '')) > 1 then substring(Surname, 1, 1) + '#######' else Surname end)

