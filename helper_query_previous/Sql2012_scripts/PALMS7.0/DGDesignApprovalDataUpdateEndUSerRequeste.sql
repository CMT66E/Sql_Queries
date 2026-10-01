-------------------------------------------------------------------------------------------------------------------------------
select 
a.*, 
a.TankerTypeID,
b.[description] as TankerType,
a.DesignApprovalTypeID,
c.[description] as DesignApprovalType,
case a.DesignApprovalTypeID when 993 then 992 when 996 then 995 else 0 end  as NewDesignApprovalTypeID
from tblDGDesignApproval a 
	inner join tblClassification b on a.TankerTypeID = b.ClassificationID 
	inner join tblClassification c on a.DesignApprovalTypeID = c.ClassificationID 
where datepart(day, a.DateCreated) = 22 and datepart(month, a.DateCreated) = 10 and datepart(year, a.DateCreated) = 2015
and a.TankerTypeID = 893 and (a.DesignApprovalTypeID <> 993 and a.DesignApprovalTypeID <> 996)

--TankerTypeID from 893: B double B trailer TO 892: Semi trailer
--Design Approval ID: 993: Specific approval – B double TO 992: Specific approval – single trailer
--Design Approval ID: 996: General approval – B double TO 995: General approval – single trailer
-------------------------------------------------------------------------------------------------------------------------------
Update a
set 
 a.TankerTypeID = 892,
 a.DesignApprovalTypeID = case a.DesignApprovalTypeID when 993 then 992 when 996 then 995 end
from tblDGDesignApproval a 
	inner join tblClassification b on a.TankerTypeID = b.ClassificationID 
	inner join tblClassification c on a.DesignApprovalTypeID = c.ClassificationID 
where datepart(day, a.DateCreated) = 22 and datepart(month, a.DateCreated) = 10 and datepart(year, a.DateCreated) = 2015
and a.TankerTypeID = 893
--TankerTypeID from 893: B double B trailer TO 892: Semi trailer
--Design Approval ID: 993: Specific approval – B double TO 992: Specific approval – single trailer
--Design Approval ID: 996: General approval – B double TO 995: General approval – single trailer
-------------------------------------------------------------------------------------------------------------------------------

select * from tblClassification where ClassificationID in (893, 892, 995)

select * from tblClassification where ClassificationDomainID in (107, 114)