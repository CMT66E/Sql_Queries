		declare @InstrumentID int = 10060

		declare @IsTransporterLicence int
		select @IsTransporterLicence = [dbo].[ufn_IsTransporterPOEOLicence] (@InstrumentID) 
print '@@IsTransporterLicence=' + cast(@IsTransporterLicence as varchar)

		declare @IsTransferLicence int
		select @IsTransferLicence = [dbo].[ufn_IsTransferPOEOLicence] (@InstrumentID) 
print '@IsTransferLicence=' + cast(@IsTransferLicence as varchar)

		declare @IsTransferLicenceLatest int
        select @IsTransferLicenceLatest = [dbo].[ufn_IsTransferPOEOLicenceLatest] (@InstrumentID) 
print '@IsTransferLicenceLatest=' + cast(@IsTransferLicenceLatest as varchar)

		declare @IsVariationLicence int
		select @IsVariationLicence = [dbo].[ufn_IsVariationPOEOLicence] (@InstrumentID) 
print '@@IsVariationLicence=' + cast(@IsVariationLicence as varchar)

 
 select top 10 * from tblNotice a inner join tblInstrumentNotice b on a.InstrumentID = b.NoticeInstrumentID 
 where b.InstrumentID = 10060
 order by a.DateCreated desc
 

 select * from tblNoticeTemplate where NoticeTemplateID in (379, 389) --379:transfer 389: variation