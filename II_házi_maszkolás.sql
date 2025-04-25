CREATE FUNCTION partail (@x NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @mask NVARCHAR(255)
    SET @mask = 
        LEFT(@x, 1) + 
        'XXX' +
        RIGHT(@x, 1)

    RETURN @mask
END
GO

CREATE FUNCTION email (@x NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @mask NVARCHAR(255)
    SET @mask =  CONCAT('****@', SUBSTRING_INDEX(@x, '@', -1))
    RETURN @mask
END
GO

CREATE FUNCTION random()
RETURNS int
AS
BEGIN
    RETURN 2025-FLOOR(RAND()*100)
END
GO

CREATE TABLE maszkolt (
    [LOGIN] VARCHAR(32) MASKED WITH (FUNCTION ='partial([LOGIN])'),
    EMAIL VARCHAR(64) MASKED WITH (FUNCTION ='email(EMAIL)'),
    NEV VARCHAR(64) NOT NULL,
    SZULEV NUMERIC(4) MASKED WITH (FUNCTION='random()'),
    NEM CHAR(1),
    CIM VARCHAR(128),
    PRIMARY KEY ([LOGIN])
)

CREATE USER felhasznalo WITHOUT Login
GRANT SELECT ON maszkolta TO felhasznalo

EXECUTE AS User= 'felhasznalo';
SELECT * FROM maszkolt
REVERT