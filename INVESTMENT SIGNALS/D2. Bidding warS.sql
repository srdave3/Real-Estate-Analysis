 
SELECT
    zip_code,
    city,
    state,
    property_type,
    street_address,
    FORMAT(listing_price, 'C0')                            AS ListPrice,
    FORMAT(sale_price,    'C0')                            AS SalePrice,
    FORMAT(sale_price - listing_price, 'C0')              AS PremiumPaid,
    FORMAT(sale_to_list_ratio - 1, 'P2')                  AS PremiumPct,
    financing_type,
    days_on_market
FROM dbo.vw_realtor_clean
WHERE sale_to_list_ratio > 1.03
  AND sale_price IS NOT NULL
ORDER BY sale_to_list_ratio DESC;
GO