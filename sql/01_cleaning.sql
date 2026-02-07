/* =====================================================
   01_cleaning.sql
   Data preparation & transformation
   Creates clean, analysis-ready tables
   code: Maurice
===================================================== */

-- Preview raw data
SELECT *
FROM `alien-device-410108.vgsales.vgsales_raw`
LIMIT 1000;


-- Create cleaned base table (trim text + fix types + remove incomplete rows)
CREATE OR REPLACE TABLE `alien-device-410108.vgsales.vgsales_clean` AS 
SELECT 
  TRIM(Name) AS name,
  TRIM(Platform) AS platform,
  TRIM(Genre) AS genre,
  TRIM(Publisher) AS publisher,
  SAFE_CAST(Year AS INT64) AS Year,
  NA_Sales,
  EU_Sales,
  JP_Sales,
  Other_Sales,
  Global_Sales
FROM `alien-device-410108.vgsales.vgsales_raw`
WHERE Name IS NOT NULL
  AND Platform IS NOT NULL
  AND Genre IS NOT NULL;


-- Replace NULL sales with 0
UPDATE `alien-device-410108.vgsales.vgsales_clean`
SET
  NA_Sales = COALESCE(NA_Sales, 0),
  EU_Sales = COALESCE(EU_Sales, 0),
  JP_Sales = COALESCE(JP_Sales, 0),
  Other_Sales = COALESCE(Other_Sales, 0),
  Global_Sales = COALESCE(Global_Sales, 0)
WHERE 
  NA_Sales IS NULL
  OR EU_Sales IS NULL
  OR JP_Sales IS NULL
  OR Other_Sales IS NULL
  OR Global_Sales IS NULL;


-- Validate null removal
SELECT *
FROM `alien-device-410108.vgsales.vgsales_clean`
WHERE NA_Sales IS NULL;


-- Remove duplicates
CREATE OR REPLACE TABLE `alien-device-410108.vgsales.vgsales_clean_no_duplicates` AS
SELECT DISTINCT *
FROM `alien-device-410108.vgsales.vgsales_clean`;


-- Add calculated total sales column
ALTER TABLE `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
ADD COLUMN total_sales FLOAT64;


UPDATE `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
SET total_sales =
    NA_Sales + EU_Sales + JP_Sales + Other_Sales
WHERE total_sales IS NULL;
