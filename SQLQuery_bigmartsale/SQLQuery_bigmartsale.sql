SELECT *
FROM bigmartsales

-- Item_Identifier
SELECT 
	Item_Identifier
FROM bigmartsales
WHERE Item_Identifier is null

SELECT
	COUNT(DISTINCT(Item_Identifier))
FROM bigmartsales

SELECT
	Item_Identifier,
	COUNT(Item_Identifier)
FROM bigmartsales
GROUP BY Item_Identifier
ORDER BY COUNT(Item_Identifier) DESC

-- No null value
-- 1559 unique IDs
-- The ID start with 3 character and 2 number

-- Item_Fat_Content
SELECT
	Item_Fat_Content,
	COUNT(Item_Fat_Content) AS Item_Fat_Content_Count,
	(CAST(COUNT(Item_Fat_Content) AS FLOAT) *100) / (SELECT COUNT(Item_Fat_Content) FROM bigmartsales) AS percent_Item_Fat
FROM bigmartsales
GROUP BY Item_Fat_Content
ORDER BY Item_Fat_Content_Count DESC

-- Low Fat has the most product content = 61%
-- Low Fat and LF might be the same. Regular and reg might be the same.

-- Item_Type
SELECT 
	Item_Type,
	COUNT(Item_Type) AS Item_Type_Count,
	ROUND((CAST(COUNT(Item_Type) AS FLOAT) *100 ) / (SELECT COUNT(Item_Type) FROM bigmartsales),2) AS Item_Type_Percent
FROM bigmartsales
GROUP BY Item_Type
ORDER BY Item_Type_Count DESC

SELECT
	DISTINCT(Item_Type)
FROM bigmartsales

-- There are 16 types unique
-- Fruits and Vegetables is the most type = 14.46%
-- Seafood is lowest type

-- Outlet_Identifier
SELECT
	Outlet_Identifier,
	COUNT(Outlet_Identifier) AS Outlet_Identifier_count,
	ROUND((CAST(COUNT(Outlet_Identifier) AS FLOAT) * 100) / (SELECT COUNT(Outlet_Identifier) FROM bigmartsales),4) AS Outlet_Identifier_percent
FROM bigmartsales
GROUP BY Outlet_Identifier
ORDER BY Outlet_Identifier_percent DESC

-- 10 Outlets
-- 8 Outlets have around 11% but 2 Outlets have around 6%

-- Outlet_Size
SELECT
	Outlet_Size,
	COUNT(Outlet_Size) AS Outlet_Size_count,
	ROUND(CAST(COUNT(Outlet_Size) AS FLOAT) * 100 / (SELECT COUNT(Outlet_Size) FROM bigmartsales),2) AS Outlet_Size_percent
FROM bigmartsales
GROUP BY Outlet_Size
ORDER BY Outlet_Size_count DESC

SELECT
	Outlet_Size
FROM bigmartsales
WHERE Outlet_Size is null

UPDATE bigmartsales
SET Outlet_Size = 'none'
WHERE Outlet_Size is null

-- 3 Outlets size
-- Medium is the most size 32%
-- Hogh is the lowest size 10%

-- Outlet_Location_Type
SELECT
	Outlet_Location_Type,
	COUNT(Outlet_Location_Type) AS Outlet_Location_count,
	ROUND(CAST(COUNT(Outlet_Location_Type) AS FLOAT) * 100 / (SELECT COUNT(Outlet_Location_Type) FROM bigmartsales),2) AS Outlet_Location_percent
FROM bigmartsales
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_count DESC

SELECT
	Outlet_Location_Type
FROM bigmartsales
WHERE Outlet_Location_Type is null

UPDATE bigmartsales
SET Outlet_Location_Type = 'none'
WHERE Outlet_Location_Type is null

UPDATE bigmartsales
SET Outlet_Location_Type = 'none'
WHERE Outlet_Location_Type = '  --'
	OR Outlet_Location_Type = '?'
	OR Outlet_Location_Type = 'na'

UPDATE bigmartsales
SET Outlet_Location_Type = 'none'
WHERE Outlet_Location_Type = '  -'
	OR Outlet_Location_Type = 'N/A'
	OR Outlet_Location_Type = 'NAN'

