--A4. Price distribution buckets (bonus — great for histograms)
SELECT
    CASE
        WHEN sale_price <  100000  THEN 'Under $100K'
        WHEN sale_price <  250000  THEN '$100K–$250K'
        WHEN sale_price <  500000  THEN '$250K–$500K'
        WHEN sale_price <  750000  THEN '$500K–$750K'
        WHEN sale_price < 1000000  THEN '$750K–$1M'
        ELSE 'Over $1M'
    END                                                AS PriceBucket,
    property_type,
    COUNT(*)                                           AS Count,
    FORMAT(AVG(sale_price), 'C0')                     AS AvgPrice,
    FORMAT(AVG(days_on_market), 'N0')                 AS AvgDaysOnMarket
FROM dbo.vw_realtor_clean
WHERE sale_price IS NOT NULL
GROUP BY
    CASE
        WHEN sale_price <  100000  THEN 'Under $100K'
        WHEN sale_price <  250000  THEN '$100K–$250K'
        WHEN sale_price <  500000  THEN '$250K–$500K'
        WHEN sale_price <  750000  THEN '$500K–$750K'
        WHEN sale_price < 1000000  THEN '$750K–$1M'
        ELSE 'Over $1M'
    END,
    property_type
ORDER BY MIN(sale_price), property_type;
GO