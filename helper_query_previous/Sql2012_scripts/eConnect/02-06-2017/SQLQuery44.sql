SELECT TOP 1000 [OnlineRADLicenceRenewalID]
      ,[LicenceNumber]
      ,[RenewalNumber]
      ,[ApplicationStatusID]
      ,[LicenseeEmailAddress]
      ,[LicencetoUseDurationID]
      ,[RenewalXML]
      ,[RenewalFee]
      ,[PaymentTypeID]
      ,[CreditCardPaymentDate]
      ,[CreditCardPaymentReceiptNo]
      ,[CreditCardPaymentConfirmedFlag]
      ,[DateCreated]
      ,[CreatedBySystemUserID]
      ,[DateUpdated]
      ,[UpdatedBySystemUserID]
      ,[RowTimestamp]
      ,[CreditCardPaymentSuccessfulFlag]
      ,[LicenceDataXML]
      ,[DocumentUploadedFlag]
  FROM [PALMSDB].[dbo].[tblOnlineRADLicenceRenewal]
where [OnlineRADLicenceRenewalID] in 
(
370, 358, 287, 277, 244, 220, 283, 284, 285
)


--15-05-2017