-- 3 location types
-- highest location type is Tier 2
-- Lowest location type is Tier 3

-- Outlet_Type
SELECT 
	Outlet_Type,
	COUNT(Outlet_Type) AS Outlet_Type_count,
	ROUND((CAST(COUNT(Outlet_Type) AS FLOAT) * 100 ) / (SELECT COUNT(Outlet_Type) FROM bigmartsales),2) AS Outlet_Type_percent
FROM bigmartsales
GROUP BY Outlet_Type
ORDER BY Outlet_Type_count DESC

-- 4 Outlet type
-- Supermarket Type1 is the most
-- Supermarket Type2 is the lowest

-- Statistics
DROP TABLE if exists stat
CREATE TABLE stat
(
	name_stat varchar(255),
	count_stat FLOAT,
	mean_stat FLOAT,
	std_stat FLOAT,
	min_stat FLOAT,
	stat_25 FLOAT,
	stat_75 FLOAT,
	max_stat FLOAT
)

		
INSERT INTO stat (name_stat) VALUES ('Item_Weight');
INSERT INTO stat (name_stat) VALUES ('Item_Visibility');
INSERT INTO stat (name_stat) VALUES ('Item_MRP');
INSERT INTO stat (name_stat) VALUES ('Outlet_Establishment_Year');
INSERT INTO stat (name_stat) VALUES ('Item_Outlet_Sales');

UPDATE stat
SET count_stat =
				CASE
						WHEN name_stat = 'Item_Weight'		THEN (SELECT COUNT(Item_Weight) FROM bigmartsales)
						WHEN name_stat = 'Item_Visibility'	THEN (SELECT COUNT(Item_Visibility) FROM bigmartsales)
						WHEN name_stat = 'Item_MRP'			THEN (SELECT COUNT(Item_MRP) FROM bigmartsales)
						WHEN name_stat = 'Outlet_Establishment_Year'	THEN (SELECT COUNT(Outlet_Establishment_Year) FROM bigmartsales)
						WHEN name_stat = 'Item_Outlet_Sales'			THEN (SELECT COUNT(Item_Outlet_Sales) FROM bigmartsales)
						ELSE 'none'
				END
				
