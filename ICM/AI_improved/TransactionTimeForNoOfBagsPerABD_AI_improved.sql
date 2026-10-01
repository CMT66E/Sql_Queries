
ALTER PROCEDURE [dbo].[TransactionTimeForNoOfBagsPerABD]
(
      @FromDateTime      DATETIME
    , @ToDateTime        DATETIME
    , @FlightNumber      NVARCHAR(100)
    , @BoardPass         NVARCHAR(25)
    , @Airline           NVARCHAR(25)
    , @Terminal          NVARCHAR(10)
    , @Area              NVARCHAR(10)
    , @SubArea           NVARCHAR(10)
    , @ABDStationIDs     VARCHAR(400)
    , @ABDStationNames   VARCHAR(4000)
)
AS
BEGIN

    SET NOCOUNT ON;

    DROP TABLE IF EXISTS #tempCusSession;
    DROP TABLE IF EXISTS #temp;

    ------------------------------------------------------------
    -- Pre-filter CustomerSession
    ------------------------------------------------------------
    SELECT
          ID
        , CustomerID
        , AbdStationID
        , CustomerLookupType
        , PNR
        , UtcCreationTime
        , FlightID
        , TimeSlot5minID
        , TimeSlot10minID
        , TimeSlotHourlyID
        , DayOfTheWeekID
        , LocalTime
        , UtcCompletionTime
        , SessionDuration
    INTO #tempCusSession
    FROM CustomerSession
    WHERE LocalTime >= @FromDateTime
      AND LocalTime <= @ToDateTime;

    ------------------------------------------------------------
    -- Calculate Bag Count per Session
    ------------------------------------------------------------
    SELECT
          CS.ID
        , CS.CustomerID
        , CS.AbdStationID
        , CS.CustomerLookupType
        , CS.PNR
        , CS.UtcCreationTime
        , CS.FlightID
        , CS.TimeSlot5minID
        , CS.TimeSlot10minID
        , CS.TimeSlotHourlyID
        , CS.DayOfTheWeekID
        , CS.LocalTime
        , CS.UtcCompletionTime
        , CS.SessionDuration
        , COUNT(BWU.BagID) AS BagCount
    INTO #temp
    FROM #tempCusSession CS
    LEFT JOIN BagWeightUpdate BWU
        ON BWU.CustomerSessionID = CS.ID
    GROUP BY
          CS.ID
        , CS.CustomerID
        , CS.AbdStationID
        , CS.CustomerLookupType
        , CS.PNR
        , CS.UtcCreationTime
        , CS.FlightID
        , CS.TimeSlot5minID
        , CS.TimeSlot10minID
        , CS.TimeSlotHourlyID
        , CS.DayOfTheWeekID
        , CS.LocalTime
        , CS.UtcCompletionTime
        , CS.SessionDuration;

    ------------------------------------------------------------
    -- Main Aggregation
    ------------------------------------------------------------
    ;WITH BaseData AS
    (
        SELECT
              A.AbdStationName
            , NBM.NoOfBagsGroupID
            , T.ID
            , T.BagCount
            , T.SessionDuration
        FROM #temp T

        INNER JOIN AbdStation S
            ON T.AbdStationID = S.ID

        INNER JOIN Flight F
            ON T.FlightID = F.ID

        INNER JOIN NumberOfBagsMap NBM
            ON T.BagCount = NBM.NumberOfBags

        CROSS APPLY
        (
            SELECT dbo.GetAbdName
            (
                S.Identifier,
                S.Terminal,
                S.Area,
                S.SubArea 
            ) AS AbdStationName
        ) A

        WHERE
            CAST(F.FlightNumber AS NVARCHAR(100)) LIKE @FlightNumber
            AND T.CustomerLookupType LIKE @BoardPass
            AND F.MarketingCarrier LIKE @Airline
            AND S.Terminal LIKE @Terminal
            AND ISNULL(S.Area,'') LIKE @Area
            AND ISNULL(S.SubArea,'') LIKE @SubArea
            AND
            (
                 @ABDStationIDs = '0'
                 OR EXISTS
                 (
                    SELECT 1
                    FROM STRING_SPLIT(@ABDStationIDs, ',') X
                    WHERE TRY_CAST(X.value AS INT) = S.ID
                 )
            )
    )
    SELECT
          AbdStationName
        , NoOfBagsGroupID
        , AVG(CAST(BagCount AS FLOAT)) AS AvgBagCount
        , AVG(SessionDuration)         AS AvgSessionDuration
        , MIN(SessionDuration)         AS MinSessionDuration
        , MAX(SessionDuration)         AS MaxSessionDuration
        , COUNT(*)                     AS NumberOfCustomerTransactions
        , SUM(BagCount)                AS NumberOfBags
    FROM BaseData
    GROUP BY
          AbdStationName
        , NoOfBagsGroupID
    ORDER BY
          AbdStationName
        , NoOfBagsGroupID;

END
GO
