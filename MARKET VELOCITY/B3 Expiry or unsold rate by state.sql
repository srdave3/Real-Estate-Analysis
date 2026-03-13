
SELECT
    state,
    COUNT(*)                                            AS TotalListings,
    SUM(CASE WHEN status IN ('sold','s')         THEN 1 ELSE 0 END) AS SoldCount,
    SUM(CASE WHEN status IN ('for_sale','active') THEN 1 ELSE 0 END) AS ActiveCount,
    SUM(CASE WHEN status NOT IN ('sold','s','for_sale','active') THEN 1 ELSE 0 END) AS OtherCount,
    FORMAT(
        CAST(SUM(CASE WHEN status IN ('sold','s') THEN 1 ELSE 0 END) AS FLOAT)
        / NULLIF(COUNT(*),0), 'P1')                    AS SoldRate
FROM dbo.vw_realtor_clean
GROUP BY state
HAVING COUNT(*) >= 50
ORDER BY SoldRate DESC;
GO