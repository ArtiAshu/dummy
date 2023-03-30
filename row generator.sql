SET NOCOUNT ON;
--create and load 10M row tally table
DROP TABLE IF EXISTS dbo.Tally;
CREATE TABLE dbo.Tally(
     Num int NOT NULL CONSTRAINT PK_Tally PRIMARY KEY
);
WITH 
     t10 AS (SELECT n FROM (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) t(n))
    ,t1k AS (SELECT 0 AS n FROM t10 AS a CROSS JOIN t10 AS b CROSS JOIN t10 AS c)
    ,t10m AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 0)) AS num FROM t1k AS a
    CROSS JOIN t1k AS b CROSS JOIN t10 AS c)
INSERT INTO dbo.Tally WITH(TABLOCKX) (Num) 
    SELECT num 
    FROM t10m;
ALTER INDEX PK_Tally ON dbo.Tally REBUILD WITH (FILLFACTOR=100);
GO

--create and load 2B row table using tally table source
CREATE TABLE dbo.TableHere(
    ID int NOT NULL
);

DECLARE
      @TargetRowCount int = 200--0000000
    , @RowsInserted int = 0;

WHILE @RowsInserted < @TargetRowCount
BEGIN

    INSERT INTO dbo.TableHere WITH(TABLOCKX) (ID)
        SELECT Num + @RowsInserted
        FROM dbo.Tally;

    SET @RowsInserted += @@ROWCOUNT;

    DECLARE @CurrentTimestampString varchar(1000) = FORMAT(SYSDATETIME(),'yyyy-MM-dd HH:mm:ss');
    RAISERROR('%s: %d of %d rows inserted', 0, 0, @CurrentTimestampString, @RowsInserted, @TargetRowCount) WITH NOWAIT;

END;
GO


-- Create SampleData table
truncate table [dbo].[SampleData2]
CREATE TABLE [dbo].[SampleData2]( 
	[RowKey] [int] NOT NULL, 
	--[CreateDate] [int] NOT NULL,
	--[OtherDate] [int] NOT NULL,
	[VarcharColumn1] [varchar](20) NULL,
	--[VarcharColumn2] [varchar](20) NULL,
	--[VarcharColumn3] [varchar](20) NULL,
	--[VarcharColumn4] [varchar](20) NULL,
	--[VarcharColumn5] [varchar](20) NULL,
	[IntColumn1] int NULL,
	--[IntColumn2] int NULL,
	--[IntColumn3] int NULL,
	--[IntColumn4] int NULL,
	--[IntColumn5] int NULL,
	--[IntColumn6] int NULL,
	--[IntColumn7] int NULL,
	--[IntColumn8] int NULL,
	--[IntColumn9] int NULL,
	--[IntColumn10] int NULL,
	--[FloatColumn1] float NULL,
	--[FloatColumn2] float NULL,
	--[FloatColumn3] float NULL,
	--[FloatColumn4] float NULL,
	[FloatColumn5] float NULL	
)
GO

-- Load sample data into table
DECLARE @val INT
SELECT @val=1
WHILE @val < 500
BEGIN  
   INSERT INTO dbo.SampleData2
       VALUES (@val,
       --CAST(CONVERT(varchar,DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365),
       --   '2015-01-01'),112) as integer),
       --CAST(CONVERT(varchar,DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365),
       --   '2015-01-01'),112) as integer),
       'TEST' + cast(round(rand()*100,0) AS VARCHAR),
       --'TEST' + cast(round(rand()*100,0) AS VARCHAR),
       --'TEST' + cast(round(rand()*100,0) AS VARCHAR),
       --'TEST' + cast(round(rand()*100,0) AS VARCHAR),
       --'TEST' + cast(round(rand()*100,0) AS VARCHAR),
       round(rand()*100000,0), 
       --round(rand()*100000,0), 	   
       --round(rand()*100000,0), 	   
       --round(rand()*100000,0), 	   
       --round(rand()*100000,0),
       --round(rand()*100000,0),
       --round(rand()*100000,0),
       --round(rand()*100000,0),
       --round(rand()*100000,0),
       --round(rand()*100000,0),
	   --round(rand()*10000,2),
	   --round(rand()*10000,2),
	   --round(rand()*10000,2),
	   --round(rand()*10000,2),
	   round(rand()*10000,2))
   SELECT @val=@val+1
