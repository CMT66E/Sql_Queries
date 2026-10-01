declare @LicenseReviewFrom varchar(50)
declare @LicenseReviewTo varchar(50)

set @LicenseReviewTo = '01/07/2013'

Select pl.InstrumentID, inst.DateIssued
From 
	tblRadiationLicence pl inner join tblInstrument inst on pl.InstrumentID = inst.InstrumentID 
Where
(
	@LicenseReviewFrom IS NULL Or
	Convert(varchar(10), CONVERT(date, @LicenseReviewFrom, 103), 103) = dbo.ufn_PRGetRLIssuedDate(pl.InstrumentID)
)
and
(
	@LicenseReviewTo IS NULL OR						 
	Convert(varchar(10), CONVERT(date, @LicenseReviewTo, 103), 103) = dbo.ufn_PRGetRLIssuedDate(pl.InstrumentID)
)

select Convert(varchar(10), CONVERT(date, getdate(), 103), 103) as temp

PRINT CONVERT(datetime,'07-10-2012',110)        -- Jul 10 2012 12:00AM
PRINT CONVERT(datetime,'2012/07/10',111)        -- Jul 10 2012 12:00AM
PRINT CONVERT(datetime,'20120710',  112)        -- Jul 10 2012 12:00AM  

PRINT CONVERT(date,'07-10-2012',110)        -- Jul 10 2012 12:00AM
PRINT CONVERT(date,'2012/07/10',111)        -- Jul 10 2012 12:00AM
PRINT CONVERT(date,'20120710',  112)        -- Jul 10 2012 12:00AM  