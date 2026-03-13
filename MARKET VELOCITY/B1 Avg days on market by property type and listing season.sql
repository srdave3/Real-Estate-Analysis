-- B1. Avg days on market by property type and listing season
SELECT
    property_type,
    listing_season,
    COUNT(*)                                            AS ListingCount,
    FORMAT(AVG(CAST(days_on_market AS FLOAT)), 'N1')  AS AvgDaysOnMarket,
    FORMAT(MIN(days_on_market), 'N0')                 AS MinDays,
    FORMAT(MAX(days_on_market), 'N0')                 AS MaxDays,
    FORMAT(STDEV(days_on_market), 'N1')               AS StdDevDays
FROM dbo.vw_realtor_clean
WHERE days_on_market IS NOT NULL
  AND days_on_market BETWEEN 0 AND 730   -- cap at 2 years
GROUP BY property_type, listing_season
ORDER BY property_type, AvgDaysOnMarket;
GO