END
GO

USE [VEAR_SA_DUMMY]
GO

/****** Object:  Table [dbo].[SampleData1]    Script Date: 10/11/2022 11:07:43 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SampleData3]') AND type in (N'U'))
truncate TABLE [dbo].[SampleData3]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SampleData3]') AND type in (N'U'))
drop TABLE [dbo].[SampleData3]
GO

SELECT top 100000000 a.* into [VEAR_SA_DUMMY].[dbo].[SampleData3]
FROM (select [RowKey] id
      ,[VarcharColumn1] col1
      ,[IntColumn1] col2
      ,[FloatColumn5] col3
	  from [VEAR_SA_DUMMY].[dbo].[SampleData1]) a
     CROSS JOIN [VEAR_SA_DUMMY].[dbo].[SampleData1]

	 


	 DECLARE @val INT
DECLARE @var varchar(20)
DECLARE @intcol int
DECLARE @flo float

SELECT @val=1
WHILE @val < 100000000

BEGIN  

   SELECT @var = 'TEST' + cast(round(rand()*100,0) AS VARCHAR)
   SELECT @intcol = round(rand()*100000,0)
    SELECT @flo = round(rand()*10000,2)
   INSERT INTO dbo.S2
       VALUES (@val, @var, @intcol, @flo
   )
   SELECT @val=@val+1
END

--truncate table dbo.s2


Generate records Data
drop table #Table1
CREATE TABLE #Table1 (
	id int PRIMARY KEY
	,number int
	,name nvarchar(10)
	);

	SET NOCOUNT ON
	-- start point for adding rows
	declare @rowsNumber int = 1000000

	DECLARE @id INT = ISNULL((SELECT MAX(id) FROM #Table1)+1, 1)
	DECLARE @iteration INT = 0
	WHILE @iteration < @rowsNumber
		BEGIN

			--get a random int from 0 to 100
			DECLARE @number INT = CAST(RAND()*100 AS INT)

			-- generate random nvarchar
			-- get a random nvarchar ascii char 65 to 128
			DECLARE @name NVARCHAR(10) = N'' --empty string for start
			DECLARE @length INT = CAST(RAND() * 10 AS INT) --random length of nvarchar
			WHILE @length <> 0 --in loop we will randomize chars till the last one
				BEGIN
					SELECT @name = @name + CHAR(CAST(RAND() * 63 + 65 as INT))
					SET @length = @length - 1 --next iteration
				END

			--insert data
			INSERT INTO #Table1 (id, number, name)
			VALUES (@id, @number, @name)
			SET @iteration += 1
			SET @id += 1
		END
	SET NOCOUNT OFF
	select count(*) from #Table1
	select top 10 * from #Table1


--Change 1000000 to the number of your preference for your needs
SELECT TOP 1000000
      c1.[FirstName],
	  c2.[LastName]
 
  FROM [dbo].[DimCustomer] c1
CROSS JOIN
DimCustomer c2


with randowvalues
    as(
       select 1 id, CAST(RAND(CHECKSUM(NEWID()))*100 as int) randomnumber
	   --select 1 id, RAND(CHECKSUM(NEWID()))*100 randomnumber
        union  all
        select id + 1, CAST(RAND(CHECKSUM(NEWID()))*100 as int)  randomnumber
		--select id + 1, RAND(CHECKSUM(NEWID()))*100  randomnumber
        from randowvalues
        where 
          id < 1000
      )
 
 
 
    select *
    from randowvalues
    OPTION(MAXRECURSION 0)
