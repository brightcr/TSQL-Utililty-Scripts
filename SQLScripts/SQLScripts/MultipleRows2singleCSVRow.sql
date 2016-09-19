-- The script retrieves all values for given column into single row

-------------------------------------------
-- #1: All column with multiple value is in same table
-- Create sample data
-------------------------------------------
CREATE TABLE #temp (ID INT, Name nvarchar(1024));
INSERT INTO #temp
VALUES (1, 'Washington'), (1, 'Arkansas'),  (1, 'Iowa'), (1, 'New Jersey'),
(2, 'Springfield'), (2, 'Colorado'),  (2, 'Florida'),
(3, 'Texas'), (3, 'Ohio'),
(4, 'Minnesota')

-- Actual query
SELECT City.ID, SUBSTRING(CA.Name, 0, LEN(CA.Name)) AS CityNames
FROM (SELECT DISTINCT ID FROM #temp) City(ID)
CROSS APPLY
(
	SELECT T.Name + ', '
	FROM #temp T
	WHERE T.ID = City.ID
	FOR XML PATH('')
) CA(Name)
ORDER BY ID

-- Cleanup
DROP TABLE #temp
GO

-------------------------------------------
-- #2: All column with multiple value is in different table - mostly primary-foreign key relationship
-- Create sample data
--------------------------------------------
CREATE TABLE #City (PostalID INT);
INSERT INTO #City
VALUES (1), (2), (3), (4)

CREATE TABLE #CityDetails (PostalID INT, Name nvarchar(1024));
INSERT INTO #CityDetails
VALUES (1, 'Washington'), (1, 'Arkansas'),  (1, 'Iowa'), (1, 'New Jersey'),
(2, 'Springfield'), (2, 'Colorado'),  (2, 'Florida'),
(3, 'Texas'), (3, 'Ohio'),
(4, 'Minnesota')

-- Actual query
SELECT #City.PostalID, SUBSTRING(CA.Name, 0, LEN(CA.Name)) AS CityNames
FROM #City
CROSS APPLY
(
	SELECT Details.Name + ', '
	FROM #CityDetails Details
	WHERE Details.PostalID = #City.PostalID
	FOR XML PATH('')
) CA(Name)
ORDER BY PostalID

-- Cleanup
DROP TABLE #CityDetails
DROP TABLE #City
GO

-------------------------------------------
-- #3: Convert all the values in the given colum to the single Row of CSV
-- Create sample data
-------------------------------------------
CREATE TABLE #temp1 (ID INT, Name nvarchar(1024));
INSERT INTO #temp1
VALUES (1, 'Washington'), (1, 'Arkansas'),  (1, 'Iowa'), (1, 'New Jersey'),
(2, 'Springfield'), (2, 'Colorado'),  (2, 'Florida'),
(3, 'Texas'), (3, 'Ohio'),
(4, 'Minnesota')

-- Actual query
SELECT City.ID, SUBSTRING(CA.Name, 0, LEN(CA.Name)) AS CityNames
FROM (SELECT 1) City(ID)
CROSS APPLY
(
	SELECT T.Name + ', '
	FROM #temp1 T	
	FOR XML PATH('')
) CA(Name)
ORDER BY ID

-- Cleanup
DROP TABLE #temp1
GO