select * from vwprofile
where email = 'james@gmail.com'

 select CourseConductedBy, 
 substring(CourseConductedBy, 0, charindex(' ', CourseConductedBy) + 1) as FirstName,
 substring(CourseConductedBy, charindex(' ', CourseConductedBy) + 1, (len(CourseConductedBy) - charindex(' ', CourseConductedBy))+ 1) as LastName,
 * from tblDGLicenceCourseConductedBy

 update tblDGLicenceCourseConductedBy
 set 
  GivenName = substring(CourseConductedBy, 0, charindex(' ', CourseConductedBy) + 1),
  Surname = substring(CourseConductedBy, charindex(' ', CourseConductedBy) + 1, (len(CourseConductedBy) - charindex(' ', CourseConductedBy))+ 1)
 where DGLicenceCourseConductedByID = 1
  
 select (case when exists(select * from vwprofile where UserName = 'miwuit@optusnet.com.au') then 1 else 0 end) as IsLinkedExternalUser   