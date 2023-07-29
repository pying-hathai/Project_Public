select *
from car_price

-- Rename car_name as model
select *
from car_price

ALTER TABLE car_price
ADD model nvarchar(255)

UPDATE car_price
SET model = car_name

ALTER TABLE car_price
DROP COLUMN car_name

-- Create a column manufacturer by breaking out model
SELECT
	SUBSTRING(model, 1, CHARINDEX(' ', model)-1) as manufacturer
FROM car_price

ALTER TABLE car_price
ADD manufacturer nvarchar(255)

UPDATE car_price
SET manufacturer = SUBSTRING(model, 1, CHARINDEX(' ', model)-1)

SELECT *
FROM car_price

-- Split kms from kms_driven and convert to numeric
SELECT 
	SUBSTRING(kms_driven, 1, CHARINDEX(' ', kms_driven)-1)
from car_price

UPDATE car_price
SET kms_driven = SUBSTRING(kms_driven, 1, CHARINDEX(' ', kms_driven)-1)

--select 
--	cast(kms_driven as int)
--from car_price

-- Split cc from engine and convert to numeric
select 
	SUBSTRING(engine, 1, CHARINDEX(' ',engine)-1)
from car_price

UPDATE car_price
SET engine = SUBSTRING(engine, 1, CHARINDEX(' ',engine)-1)

SELECT
	cast(engine as int)
FROM car_price

-- Split Seats from Seats column
SELECT
	SUBSTRING(Seats, 1, CHARINDEX(' ',Seats)-1)
FROM car_price

UPDATE car_price
SET Seats = SUBSTRING(Seats, 1, CHARINDEX(' ',Seats)-1)

SELECT 
	Seats
FROM car_price

-- Count manufacturer 
SELECT
	manufacturer,
	COUNT(manufacturer)
FROM car_price
GROUP BY manufacturer
ORDER BY COUNT(manufacturer) DESC

-- Split Lakh from car_prices_in_rupee
SELECT
	car_prices_in_rupee
FROM car_price

SELECT 
	SUBSTRING(car_prices_in_rupee, 1, CHARINDEX(' ', car_prices_in_rupee)-1) AS prices,
	SUBSTRING(car_prices_in_rupee, CHARINDEX(' ', car_prices_in_rupee)+1, LEN(car_prices_in_rupee)) AS unit
FROM car_price

ALTER TABLE car_price
ADD price float,
	unit nvarchar(255)

UPDATE car_price
SET price = SUBSTRING(car_prices_in_rupee, 1, CHARINDEX(' ', car_prices_in_rupee)-1)

UPDATE car_price
SET unit = SUBSTRING(car_prices_in_rupee, CHARINDEX(' ', car_prices_in_rupee)+1, LEN(car_prices_in_rupee))

-- Convert Lakh to 10000 and Crore to 1000 and Multiply

WITH unitprice AS (
	SELECT
		SUBSTRING(car_prices_in_rupee, CHARINDEX(' ', car_prices_in_rupee)+1, LEN(car_prices_in_rupee)) AS unit
	FROM car_price
)
SELECT 
	unit,
	COUNT(unit)
FROM unitprice
GROUP BY unit

SELECT
	CASE
		WHEN unit = 'Lakh' THEN 10000
		WHEN unit = 'Crore' THEN 1000
		ELSE unit
	END AS multiply
FROM car_price

ALTER TABLE car_price
ADD multiply int

UPDATE car_price
SET multiply = 
	CASE
		WHEN unit = 'Lakh' THEN 10000
		WHEN unit = 'Crore' THEN 1000
		ELSE 0
	END

--
UPDATE car_price
SET price = 0
WHERE price is null

UPDATE car_price
SET unit = 0
WHERE unit is null

-- price to actual number
SELECT
	price * multiply AS price_act
FROM car_price

ALTER TABLE car_price
ADD price_act float 

UPDATE car_price
SET price_act = price * multiply


--
select *
from car_price






