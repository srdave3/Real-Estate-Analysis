-- B2. Fastest-moving markets: zip codes with lowest avg DOM
SELECT TOP 20
    zip_code,
    city,
    state,
    COUNT(*)                                            AS ListingCount,
    FORMAT(AVG(CAST(days_on_market AS FLOAT)), 'N1')  AS AvgDaysOnMarket,
    FORMAT(AVG(sale_price), 'C0')                     AS AvgSalePrice,
    FORMAT(AVG(sale_to_list_ratio), 'P2')             AS AvgSaleToList
FROM dbo.vw_realtor_clean
WHERE days_on_market BETWEEN 0 AND 365
  AND sale_price IS NOT NULL
GROUP BY zip_code, city, state
HAVING COUNT(*) >= 10
ORDER BY AVG(CAST(days_on_market AS FLOAT)) ASC;
GO