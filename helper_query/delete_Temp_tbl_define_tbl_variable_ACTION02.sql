declare @FromDateTime DateTime = '2018/02/01 00:00:00'
declare @ToDateTime DateTime = '2018/09/30 23:59:59'
declare @PassportType char(1) = '%'
declare @Terminal nvarchar(10) = '%'
declare @Area nvarchar(10) = '%'
declare @SubArea nvarchar(10) = '%'
declare @ABDStationIDs varchar(400) = '0'
declare @ABDStationNames varchar(4000) = '%';

            DROP TABLE IF EXISTS #Temp
			DROP TABLE IF EXISTS #TempFinal

			SELECT *
			INTO #Temp
				FROM PassportInfo
				WHERE     PassportInfo.LocalCreationTime BETWEEN @FromDateTime AND @ToDateTime
					AND (@PassportType = '%' OR CAST(PassportInfo.IsRFIDPhoto AS char(1)) = @PassportType)
		

			UPDATE #Temp
			SET  Issuer ='NZL'
			Where Nationality IN('N2L','USA','GBR','AUS','D') 
			OR 	Issuer IN('N2L','USA','GBR','AUS','D','U5A','AU5');


			DECLARE  @TempTable TABLE
			(
			  RowNumber bigint,
			  Issuer varchar(100),
			  SucessfulScanRate decimal,
			  NumberOfPassportScans int,
			  NumberOfPassportSuccessfulScans int,
			  ABDStations varchar(100)
			)

			DECLARE  @BiometricAcceptanceRateByCountrySpecial TABLE
			(
			  Issuer varchar(100),
			  NumberOfPassportScans int,
			  NumberOfPassportSuccessfulScans int,
			  ABDStations varchar(100),
			  RowNumber int 
			)
		    
			INSERT INTO @BiometricAcceptanceRateByCountrySpecial
			SELECT #Temp.Issuer, COUNT(#Temp.ID) AS NumberOfPassportScans,
				COUNT(SuccessfulScans.ID) AS NumberOfPassportSuccessfulScans, @ABDStationNames AS ABDStations,
				ROW_NUMBER() OVER (ORDER BY COUNT(#Temp.ID) DESC) AS RowNumber
			FROM #Temp
			LEFT JOIN PassportInfo AS SuccessfulScans 
			ON SuccessfulScans.ID = #Temp.ID AND SuccessfulScans.IsVerifiedSucessfully = 1
			JOIN AbdStation ON #Temp.AbdStationID = AbdStation.ID
			WHERE     (AbdStation.Terminal LIKE @Terminal )
				AND (ISNULL(AbdStation.Area,'') LIKE @Area )
				AND (ISNULL(AbdStation.SubArea,'') LIKE @SubArea )
				AND (@ABDStationIDs = '0' OR CHARINDEX(',' + CAST(ABDStation.ID AS varchar(10)) + ',', @ABDStationIDs) > 0)
			GROUP BY #Temp.Issuer
	
		 
		 
		    INSERT INTO @TempTable(
				  RowNumber,
				  Issuer,
				  SucessfulScanRate,
				  NumberOfPassportScans,
				  NumberOfPassportSuccessfulScans,
				  ABDStations				
			)

			SELECT RowNumber,'NZ_AU_US_GBR_D' As Issuer, ROUND(CONVERT(float,NumberOfPassportSuccessfulScans) * 100.0 / CONVERT(float,NumberOfPassportScans),2) AS SucessfulScanRate, 
				NumberOfPassportScans, NumberOfPassportSuccessfulScans, ABDStations
			FROM @BiometricAcceptanceRateByCountrySpecial
			WHERE RowNumber <= 1

			UNION

			SELECT 2,'Others', ROUND(CONVERT(float,SUM(NumberOfPassportSuccessfulScans)) * 100.0 / CONVERT(float,SUM(NumberOfPassportScans)),2), 
				SUM(NumberOfPassportScans), SUM(NumberOfPassportSuccessfulScans), ABDStations
			FROM @BiometricAcceptanceRateByCountrySpecial
			WHERE RowNumber > 1
			GROUP BY ABDStations

			select RowNumber, Issuer ,SucessfulScanRate, NumberOfPassportScans, NumberOfPassportSuccessfulScans, ABDStations
			into #TempFinal		   
			from @TempTable

			select * from #TempFinal

	 