
SELECT
    financing_type,
    COUNT(*)                                            AS Count,
    FORMAT(AVG(CAST(days_on_market AS FLOAT)), 'N1')  AS AvgDOM,
    FORMAT(AVG(sale_price), 'C0')                     AS AvgSalePrice,
    FORMAT(AVG(sale_to_list_ratio), 'P2')             AS AvgSaleToList
FROM dbo.vw_realtor_clean
WHERE financing_type IS NOT NULL
  AND days_on_market BETWEEN 0 AND 730
GROUP BY financing_type
ORDER BY AvgDOM;
GO
 
 