
DECLARE @NewRadiationLicenceRRMID INT
DECLARE @CurrentRadiationLicenceRRMID INT
SELECT @NewRadiationLicenceRRMID = NewRadiationLicenceRRMID, @CurrentRadiationLicenceRRMID = RadiationLicenceRRMID from tblRadiationLicenceRRMComponent where VariationPendingFlag = 1

--current radiation licence analysis
--1) we check the relocate RRM type is Sealed source device
declare @CountSealedRRMcomContainer int
select @CountSealedRRMcomContainer=count(C.RRMComponentTypeID) from tblRadiationLicenceRRMComponent A 
	INNER JOIN tblRRMComponent B ON A.RRMComponentID = B.RRMComponentID
	INNER JOIN tblRRMComponentType C ON B.RRMComponentTypeID = C.RRMComponentTypeID 
	INNER JOIN tblRRMType D ON C.RRMTypeID = D.RRMTypeID
where 
A.RadiationLicenceRRMID = @CurrentRadiationLicenceRRMID
and
VariationPendingFlag = 1
and 
D.RRMTypeID = 2
and 
C.RRMComponentTypeID = 4
 

--new radiation licence analysis
--1) we check the target licence ComponentType count when RRM Type = ‘Sealed Source Device’ 
--   If it already have one with Container type then it will not accept another from relocate process
declare @CountSealedRRMcomContainerTarget int
select @CountSealedRRMcomContainerTarget=count(C.RRMComponentTypeID) from tblRadiationLicenceRRMComponent A 
	INNER JOIN tblRRMComponent B ON A.RRMComponentID = B.RRMComponentID
	INNER JOIN tblRRMComponentType C ON B.RRMComponentTypeID = C.RRMComponentTypeID 
	INNER JOIN tblRRMType D ON C.RRMTypeID = D.RRMTypeID
where 
A.RadiationLicenceRRMID = @NewRadiationLicenceRRMID 
and 
D.RRMTypeID = 2
and 
C.RRMComponentTypeID = 4

 
