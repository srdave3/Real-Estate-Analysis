
SELECT
    specialization_level,
    COUNT(*)                                            AS TxCount,
    FORMAT(AVG(sale_price),          'C0')             AS AvgSalePrice,
    FORMAT(AVG(sale_to_list_ratio),  'P2')             AS AvgSaleToList,
    FORMAT(AVG(CAST(days_on_market AS FLOAT)), 'N1')  AS AvgDOM,
    FORMAT(AVG(CAST(years_experience AS FLOAT)), 'N1') AS AvgYearsExp,
    FORMAT(AVG(primary_specialization_pct), 'P1')     AS AvgSpecPct
FROM dbo.vw_realtor_clean
WHERE specialization_level IS NOT NULL
GROUP BY specialization_level
ORDER BY AVG(sale_price) DESC;
GO