
[dbo].[uspOnlineDGDLCheckRenewalRequirement] 5030593 
---------------------------------------------------------------------------------
	select OnlineRADLicenceRenewalID as Id,
	       LicenceNumber as LicenceNo,
           RenewalNumber as RenewalNo,
           cast(RenewalXML as varchar(max)) as RenewalXML,
           cast(RenewalFee as decimal) as RenewalFee,
           PaymentTypeID as PaymentTypeId ,
		   LicencetoUseDurationID as LicenceDurationId,
           LicenseeEmailAddress as EmailAddress,
           CreditCardPaymentReceiptNo,
           ApplicationStatusID as ApplicationStatusId
	from  tblOnlineRADLicenceRenewal 
	where LicenceNumber=5056022 and RenewalNumber=54890 

--GRANT EXECUTE ON [dbo].[uspOnlineDGDLCheckRenewalRequirement] TO ReadWriteOnlineRole
---------------------------------------------------------------------------------
select top 10 * from tblOnlineRADContactUpdateApplication
WHERE LicenceNumber = 5068022
order by DateCreated desc

--delete from tblOnlineRADContactUpdateApplication where OnlineRADContactUpdateApplicationID = 31
---------------------------------------------------------------------------------
SELECT  ApplicationStatusID, *
FROM   tblOnlineRADLicenceRenewal 
WHERE  LicenceNumber=5056022 and RenewalNumber=54890  


--delete from tblOnlineRADLicenceRenewal 
--where OnlineRADLicenceRenewalID = 208
---------------------------------------------------------------------------------
SELECT  ApplicationStatusID, *
FROM   tblOnlineRADLicenceRenewal 
    WHERE  LicenceNumber=5030593 and RenewalNumber=55317  


delete from tblOnlineRADLicenceRenewal 
where OnlineRADLicenceRenewalID = 113

select * from tblClassification where ClassificationDomainID = 87