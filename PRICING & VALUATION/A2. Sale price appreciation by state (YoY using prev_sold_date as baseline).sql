-- A2. Sale price appreciation by state (FIXED)
WITH YearlyPrices AS (
    SELECT
        state,
        YEAR(prev_sold_date)            AS SaleYear,
        AVG(sale_price)                 AS AvgPrice,
        COUNT(*)                        AS SaleCount
    FROM dbo.vw_realtor_clean
    WHERE prev_sold_date IS NOT NULL
      AND sale_price IS NOT NULL
    GROUP BY state, YEAR(prev_sold_date)
),
WithPrior AS (
    SELECT
        state,
        SaleYear,
        AvgPrice,
        SaleCount,
        LAG(AvgPrice) OVER (PARTITION BY state ORDER BY SaleYear) AS PriorYearPrice
    FROM YearlyPrices
)
SELECT
    state,
    SaleYear,
    SaleCount,
    FORMAT(AvgPrice,       'C0')                        AS AvgSalePrice,
    FORMAT(PriorYearPrice, 'C0')                        AS PriorYearPrice,
    FORMAT((AvgPrice - PriorYearPrice)
           / NULLIF(PriorYearPrice, 0), 'P2')           AS YoY_Change
FROM WithPrior
WHERE PriorYearPrice IS NOT NULL
ORDER BY (AvgPrice - PriorYearPrice) / NULLIF(PriorYearPrice, 0) DESC;  -- ← raw expression
GO
