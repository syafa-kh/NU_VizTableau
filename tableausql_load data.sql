----------------------------------------------------------------
-- TableauTable1: Title, genres, tags, performance
----------------------------------------------------------------

-- Create a new table called 'TableauTable1' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.TableauTable1', 'U') IS NOT NULL
DROP TABLE dbo.TableauTable1
GO
-- Create the table in the specified schema
CREATE TABLE dbo.TableauTable1
(
    title NVARCHAR(200),
    genres NVARCHAR(MAX),
    tags NVARCHAR(MAX),
    one_star INT,
    two_star INT,
    three_star INT,
    four_star INT,
    five_star INT,
    rating FLOAT
);
GO

-- Import the file
BULK INSERT dbo.TableauTable1
FROM 'D:\Job Hunting\Portfolio Project\Python\novelupdates new eda\tableau1.csv'
WITH
(
    FORMAT = 'CSV', 
    FIRSTROW = 2,
    FIELDQUOTE  = '"',
    CODEPAGE = '65001',        
    FIELDTERMINATOR = ',', 
    -- ROWTERMINATOR = '0x0a',    
    TABLOCK
)
GO

SELECT * FROM dbo.TableauTable1
GO



----------------------------------------------------------------
-- TableauTable2: title, OHE genres, performance
----------------------------------------------------------------

-- Create a new table called 'TableauTable2' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.TableauTable2', 'U') IS NOT NULL
DROP TABLE dbo.TableauTable2
GO
-- Create the table in the specified schema
CREATE TABLE dbo.TableauTable2
(
    title NVARCHAR(MAX),
    perf_one_star INT,
    perf_two_star INT,
    perf_three_star INT,
    perf_four_star INT,
    perf_five_star INT,
    perf_rating FLOAT,
    gen_action INT,
    gen_adult INT,
    gen_adventure INT,
    gen_comedy INT,
    gen_drama INT,
    gen_ecchi INT,
    gen_fantasy INT,
    gen_gender_bender INT,
    gen_harem INT,
    gen_historical INT,
    gen_horror INT,
    gen_josei INT,
    gen_martial_arts INT,
    gen_mature INT,
    gen_mecha INT,
    gen_mystery INT,
    gen_psychological INT,
    gen_romance INT,
    gen_school_life INT,
    gen_sci_fi INT,
    gen_seinen INT,
    gen_shoujo INT,
    gen_shoujo_ai INT,
    gen_shounen INT,
    gen_shounen_ai INT,
    gen_slice_of_life INT,
    gen_smut INT,
    gen_sports INT,
    gen_supernatural INT,
    gen_tragedy INT,
    gen_wuxia INT,
    gen_xianxia INT,
    gen_xuanhuan INT,
    gen_yaoi INT,
    gen_yuri INT
);
GO

-- Import the file
BULK INSERT dbo.TableauTable2
FROM 'D:\Job Hunting\Portfolio Project\Python\novelupdates new eda\tableau2.csv'
WITH
(
    FORMAT = 'CSV', 
    FIRSTROW = 2,
    FIELDQUOTE  = '"',
    CODEPAGE = '65001',        
    FIELDTERMINATOR = ',', 
    -- ROWTERMINATOR = '0x0a',    
    TABLOCK
)
GO

SELECT * FROM dbo.TableauTable2
GO