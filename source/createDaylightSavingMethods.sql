-- First Function
IF OBJECT_ID (N'MyDatabase.getGMTDatetimeFrom', N'FN') IS NOT NULL
    DROP FUNCTION MyDatabase.getGMTDatetimeFrom;
GO
CREATE FUNCTION MyDatabase.getGMTDatetimeFrom(@BrDatetime datetime)
RETURNS datetime 
AS 
BEGIN
    DECLARE @GMTDatetime datetime, @IsDaylifghtSaving int; 
	
	SELECT @IsDaylifghtSaving = Count(*)
    FROM MyDatabase.BrazilianDaylightSaving b
    WHERE b.StartBR <= @BrDatetime  
        AND @BrDatetime <= b.[EndBR]; 
    
	IF (@IsDaylifghtSaving > 0) 
		SET @GMTDatetime = DATEADD(hour, 2, @BrDatetime);
	ELSE
		SET @GMTDatetime = DATEADD(hour, 3, @BrDatetime);

    RETURN @GMTDatetime; 
END; 
GO 

-- Second Function
IF OBJECT_ID (N'MyDatabase.getBRDatetimeFrom', N'FN') IS NOT NULL
    DROP FUNCTION MyDatabase.getBRDatetimeFrom;
GO
CREATE FUNCTION MyDatabase.getBRDatetimeFrom(@GMTDatetime datetime)
RETURNS datetime 
AS 
BEGIN
    DECLARE @BRDatetime datetime, @IsDaylightSaving int; 
	
	SELECT @IsDaylightSaving = Count(*)
    FROM MyDatabase.BrazilianDaylightSaving b
    WHERE b.StartGMT <= @GMTDatetime  
        AND @GMTDatetime <= b.[EndGMT]; 
    
	IF (@IsDaylightSaving > 0) 
		SET @BRDatetime = DATEADD(hour, -2, @GMTDatetime);
	ELSE
		SET @BRDatetime = DATEADD(hour, -3, @GMTDatetime);

    RETURN @BRDatetime; 
END; 
GO 

-- Examples of use:
--SELECT [MyDatabase].getGMTDatetimeFrom([Date]) FROM [MyDatabase].[SomeTable]
--group by date
--order by date desc


-- select MyDatabase.getBRDatetimeFrom('2009-10-19 03:00:00.000')


