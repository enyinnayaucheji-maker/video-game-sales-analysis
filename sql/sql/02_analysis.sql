/* =====================================================
   02_analysis.sql
   Business analysis queries
   Generates insights for dashboard & reporting
===================================================== */

-- Global totals
SELECT
  SUM(NA_Sales) AS total_na,
  SUM(EU_Sales) AS total_eu,
  SUM(JP_Sales) AS total_jp,
  SUM(total_sales) AS total_global
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`;


-- Sales by genre
SELECT 
  genre,
  SUM(total_sales) AS genre_sales
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
GROUP BY genre
ORDER BY genre_sales DESC;


-- Sales by platform
SELECT 
  platform,
  SUM(total_sales) AS platform_sales
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
GROUP BY platform
ORDER BY platform_sales DESC;


-- Regional sales by genre
SELECT
  genre,
  SUM(NA_Sales) AS na,
  SUM(EU_Sales) AS eu,
  SUM(JP_Sales) AS jp
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
GROUP BY genre
ORDER BY na DESC;


-- Yearly sales trend
SELECT
  Year,
  SUM(total_sales) AS yearly_sales
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
WHERE Year IS NOT NULL
GROUP BY Year
ORDER BY Year DESC;


-- Top selling games
SELECT
  Name,
  Platform,
  total_sales
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
ORDER BY total_sales DESC
LIMIT 10;


-- Top publishers
SELECT
  publisher,
  SUM(total_sales) AS publisher_sales
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
GROUP BY publisher
ORDER BY publisher_sales DESC;


-- Average sales per game by genre
SELECT
  genre,
  AVG(total_sales) AS avg_sales_per_game
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
GROUP BY genre
ORDER BY avg_sales_per_game DESC;


-- Platform performance over time
SELECT
  Year,
  Platform,
  SUM(total_sales) AS sales
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`
WHERE Year IS NOT NULL
GROUP BY Year, Platform
ORDER BY Year, sales DESC;


-- Market share by region (%)
SELECT
  ROUND(SUM(NA_Sales) * 100.0 / SUM(total_sales), 2) AS na_percent,
  ROUND(SUM(EU_Sales) * 100.0 / SUM(total_sales), 2) AS eu_percent,
  ROUND(SUM(JP_Sales) * 100.0 / SUM(total_sales), 2) AS jp_percent
FROM `alien-device-410108.vgsales.vgsales_clean_no_duplicates`;
