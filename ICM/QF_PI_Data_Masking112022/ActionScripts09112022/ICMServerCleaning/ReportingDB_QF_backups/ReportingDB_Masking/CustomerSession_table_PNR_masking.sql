USE [ReportingDB]
GO 

--Total 10,767,438 records in test environment, it takes 00:09:12 minutes
update [CustomerSession] set PNR = (case when len(isnull(PNR, '')) > 1 then substring(PNR, 1, 1) + '#####' else PNR end) 

