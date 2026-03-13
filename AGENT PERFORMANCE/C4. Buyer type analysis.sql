
SELECT
    buyer_type,
    COUNT(*)                                            AS Purchases,
    FORMAT(AVG(sale_price),         'C0')              AS AvgSalePrice,
    FORMAT(AVG(sale_to_list_ratio), 'P2')              AS AvgSaleToList,
    FORMAT(AVG(CAST(days_on_market AS FLOAT)), 'N1')  AS AvgDOM,
    -- Top financing type per buyer type
    (SELECT TOP 1 financing_type
     FROM dbo.vw_realtor_clean r2
     WHERE r2.buyer_type = r.buyer_type
       AND r2.financing_type IS NOT NULL
     GROUP BY financing_type
     ORDER BY COUNT(*) DESC)                           AS TopFinancingType
FROM dbo.vw_realtor_clean r
WHERE buyer_type IS NOT NULL
GROUP BY buyer_type
ORDER BY Purchases DESC;
GO