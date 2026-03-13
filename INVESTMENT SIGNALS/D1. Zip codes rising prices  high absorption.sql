WITH ZipStats AS (
    SELECT
        zip_code,
        city,
        state,
        COUNT(*)                                AS TotalListings,
        AVG(sale_price)                         AS AvgSalePrice,
        AVG(price_per_sqft)                     AS AvgPricePerSqFt,
        AVG(CAST(days_on_market AS FLOAT))      AS AvgDOM,
        AVG(sale_to_list_ratio)                 AS AvgSaleToList,
        CAST(SUM(CASE WHEN status IN ('sold','s') THEN 1 ELSE 0 END) AS FLOAT)
            / NULLIF(COUNT(*), 0)               AS SoldRate
    FROM dbo.vw_realtor_clean
    WHERE sale_price IS NOT NULL
    GROUP BY zip_code, city, state
    HAVING COUNT(*) >= 20
),
Ranked AS (
    SELECT *,
        PERCENT_RANK() OVER (ORDER BY SoldRate DESC)        AS SoldRatePctRank,
        PERCENT_RANK() OVER (ORDER BY AvgSaleToList DESC)   AS SaleToListPctRank,
        PERCENT_RANK() OVER (ORDER BY AvgDOM ASC)           AS DOMPctRank
    FROM ZipStats
)
SELECT TOP 20
    zip_code,
    city,
    state,
    TotalListings,
    FORMAT(AvgSalePrice,    'C0')                           AS AvgSalePrice,
    FORMAT(AvgPricePerSqFt, 'C2')                          AS AvgPricePerSqFt,
    FORMAT(AvgDOM,          'N1')                           AS AvgDaysOnMarket,
    FORMAT(AvgSaleToList,   'P2')                          AS AvgSaleToList,
    FORMAT(SoldRate,        'P1')                           AS SoldRate,
    -- Composite investment signal score (0–100)
    FORMAT(
        (SoldRatePctRank    * 0.40
       + SaleToListPctRank  * 0.35
       + DOMPctRank         * 0.25) * 100, 'N1')           AS InvestmentScore
FROM Ranked
ORDER BY
    (SoldRatePctRank * 0.40 + SaleToListPctRank * 0.35 + DOMPctRank * 0.25) DESC;
GO