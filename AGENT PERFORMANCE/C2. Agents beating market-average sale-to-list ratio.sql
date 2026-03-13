
WITH MarketAvg AS (
    SELECT AVG(sale_to_list_ratio) AS MktRatio
    FROM dbo.vw_realtor_clean
    WHERE sale_to_list_ratio BETWEEN 0.5 AND 2.0
),
AgentRatios AS (
    SELECT
        brokered_by,
        COUNT(*)                        AS SaleCount,
        AVG(sale_to_list_ratio)         AS AgentRatio
    FROM dbo.vw_realtor_clean
    WHERE sale_to_list_ratio BETWEEN 0.5 AND 2.0
      AND brokered_by IS NOT NULL
    GROUP BY brokered_by
    HAVING COUNT(*) >= 5
)
SELECT
    ar.brokered_by                                     AS AgentBroker,
    ar.SaleCount,
    FORMAT(ar.AgentRatio,  'P2')                       AS AgentSaleToList,
    FORMAT(ma.MktRatio,    'P2')                       AS MarketSaleToList,
    FORMAT(ar.AgentRatio - ma.MktRatio, 'P2')         AS VsMarket
FROM AgentRatios ar
CROSS JOIN MarketAvg ma
WHERE ar.AgentRatio > ma.MktRatio
ORDER BY ar.AgentRatio DESC;
GO