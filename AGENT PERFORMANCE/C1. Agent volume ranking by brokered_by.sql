
WITH AgentStats AS (
    SELECT
        brokered_by,
        years_experience,
        specialization_level,
        COUNT(*)                        AS TxCount,
        SUM(sale_price)                 AS TotalVolume,
        AVG(sale_price)                 AS AvgSalePrice,
        AVG(sale_to_list_ratio)         AS AvgSaleToList,
        AVG(CAST(days_on_market AS FLOAT)) AS AvgDOM
    FROM dbo.vw_realtor_clean
    WHERE brokered_by IS NOT NULL
    GROUP BY brokered_by, years_experience, specialization_level
    HAVING COUNT(*) >= 3
)
SELECT
    brokered_by                                        AS AgentBroker,
    years_experience,
    specialization_level,
    TxCount,
    FORMAT(TotalVolume,    'C0')                       AS TotalVolume,
    FORMAT(AvgSalePrice,   'C0')                       AS AvgSalePrice,
    FORMAT(AvgSaleToList,  'P2')                       AS AvgSaleToList,
    FORMAT(AvgDOM,         'N1')                       AS AvgDaysToClose,
    RANK() OVER (ORDER BY TotalVolume DESC)            AS VolumeRank,
    RANK() OVER (ORDER BY TxCount DESC)                AS TxRank,
    RANK() OVER (ORDER BY AvgDOM ASC)                  AS SpeedRank
FROM AgentStats
ORDER BY TotalVolume DESC;
GO