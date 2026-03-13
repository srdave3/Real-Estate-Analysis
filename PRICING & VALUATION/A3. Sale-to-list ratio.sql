-- A3. Sale-to-list ratio: how much over/under asking price
SELECT
    property_type,
    city,
    COUNT(*)                                            AS SaleCount,
    FORMAT(AVG(sale_price),         'C0')              AS AvgSalePrice,
    FORMAT(AVG(listing_price),      'C0')              AS AvgListPrice,
    FORMAT(AVG(sale_to_list_ratio), 'P2')              AS AvgSaleToList,
    SUM(CASE WHEN sale_price > listing_price THEN 1 ELSE 0 END) AS SoldAboveAsk,
    FORMAT(
        CAST(SUM(CASE WHEN sale_price > listing_price THEN 1 ELSE 0 END) AS FLOAT)
        / NULLIF(COUNT(*), 0), 'P1')                   AS PctAboveAsk
FROM dbo.vw_realtor_clean
WHERE sale_to_list_ratio IS NOT NULL
  AND sale_to_list_ratio BETWEEN 0.5 AND 2.0
GROUP BY property_type, city
HAVING COUNT(*) >= 5
ORDER BY AvgSaleToList DESC;
GO