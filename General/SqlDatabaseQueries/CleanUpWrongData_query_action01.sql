DELETE FROM ApplicationSessionUsage
WHERE      DATEDIFF(day, [date], getdate()) < 60 and (CussApplicationID NOT IN
                             (SELECT        CussApplicationID
                               FROM            CussApplications))