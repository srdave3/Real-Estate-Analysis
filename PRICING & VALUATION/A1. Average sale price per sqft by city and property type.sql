-- A1. Average sale price per sqft by city and property type (FIXED)
SELECT
    city,
    property_type,
    COUNT(*)                                            AS TotalRecords,
    FORMAT(AVG(sale_price),      'C0')                 AS AvgSalePrice,
    FORMAT(AVG(price_per_sqft),  'C2')                 AS AvgPricePerSqFt,
    FORMAT(MIN(price_per_sqft),  'C2')                 AS MinPricePerSqFt,
    FORMAT(MAX(price_per_sqft),  'C2')                 AS MaxPricePerSqFt
FROM dbo.vw_realtor_clean
WHERE price_per_sqft IS NOT NULL
  AND price_per_sqft BETWEEN 10 AND 5000
GROUP BY city, property_type
HAVING COUNT(*) >= 5
ORDER BY city, AVG(price_per_sqft) DESC;  -- ← use the raw expression, not the alias
GO
