
SELECT *
FROM (
    SELECT state, property_type, sale_price
    FROM dbo.vw_realtor_clean
    WHERE sale_price IS NOT NULL
) AS src
PIVOT (
    AVG(sale_price)
    FOR property_type IN ([Residential],[Condo],[Commercial],[Multi-Family],[Land])
) AS pvt
ORDER BY state;
GO