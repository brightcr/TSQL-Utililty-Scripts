-- The brightcr licenses this file to you under the MIT license.
-- See the LICENSE file in the project root for more information.

-- The script find rows which are present in one relation but not present in other and vice versa

-- 1. Without using Except operator
-- Create sample data
-------------------------------------------
CREATE TABLE #temp (ID INT, Name nvarchar(1024));
INSERT INTO #temp
VALUES (1, 'Washington'), (1, 'Arkansas'),  (1, 'Iowa'), (1, 'New Jersey'),
(2, 'Springfield'), (2, 'Colorado'),  (2, 'Florida'),
(3, 'Texas'), (3, 'Ohio'),
(4, 'Minnesota')

;WITH Actual AS
(
	-- Select data from one table
	SELECT Name	FROM #temp
),
Expected AS
(
	-- Select data from other table or generate SQL statements
	SELECT 'Colorado' AS Name
	UNION ALL SELECT 'Arkansas' UNION ALL SELECT 'Washington'
	UNION ALL SELECT 'Maine' UNION ALL SELECT 'Connecticut'
	UNION ALL SELECT 'Florida'
)
SELECT * , 'Actual' AS [DataSource]
FROM Actual A
WHERE NOT EXISTS (SELECT * FROM Expected E WHERE A.Name = E.Name)
UNION ALL
SELECT *, 'Expected'
FROM Expected E
WHERE NOT EXISTS (SELECT * FROM Actual A WHERE E.Name = A.Name)
ORDER BY DataSource, NAME

-- Cleanup
DROP TABLE #temp
GO


-- 2. Using Except operator
-- Create sample data
-------------------------------------------
CREATE TABLE #temp1 (ID INT, Name nvarchar(1024));
INSERT INTO #temp1
VALUES (1, 'Washington'), (1, 'Arkansas'),  (1, 'Iowa'), (1, 'New Jersey'),
(2, 'Springfield'), (2, 'Colorado'),  (2, 'Florida'),
(3, 'Texas'), (3, 'Ohio'),
(4, 'Minnesota')

;WITH Actual AS
(
	-- Select data from one table
	SELECT Name	FROM #temp1
),
Expected AS
(
	-- Select data from other table
	SELECT 'Colorado' AS Name
	UNION ALL SELECT 'Arkansas' UNION ALL SELECT 'Washington'
	UNION ALL SELECT 'Maine' UNION ALL SELECT 'Connecticut'
	UNION ALL SELECT 'Florida'
)

(SELECT *, 'Actual' AS DataSource FROM Actual A
	EXCEPT
SELECT *, 'Actual' FROM Expected E)
UNION ALL
(SELECT *, 'Expected' AS DataSource FROM Expected E
	EXCEPT
SELECT *, 'Expected' FROM Actual A)
ORDER BY DataSource, NAME

-- Cleanup
DROP TABLE #temp1
GO

/* Both queries gives output:
Name	DataSource
Iowa	Actual
Minnesota	Actual
New Jersey	Actual
Ohio	Actual
Springfield	Actual
Texas	Actual
Connecticut	Expected
Maine	Expected
*/