UPDATE stat
SET mean_stat =
				CASE
						WHEN name_stat = 'Item_Weight'		THEN ROUND((SELECT AVG(Item_Weight) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Visibility'	THEN ROUND((SELECT AVG(Item_Visibility) FROM bigmartsales),2)
						WHEN name_stat = 'Item_MRP'			THEN ROUND((SELECT AVG(Item_MRP) FROM bigmartsales),2)
						WHEN name_stat = 'Outlet_Establishment_Year'	THEN ROUND((SELECT AVG(Outlet_Establishment_Year) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Outlet_Sales'			THEN ROUND((SELECT AVG(Item_Outlet_Sales) FROM bigmartsales),2)
						ELSE 'none'
				END
				
UPDATE stat
SET std_stat =
				CASE
						WHEN name_stat = 'Item_Weight'		THEN ROUND((SELECT stdev(Item_Weight) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Visibility'	THEN ROUND((SELECT stdev(Item_Visibility) FROM bigmartsales),2)
						WHEN name_stat = 'Item_MRP'			THEN ROUND((SELECT stdev(Item_MRP) FROM bigmartsales),2)
						WHEN name_stat = 'Outlet_Establishment_Year'	THEN ROUND((SELECT stdev(Outlet_Establishment_Year) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Outlet_Sales'			THEN ROUND((SELECT stdev(Item_Outlet_Sales) FROM bigmartsales),2)
						ELSE 'none'
				END
				

UPDATE stat
SET min_stat =
				CASE
						WHEN name_stat = 'Item_Weight'		THEN ROUND((SELECT min(Item_Weight) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Visibility'	THEN ROUND((SELECT min(Item_Visibility) FROM bigmartsales),2)
						WHEN name_stat = 'Item_MRP'			THEN ROUND((SELECT min(Item_MRP) FROM bigmartsales),2)
						WHEN name_stat = 'Outlet_Establishment_Year'	THEN ROUND((SELECT min(Outlet_Establishment_Year) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Outlet_Sales'			THEN ROUND((SELECT min(Item_Outlet_Sales) FROM bigmartsales),2)
						ELSE 'none'
				END
				
UPDATE stat
SET min_stat =
				CASE
						WHEN name_stat = 'Item_Weight'		THEN ROUND((SELECT min(Item_Weight) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Visibility'	THEN ROUND((SELECT min(Item_Visibility) FROM bigmartsales),2)
						WHEN name_stat = 'Item_MRP'			THEN ROUND((SELECT min(Item_MRP) FROM bigmartsales),2)
						WHEN name_stat = 'Outlet_Establishment_Year'	THEN ROUND((SELECT min(Outlet_Establishment_Year) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Outlet_Sales'			THEN ROUND((SELECT min(Item_Outlet_Sales) FROM bigmartsales),2)
						ELSE 'none'
				END
				

UPDATE stat
SET max_stat =
				CASE
						WHEN name_stat = 'Item_Weight'		THEN ROUND((SELECT max(Item_Weight) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Visibility'	THEN ROUND((SELECT max(Item_Visibility) FROM bigmartsales),2)
						WHEN name_stat = 'Item_MRP'			THEN ROUND((SELECT max(Item_MRP) FROM bigmartsales),2)
						WHEN name_stat = 'Outlet_Establishment_Year'	THEN ROUND((SELECT max(Outlet_Establishment_Year) FROM bigmartsales),2)
						WHEN name_stat = 'Item_Outlet_Sales'			THEN ROUND((SELECT max(Item_Outlet_Sales) FROM bigmartsales),2)
						ELSE 'none'
				END
				
select *
FROM stat

-- Find missing values in each columns
Select 
	Item_Identifier
FROM bigmartsales
WHERE Item_Identifier is null 

--**null
Select 
	Item_Weight 
FROM bigmartsales
WHERE Item_Weight  is null 

Select 
	Item_Fat_Content
FROM bigmartsales
WHERE Item_Fat_Content is null 

Select 
	Item_Visibility
FROM bigmartsales
WHERE Item_Visibility is null 

Select 
	Item_Type
FROM bigmartsales
WHERE Item_Type is null 

Select 
	Item_MRP
FROM bigmartsales
WHERE Item_MRP is null 


Select 
	Outlet_Identifier               
FROM bigmartsales
WHERE Outlet_Identifier is null 


Select 
	Outlet_Establishment_Year
FROM bigmartsales
WHERE Outlet_Establishment_Year is null 


Select 
	Outlet_Size,
	COUNT(Outlet_Size)
FROM bigmartsales
GROUP BY Outlet_Size

Select 
	Outlet_Location_Type
FROM bigmartsales
WHERE Outlet_Location_Type is null 


Select 
	Outlet_Type
FROM bigmartsales
WHERE Outlet_Type is null 


Select 
	Item_Outlet_Sales
FROM bigmartsales
WHERE Item_Outlet_Sales is null 


-- Data Pre-processing
-- Handling Dirty Data
-- Item_Fat_Content >> Change LF to Low FAT and Change reg to Regular
SELECT
	Item_Fat_Content,
	COUNT(Item_Fat_Content)
FROM bigmartsales
GROUP BY Item_Fat_Content

UPDATE bigmartsales
SET Item_Fat_Content = 
						CASE
							WHEN Item_Fat_Content = 'LF' THEN 'Low Fat'
							WHEN Item_Fat_Content = 'reg' THEN 'Regular'
							ELSE Item_Fat_Content
						END



-- Handling Missing Values 
-- Outlet_Size
SELECT
	Outlet_type,
	Outlet_Size,
	COUNT(Item_Identifier)
FROM bigmartsales
GROUP BY Outlet_Size, Outlet_type
ORDER BY Outlet_Size DESC

UPDATE bigmartsales
SET Outlet_Size = 'Small'
WHERE (Outlet_type = 'Grocery Store'
	OR Outlet_type = 'Supermarket Type1')
	AND Outlet_Size <> 'High'



-- The Null of Item_Weight 
Select 
	Item_Identifier,
	COUNT(Item_Weight) AS Item_Weight_count
FROM bigmartsales
WHERE Item_Weight is null
GROUP BY Item_Identifier
ORDER BY Item_Weight_count DESC

-- Feature Engineering
-- Item_Category
-- Split Item_Identifier to
-- FD = food products, DR = drink products, and NC = non-consumable.
ALTER TABLE bigmartsales
ADD Item_Category nvarchar(255)

SELECT
	Item_Identifier,
	CASE
		WHEN LEFT(Item_Identifier,2) = 'FD' THEN 'food products'
		WHEN LEFT(Item_Identifier,2) = 'DR' THEN 'drink products'
		WHEN LEFT(Item_Identifier,2) = 'NC' THEN 'non-consumable'
		ELSE LEFT(Item_Identifier,2)
	END AS Item_Category 
FROM bigmartsales

UPDATE bigmartsales
SET Item_Category = 
		CASE
			WHEN LEFT(Item_Identifier,2) = 'FD' THEN 'food products'
			WHEN LEFT(Item_Identifier,2) = 'DR' THEN 'drink products'
			WHEN LEFT(Item_Identifier,2) = 'NC' THEN 'non-consumable'
			ELSE LEFT(Item_Identifier,2)
		END

-- Age_Outlet
ALTER TABLE bigmartsales
ADD Age_Outlet FLOAT

SELECT 
	2023 - Outlet_Establishment_Year
FROM bigmartsales

UPDATE bigmartsales
SET Age_Outlet = 2023 - Outlet_Establishment_Year

-- Binning

-- Label Encoding
SELECT
	Item_Fat_Content,
	CASE
		WHEN Item_Fat_Content = 'Low Fat' THEN 0
		WHEN Item_Fat_Content = 'Regular' THEN 1
		ELSE 2
	END AS Item_Fat_Content_Encoding
FROM bigmartsales

ALTER TABLE bigmartsales
ADD Item_Fat_Content_Encoding int

UPDATE bigmartsales
SET Item_Fat_Content_Encoding = CASE
									WHEN Item_Fat_Content = 'Low Fat' THEN 0
									WHEN Item_Fat_Content = 'Regular' THEN 1
									ELSE 2
								END 

-- One-Hot Encoding
-- One-hot encoding will be performed for 
-- "Item_Category", "Outlet_Category", "Outlet_Size", and "Outlet_Location_Type".
-- "Item_Category_drink" = 1,

ALTER TABLE bigmartsales
ADD 
	Item_Category_drink int,
	Item_Category_food int,
	Item_Category_none int

SELECT 
	Item_Category,
	CASE
		WHEN Item_Category = 'food products' THEN 1
		ELSE 0
	END AS Item_Category_food,
	CASE
		WHEN Item_Category = 'drink products' THEN 1
		ELSE 0
	END AS Item_Category_drink,
	CASE
		WHEN Item_Category = 'non-consumable' THEN 1
		ELSE 0
	END AS Item_Category_none
FROM bigmartsales

UPDATE bigmartsales
SET Item_Category_food =	CASE
								WHEN Item_Category = 'food products' THEN 1
								ELSE 0
							END


UPDATE bigmartsales
SET Item_Category_drink =	CASE
								WHEN Item_Category = 'drink products' THEN 1
								ELSE 0
							END

-- One-Hot Encoding
-- Outlet_Size_High, Outlet_Size_Medium, Outlet_Size_Small

ALTER TABLE bigmartsales
ADD 
	Outlet_Size_High int,
	Outlet_Size_Medium int,
	Outlet_Size_Small int

UPDATE bigmartsales
SET Outlet_Size_High =	CASE
								WHEN Outlet_Size = 'Hight' THEN 1
								ELSE 0
							END


UPDATE bigmartsales
SET Outlet_Size_Medium =	CASE
								WHEN Outlet_Size = 'Medium' THEN 1
								ELSE 0
							END


UPDATE bigmartsales
SET Outlet_Size_Small =	CASE
								WHEN Outlet_Size = 'Small' THEN 1
								ELSE 0
							END




SELECT *
FROM bigmartsales
