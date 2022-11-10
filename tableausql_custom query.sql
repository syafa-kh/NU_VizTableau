-- title, genre, performance
SELECT title,value AS genres,one_star,two_star,three_star,four_star,five_star,rating
FROM dbo.TableauTable1
CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(REPLACE(genres, '[',''),']',''),'''',''),', ','%'),'%')
GO

-- title, genre, tag
SELECT g.title,g.value AS genres,t.value as TAGS
FROM (
    SELECT title,value 
    FROM dbo.TableauTable1
    CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(REPLACE(genres, '[',''),']',''),'''',''),', ','%'),'%')
) g
JOIN (
       SELECT title,value 
    FROM dbo.TableauTable1
    CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(REPLACE(tags, '[',''),']',''),'''',''),', ','%'),'%')
) t ON g.title = t.title
GO



----------------------------------------------------------------

-- Pearson Correlation for each genre-performance pair

----------------------------------------------------------------

----------------------------------------------------------------
-- Performance (rating and votes) unpivot
----------------------------------------------------------------

 -- Create a new view called 'perfView' in schema 'dbo'
 -- Drop the view if it already exists
 IF EXISTS (
 SELECT *
    FROM sys.views
    JOIN sys.schemas
    ON sys.views.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'dbo'
    AND sys.views.name = N'perfView'
 )
 DROP VIEW dbo.perfView
 GO
 -- Create the view in the specified schema
 CREATE VIEW dbo.perfView
 AS
    SELECT title,
            CAST(perf_one_star AS FLOAT) AS perf_one_star,
            CAST(perf_two_star AS FLOAT) AS perf_two_star,
            CAST(perf_three_star AS FLOAT) AS perf_three_star,
            CAST(perf_four_star AS FLOAT) AS perf_four_star,
            CAST(perf_five_star AS FLOAT) AS perf_five_star,
            perf_rating
    FROM dbo.TableauTable2
 GO

-- Drop the stored procedure called 'unpivotPerformance' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'unpivotPerformance'
)
DROP PROCEDURE dbo.unpivotPerformance
GO

CREATE PROC unpivotPerformance
AS
BEGIN
    DECLARE @cols AS NVARCHAR(MAX)
    DECLARE @query AS NVARCHAR(MAX)

    SELECT @cols = STUFF((SELECT distinct ',' +
                            QUOTENAME(column_name)
                        FROM INFORMATION_SCHEMA.COLUMNS
                        WHERE TABLE_NAME='perfView'
                            AND COLUMN_NAME <> 'title' 
                        FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)') 
                            , 1, 1, '')

    SELECT @query = '
            SELECT title,columns,value
            FROM perfView
            UNPIVOT (
                value
                FOR columns IN('+ @cols +')
            ) AS u'
    EXEC(@query)
END
GO

sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO
sp_configure 'Ad Hoc Distributed Queries', 1
GO
RECONFIGURE
GO

-- Drop the table '#unpivotedPerfView' in schema 'dbo'
IF EXISTS (
    SELECT *
        FROM sys.tables
        JOIN sys.schemas
            ON sys.tables.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'dbo'
        AND sys.tables.name = N'#unpivotedPerfView'
)
    DROP TABLE dbo.#unpivotedPerfView
GO
SELECT * INTO #unpivotedPerfView FROM OPENROWSET('SQLNCLI', 'Server=LAPTOP-KCVKCA40\SQLEXPRESS;DATABASE=ProjectDatabase;Trusted_Connection=yes;',
     'EXEC unpivotPerformance WITH RESULT SETS ((
        title NVARCHAR(MAX),
        columns NVARCHAR(MAX),
        value FLOAT
     ))')
GO

----------------------------------------------------------------
-- Genres unpivot
----------------------------------------------------------------

-- Create a new view called 'genView' in schema 'dbo'
 -- Drop the view if it already exists
 IF EXISTS (
 SELECT *
    FROM sys.views
    JOIN sys.schemas
    ON sys.views.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'dbo'
    AND sys.views.name = N'genView'
 )
 DROP VIEW dbo.genView
 GO
 -- Create the view in the specified schema
 CREATE VIEW dbo.genView
 AS
    SELECT title,
        gen_action,
        gen_adult,
        gen_adventure,
        gen_comedy,
        gen_drama,
        gen_ecchi,
        gen_fantasy,
        gen_gender_bender,
        gen_harem,
        gen_historical,
        gen_horror,
        gen_josei,
        gen_martial_arts,
        gen_mature,
        gen_mecha,
        gen_mystery,
        gen_psychological,
        gen_romance,
        gen_school_life,
        gen_sci_fi,
        gen_seinen,
        gen_shoujo,
        gen_shoujo_ai,
        gen_shounen,
        gen_shounen_ai,
        gen_slice_of_life,
        gen_smut,
        gen_sports,
        gen_supernatural,
        gen_tragedy,
        gen_wuxia,
        gen_xianxia,
        gen_xuanhuan,
        gen_yaoi,
        gen_yuri
    FROM dbo.TableauTable2
 GO

-- Drop the stored procedure called 'unpivotPerformance' in schema 'dbo'
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'unpivotGenre'
)
DROP PROCEDURE dbo.unpivotGenre
GO

CREATE PROC unpivotGenre
AS
BEGIN
    DECLARE @cols AS NVARCHAR(MAX)
    DECLARE @query AS NVARCHAR(MAX)

    SELECT @cols = STUFF((SELECT distinct ',' +
                            QUOTENAME(column_name)
                        FROM INFORMATION_SCHEMA.COLUMNS
                        WHERE TABLE_NAME='genView'
                            AND COLUMN_NAME <> 'title' 
                        FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)') 
                            , 1, 1, '')

    SELECT @query = '
            SELECT title,columns,value
            FROM genView
            UNPIVOT (
                value
                FOR columns IN('+ @cols +')
            ) AS u'
    EXEC(@query)
END
GO

sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO
sp_configure 'Ad Hoc Distributed Queries', 1
GO
RECONFIGURE
GO

-- Drop the table '#unpivotedGenView' in schema 'dbo'
IF EXISTS (
    SELECT *
        FROM sys.tables
        JOIN sys.schemas
            ON sys.tables.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'dbo'
        AND sys.tables.name = N'#unpivotedGenView'
)
DROP TABLE dbo.#unpivotedGenView
GO
SELECT * INTO #unpivotedGenView FROM OPENROWSET('SQLNCLI', 'Server=LAPTOP-KCVKCA40\SQLEXPRESS;DATABASE=ProjectDatabase;Trusted_Connection=yes;',
     'EXEC unpivotGenre WITH RESULT SETS ((
        title NVARCHAR(MAX),
        columns NVARCHAR(MAX),
        value INT
     ))')
GO

----------------------------------------------------------------
-- Calculate Corr
----------------------------------------------------------------

SELECT gen.columns AS Genres,
       perf.columns As Performance,
       (count(*) * sum(gen.value * perf.value) - sum(gen.value) * sum(perf.value)) / 
        (sqrt(count(*) * sum(gen.value * gen.value) - sum(gen.value) * sum(gen.value)) * sqrt(count(*) * sum(perf.value * perf.value) - sum(perf.value) * sum(perf.value))) AS Corr
    --    (Avg(gen.value * perf.value) - (Avg(gen.value) * Avg(perf.value))) / (StDevP(gen.value) * StDevP(perf.value)) AS Correlation
FROM #unpivotedGenView gen
     JOIN #unpivotedPerfView perf ON gen.title = perf.title
GROUP BY gen.columns, perf.columns
ORDER BY gen.columns, perf.columns
GO