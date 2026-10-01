select (CASE WHEN ISNULL(Terminal,'') <> '' AND ISNULL(Area,'') <> '' AND ISNULL(AbdType,'') <> ''
		THEN (CASE when CHARINDEX('T', Terminal) = 0 then 'T'+ Terminal else Terminal end) + '_' + Area + '_' + AbdType + '_' + Identifier
	  WHEN ISNULL(Terminal,'') <> '' AND ISNULL(Area,'') <> '' AND ISNULL(SubArea,'') = ''
		THEN (CASE when CHARINDEX('T', Terminal) = 0 then 'T'+ Terminal else Terminal end) + '_' + Area + '_' + Identifier
	  WHEN ISNULL(Terminal,'') ='' AND  ISNULL(Area,'') <> ''
		THEN Area + '_' + Identifier
	  ELSE Identifier 
END) as AbdName, * from AbdStation