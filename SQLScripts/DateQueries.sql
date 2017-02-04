-- The brightcr licenses this file to you under the MIT license.
-- See the LICENSE file in the project root for more information.

-- Query Dates
SELECT
GETDATE() AS [GETDATE],
CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP],
GETUTCDATE() AS [GETUTCDATE],
SYSDATETIME() AS [SYSDATETIME],
SYSUTCDATETIME() AS [SYSUTCDATETIME],
SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET];

-- Get Date Part from DateTime
-- Using DATEADD & DATEDIFF, 20170201 is arbitary- use any same date for both of its places
-- Use required date instead of GETUTCDATE()
SELECT DATEADD(DD, DATEDIFF(DD, '20170201', GETUTCDATE()), '20170201');
-- or to save conversion from varchar
SELECT DATEADD(DD, 0, DATEDIFF(DD, 0, GETUTCDATE()));
-- or SQL Server 2008 and above, returns Date type
SELECT CONVERT(DATE, GETUTCDATE());

-- Type Check
-- Check Type of evaluated column, type is evaluated for first parameter
SELECT SQL_VARIANT_PROPERTY('20170501', 'BaseType');

-- Check expression is date 
-- Returns 1 if the expression is a valid date, time, or datetime value; otherwise, 0.
-- Returns 0 if the expression is a datetime2 value. Also depends on settings
SELECT ISDATE('20170105');

-- Get first day of next month
SELECT DATEADD(MM, DATEDIFF(MM, 0, GETUTCDATE()) + 1, 0);

-- Get last day of current month
SELECT DATEADD(DD, -1, DATEADD(MM, DATEDIFF(MM, 0, GETUTCDATE()) + 1, 0));
-- or simpler with SQL SERVER 2012
SELECT EOMONTH(GETUTCDATE());
