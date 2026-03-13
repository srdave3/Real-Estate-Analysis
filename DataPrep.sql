-- ============================================================
-- STEP 0: Data Prep & Type Casting for realtor_data
-- Run this FIRST before any analytical queries
-- Database: RealEstateDB  |  Table: realtor_data (1,048,575 rows)
-- ============================================================

USE RealEstateDB;
GO

-- ============================================================
-- 0A. INSPECT RAW DATA QUALITY
-- ============================================================

-- Check for nulls and blanks across key columns
SELECT
    COUNT(*)                                                    AS TotalRows,
    SUM(CASE WHEN price        IS NULL OR price        = '' THEN 1 ELSE 0 END) AS NullPrice,
    SUM(CASE WHEN listing_price IS NULL                       THEN 1 ELSE 0 END) AS NullListingPrice,
    SUM(CASE WHEN status       IS NULL OR status       = '' THEN 1 ELSE 0 END) AS NullStatus,
    SUM(CASE WHEN zip_code     IS NULL OR zip_code     = '' THEN 1 ELSE 0 END) AS NullZip,
    SUM(CASE WHEN city         IS NULL OR city         = '' THEN 1 ELSE 0 END) AS NullCity,
    SUM(CASE WHEN house_size   IS NULL OR house_size   = '' THEN 1 ELSE 0 END) AS NullHouseSize,
    SUM(CASE WHEN bed          IS NULL OR bed          = '' THEN 1 ELSE 0 END) AS NullBed,
    SUM(CASE WHEN bath         IS NULL OR bath         = '' THEN 1 ELSE 0 END) AS NullBath,
    SUM(CASE WHEN property_type IS NULL OR property_type = '' THEN 1 ELSE 0 END) AS NullPropertyType,
    SUM(CASE WHEN brokered_by  IS NULL OR brokered_by  = '' THEN 1 ELSE 0 END) AS NullBroker,
    SUM(CASE WHEN financing_type IS NULL OR financing_type = '' THEN 1 ELSE 0 END) AS NullFinancing
FROM dbo.realtor_data;
GO

-- Distinct values for key categorical columns
SELECT DISTINCT status        FROM dbo.realtor_data ORDER BY 1;
SELECT DISTINCT property_type FROM dbo.realtor_data ORDER BY 1;
SELECT DISTINCT financing_type FROM dbo.realtor_data ORDER BY 1;
SELECT DISTINCT buyer_type    FROM dbo.realtor_data ORDER BY 1;
GO

-- Sample rows to visually inspect data
SELECT TOP 20 * FROM dbo.realtor_data ORDER BY NEWID();
GO

-- ============================================================
-- 0B. CREATE CLEANED VIEW: vw_realtor_clean
--     Casts all nvarchar columns to proper types
--     Filters out rows with missing critical fields
--     Used by ALL downstream queries instead of raw table
-- ============================================================
IF OBJECT_ID('dbo.vw_realtor_clean', 'V') IS NOT NULL
    DROP VIEW dbo.vw_realtor_clean;
GO

CREATE VIEW dbo.vw_realtor_clean AS
SELECT
    -- Identifiers
    property_id,
    buyer_id,
    brokered_by,

    -- Geography
    street                                              AS street_address,
    city,
    state,
    LEFT(LTRIM(RTRIM(zip_code)), 5)                    AS zip_code,
    neighborhood,

    -- Property attributes
    property_type,
    property_use,
    TRY_CAST(house_size   AS DECIMAL(10,2))            AS house_size_sqft,
    TRY_CAST(bed          AS TINYINT)                  AS bedrooms,
    TRY_CAST(bath         AS DECIMAL(4,1))             AS bathrooms,
    TRY_CAST(acre_lot     AS DECIMAL(10,4))            AS acre_lot,

    -- Pricing  (price = sale price stored as nvarchar)
    TRY_CAST(price        AS DECIMAL(14,2))            AS sale_price,
    listing_price,                                     -- already decimal(18)

    -- Dates
    TRY_CAST(listing_date   AS DATE)                   AS listing_date,
    TRY_CAST(prev_sold_date AS DATE)                   AS prev_sold_date,

    -- Listing status
    LTRIM(RTRIM(LOWER(status)))                        AS status,

    -- Transaction & agent info
    financing_type,
    buyer_type,
    years_experience,
    specialization_level,
    primary_specialization_pct,

    -- Computed: days on market (listing_date → today if still active)
    CASE
        WHEN TRY_CAST(listing_date AS DATE) IS NOT NULL
        THEN DATEDIFF(DAY,
                TRY_CAST(listing_date AS DATE),
                CASE WHEN LTRIM(RTRIM(LOWER(status))) IN ('sold','s')
                     THEN TRY_CAST(prev_sold_date AS DATE)
                     ELSE CAST(GETDATE() AS DATE)
                END)
        ELSE NULL
    END                                                AS days_on_market,

    -- Computed: sale-to-list ratio
    CASE
        WHEN listing_price > 0
             AND TRY_CAST(price AS DECIMAL(14,2)) IS NOT NULL
        THEN TRY_CAST(price AS DECIMAL(14,2)) / listing_price
        ELSE NULL
    END                                                AS sale_to_list_ratio,

    -- Computed: price per sqft
    CASE
        WHEN TRY_CAST(house_size AS DECIMAL(10,2)) > 0
             AND TRY_CAST(price  AS DECIMAL(14,2)) IS NOT NULL
        THEN TRY_CAST(price AS DECIMAL(14,2))
             / TRY_CAST(house_size AS DECIMAL(10,2))
        ELSE NULL
    END                                                AS price_per_sqft,

    -- Season derived from listing date
    CASE MONTH(TRY_CAST(listing_date AS DATE))
        WHEN 12 THEN 'Winter' WHEN 1 THEN 'Winter' WHEN 2 THEN 'Winter'
        WHEN  3 THEN 'Spring' WHEN 4 THEN 'Spring' WHEN 5 THEN 'Spring'
        WHEN  6 THEN 'Summer' WHEN 7 THEN 'Summer' WHEN 8 THEN 'Summer'
        ELSE 'Fall'
    END                                                AS listing_season

FROM dbo.realtor_data
WHERE
    -- Drop rows missing the most critical fields
    TRY_CAST(price AS DECIMAL(14,2)) IS NOT NULL
    AND TRY_CAST(price AS DECIMAL(14,2)) > 0
    AND zip_code IS NOT NULL AND zip_code <> ''
    AND city     IS NOT NULL AND city     <> '';
GO

-- Confirm clean view row count
SELECT COUNT(*) AS CleanRows FROM dbo.vw_realtor_clean;
GO

PRINT 'Step 0 Complete: vw_realtor_clean created. Use this view for all analytical queries.';
GO