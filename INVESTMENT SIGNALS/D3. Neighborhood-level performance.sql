SELECT
    neighborhood,
    city,
    state,
    COUNT(*)                                               AS Listings,
    FORMAT(AVG(sale_price),          'C0')                AS AvgSalePrice,
    FORMAT(AVG(price_per_sqft),      'C2')               AS AvgPricePerSqFt,
    FORMAT(AVG(sale_to_list_ratio),  'P2')               AS AvgSaleToList,
    FORMAT(AVG(CAST(days_on_market AS FLOAT)), 'N1')     AS AvgDOM
FROM dbo.vw_realtor_clean
WHERE neighborhood IS NOT NULL AND neighborhood <> ''
GROUP BY neighborhood, city, state
HAVING COUNT(*) >= 10
ORDER BY AVG(sale_price) DESC;
GO