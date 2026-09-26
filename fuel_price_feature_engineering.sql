USE forbes2000;
DROP TABLE IF EXISTS fuel_prices;

USE fuel_project;

CREATE TABLE fuel_prices (
    date DATE,
    country VARCHAR(100),
    region VARCHAR(50),
    income_level VARCHAR(20),
    subsidy_level VARCHAR(20),
    petrol_usd_liter DECIMAL(10,4),
    diesel_usd_liter DECIMAL(10,4),
    lpg_usd_liter DECIMAL(10,4),
    brent_crude_usd DECIMAL(10,4),
    tax_percentage DECIMAL(10,4)
);

SHOW TABLES FROM fuel_project;
SHOW TABLES FROM forbes2000;
SET GLOBAL local_infile = 1;
USE fuel_project;

LOAD DATA LOCAL INFILE 'C:/Users/DELL/Downloads/Datasets/global_fuel_prices_2020_2026.csv'
INTO TABLE fuel_prices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM fuel_prices;
SELECT * FROM fuel_prices LIMIT 5;
TRUNCATE TABLE fuel_prices;
LOAD DATA LOCAL INFILE 'C:/Users/DELL/Downloads/Datasets/global_fuel_prices_2020_2026.csv'
INTO TABLE fuel_prices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@date_raw, country, region, income_level, subsidy_level, petrol_usd_liter, diesel_usd_liter, lpg_usd_liter, brent_crude_usd, tax_percentage)
SET date = STR_TO_DATE(@date_raw, '%m/%d/%Y');
SELECT * FROM fuel_prices LIMIT 5;
SELECT country, date, brent_crude_usd,
       LAG(brent_crude_usd, 1) OVER (PARTITION BY country ORDER BY date) AS brent_lag1
FROM fuel_prices
WHERE country = 'Nigeria'
ORDER BY date
LIMIT 10;
SELECT country, date, brent_crude_usd,
       LAG(brent_crude_usd, 1) OVER (PARTITION BY country ORDER BY date) AS brent_lag1,
       LAG(brent_crude_usd, 2) OVER (PARTITION BY country ORDER BY date) AS brent_lag2,
       LAG(brent_crude_usd, 3) OVER (PARTITION BY country ORDER BY date) AS brent_lag3,
       LAG(brent_crude_usd, 4) OVER (PARTITION BY country ORDER BY date) AS brent_lag4
FROM fuel_prices
WHERE country = 'Nigeria'
ORDER BY date
LIMIT 10;
SELECT country, date, petrol_usd_liter,
       LAG(petrol_usd_liter, 1) OVER (PARTITION BY country ORDER BY date) AS petrol_lag1
FROM fuel_prices
WHERE country = 'Nigeria'
ORDER BY date
LIMIT 10;
SELECT country, date, brent_crude_usd,
       brent_crude_usd - LAG(brent_crude_usd, 1) OVER (PARTITION BY country ORDER BY date) AS brent_wow_change
FROM fuel_prices
WHERE country = 'Nigeria'
ORDER BY date
LIMIT 10;
DROP TABLE IF EXISTS fuel_features;

CREATE TABLE fuel_features AS
SELECT
    country,
    region,
    income_level,
    subsidy_level,
    date,
    petrol_usd_liter,
    diesel_usd_liter,
    brent_crude_usd,
    tax_percentage,
    LAG(brent_crude_usd, 1) OVER (PARTITION BY country ORDER BY date) AS brent_lag1,
    LAG(brent_crude_usd, 2) OVER (PARTITION BY country ORDER BY date) AS brent_lag2,
    LAG(brent_crude_usd, 3) OVER (PARTITION BY country ORDER BY date) AS brent_lag3,
    LAG(brent_crude_usd, 4) OVER (PARTITION BY country ORDER BY date) AS brent_lag4,
    LAG(petrol_usd_liter, 1) OVER (PARTITION BY country ORDER BY date) AS petrol_lag1,
    brent_crude_usd - LAG(brent_crude_usd, 1) OVER (PARTITION BY country ORDER BY date) AS brent_wow_change
FROM fuel_prices;
SELECT COUNT(*) FROM fuel_features;
DELETE FROM fuel_features WHERE brent_lag4 IS NULL;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM fuel_features WHERE brent_lag4 IS NULL;
SELECT COUNT(*) FROM fuel_features;
SELECT * FROM fuel_features;
   SELECT * FROM fuel_features;