SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50)

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';  

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();    
SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');  
 
RAISERROR (@Message, 0,1) WITH NOWAIT;

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE SCHEMA Shelter.';

IF EXISTS (
SELECT schema_name
FROM information_schema.schemata
WHERE   schema_name = 'Shelter' )
BEGIN
    SET @Message = 'SCHEMA Shelter already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA Shelter';
    SET @Message = 'Completed CREATE SCHEMA Shelter.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.AnimalColor.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.AnimalColor') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.AnimalColor already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.AnimalColor
    (
        ColorID TINYINT NOT NULL,
        Name NVARCHAR(10) NOT NULL,
        CONSTRAINT PK_Color_ColorID PRIMARY KEY CLUSTERED (ColorID),
        CONSTRAINT UK_Color_Name UNIQUE (Name)
    );
    INSERT INTO	Shelter.AnimalColor
        (ColorID, Name)
    VALUES
        (01, 'Black'),
        (02, 'Brown'),
        (03, 'Cream'),
        (04, 'Ginger'),
        (05, 'Gray'),
        (06, 'White');

    SET @Message = 'Completed CREATE TABLE Shelter.AnimalColor.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.AnimalType.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.AnimalType') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.AnimalType already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.AnimalType
    (
        TypeID TINYINT NOT NULL,
        Name NVARCHAR(10) NOT NULL,
        CONSTRAINT PK_AnimalType_TypeID PRIMARY KEY CLUSTERED (TypeID),
        CONSTRAINT UK_AnimalType_Name UNIQUE (Name)
    );
    INSERT INTO	Shelter.AnimalType
        (TypeID, Name)
    VALUES
        (01, 'Cat'),
        (02, 'Dog'),
        (03, 'Ferret'),
        (04, 'Rabbit'),
        (05, 'Raccoon');

    SET @Message = 'Completed CREATE TABLE Shelter.AnimalType.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.Animal.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.Animal') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.Animal already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.Animal
    (
        AnimalID TINYINT NOT NUll,
        Name NVARCHAR(20) NOT NULL,
        TypeID TINYINT NOT NUll,
        ColorID TINYINT NOT NUll,
        Breed NVARCHAR(50) NULL,
        Gender NCHAR(1) NOT NULL,
        BirthDate DATE NOT NULL,
        Pattern NVARCHAR(20) NOT NULL,
        AdmissionDate DATE NOT NULL,
        CONSTRAINT PK_Animal_AnimalID PRIMARY KEY CLUSTERED (AnimalID)
    );
    INSERT INTO	Shelter.Animal
        (AnimalID, Name, TypeID, ColorID, Breed, Gender, BirthDate, Pattern, AdmissionDate)
    VALUES
        (001, 'Abby', 02, 01, NULL, 'F', CAST('1999-02-19' AS DATE), 'Tricolor', CAST('2016-07-19' AS DATE)),
        (002, 'Ace', 02, 04, NULL, 'M', CAST('2005-12-19' AS DATE), 'Bicolor', CAST('2019-06-25' AS DATE)),
        (003, 'Angel', 02, 02, NULL, 'F', CAST('2001-09-19' AS DATE), 'Tuxedo', CAST('2017-02-04' AS DATE)),
        (004, 'April', 04, 05, NULL, 'F', CAST('2005-01-27' AS DATE), 'Broken', CAST('2019-04-24' AS DATE)),
        (005, 'Archie', 01, 04, 'Persian', 'M', CAST('2009-08-26' AS DATE), 'Tricolor', CAST('2016-07-10' AS DATE)),
        (006, 'Arya', 02, 05, NULL, 'F', CAST('2014-04-14' AS DATE), 'Bicolor', CAST('2018-06-10' AS DATE)),
        (007, 'Aspen', 02, 02, NULL, 'F', CAST('2010-04-17' AS DATE), 'Tuxedo', CAST('2016-02-09' AS DATE)),
        (008, 'Bailey', 02, 04, NULL, 'F', CAST('2014-09-28' AS DATE), 'Bicolor', CAST('2018-10-01' AS DATE)),
        (009, 'Baloo', 04, 06, 'English Lop', 'M', CAST('2015-04-27' AS DATE), 'Broken', CAST('2016-08-21' AS DATE)),
        (010, 'Beau', 02, 03, NULL, 'M', CAST('2016-02-09' AS DATE), 'Solid', CAST('2017-05-24' AS DATE)),
        (011, 'Benji', 02, 05, 'English setter', 'M', CAST('2012-05-21' AS DATE), 'Bicolor', CAST('2018-10-02' AS DATE)),
        (012, 'Benny', 02, 02, NULL, 'M', CAST('2010-03-04' AS DATE), 'Tuxedo', CAST('2018-09-30' AS DATE)),
        (013, 'Blue', 02, 04, NULL, 'M', CAST('2003-09-03' AS DATE), 'Bicolor', CAST('2016-04-03' AS DATE)),
        (014, 'Bon bon', 04, 05, NULL, 'F', CAST('2002-06-29' AS DATE), 'Broken', CAST('2016-01-03' AS DATE)),
        (015, 'Boomer', 02, 01, 'Schnauzer', 'M', CAST('2013-08-11' AS DATE), 'Tricolor', CAST('2017-01-11' AS DATE)),
        (016, 'Brody', 02, 01, 'Schnauzer', 'M', CAST('2007-08-23' AS DATE), 'Tricolor', CAST('2018-12-05' AS DATE)),
        (017, 'Brutus', 02, 04, 'Weimaraner', 'M', CAST('2011-04-04' AS DATE), 'Bicolor', CAST('2018-08-03' AS DATE)),
        (018, 'Buddy', 01, 06, NULL, 'M', CAST('2017-01-26' AS DATE), 'Tortoiseshell', CAST('2018-12-20' AS DATE)),
        (019, 'Callie', 02, 03, 'English setter', 'F', CAST('2003-08-28' AS DATE), 'Solid', CAST('2017-12-19' AS DATE)),
        (020, 'Charlie', 01, 05, NULL, 'M', CAST('2016-06-16' AS DATE), 'Calico', CAST('2018-02-16' AS DATE)),
        (021, 'Chico', 02, 02, NULL, 'M', CAST('2014-03-20' AS DATE), 'Tuxedo', CAST('2019-03-22' AS DATE)),
        (022, 'Chubby', 04, 04, NULL, 'M', CAST('2013-02-07' AS DATE), 'Broken', CAST('2017-10-31' AS DATE)),
        (023, 'Cleo', 01, 01, NULL, 'F', CAST('2015-08-13' AS DATE), 'Tortoiseshell', CAST('2019-09-06' AS DATE)),
        (024, 'Cooper', 02, 01, NULL, 'M', CAST('2009-11-15' AS DATE), 'Tricolor', CAST('2017-01-15' AS DATE)),
        (025, 'Cosmo', 01, 03, NULL, 'M', CAST('2017-11-09' AS DATE), 'Solid', CAST('2019-05-13' AS DATE)),
        (026, 'Dolly', 02, 05, NULL, 'F', CAST('2013-09-29' AS DATE), 'Bicolor', CAST('2018-04-27' AS DATE)),
        (027, 'Emma', 02, 01, 'Schnauzer', 'F', CAST('2006-12-26' AS DATE), 'Tricolor', CAST('2019-03-28' AS DATE)),
        (028, 'Fiona', 01, 05, NULL, 'F', CAST('1999-05-23' AS DATE), 'Calico', CAST('2017-01-13' AS DATE)),
        (029, 'Frankie', 02, 05, 'English setter', 'M', CAST('2003-09-10' AS DATE), 'Bicolor', CAST('2016-06-20' AS DATE)),
        (030, 'George', 01, 02, NULL, 'M', CAST('2001-10-04' AS DATE), 'Bicolor', CAST('2017-11-24' AS DATE)),
        (031, 'Ginger', 02, 04, NULL, 'F', CAST('2015-11-17' AS DATE), 'Bicolor', CAST('2016-11-27' AS DATE)),
        (032, 'Gizmo', 02, 02, NULL, 'M', CAST('2006-01-23' AS DATE), 'Tuxedo', CAST('2019-08-14' AS DATE)),
        (033, 'Gracie', 01, 01, NULL, 'F', CAST('2007-11-20' AS DATE), 'Spotted', CAST('2017-05-21' AS DATE)),
        (034, 'Gus', 02, 03, 'English setter', 'M', CAST('2014-10-29' AS DATE), 'Solid', CAST('2016-09-28' AS DATE)),
        (035, 'Hobbes', 01, 05, NULL, 'M', CAST('2002-01-01' AS DATE), 'Spotted', CAST('2016-07-29' AS DATE)),
        (036, 'Holly', 02, 03, NULL, 'F', CAST('2011-06-13' AS DATE), 'Solid', CAST('2016-12-30' AS DATE)),
        (037, 'Hudini', 04, 03, NULL, 'M', CAST('2018-03-22' AS DATE), 'Brindle', CAST('2019-12-10' AS DATE)),
        (038, 'Humphrey', 04, 03, 'Belgian Hare', 'M', CAST('2008-12-22' AS DATE), 'Brindle', CAST('2017-12-31' AS DATE)),
        (039, 'Ivy', 01, 02, 'Turkish Angora', 'F', CAST('2013-05-13' AS DATE), 'Spotted', CAST('2018-05-20' AS DATE)),
        (040, 'Jake', 02, 06, 'Bullmastiff', 'M', CAST('2011-02-27' AS DATE), 'Tuxedo', CAST('2016-12-14' AS DATE)),
        (041, 'Jax', 02, 04, 'Weimaraner', 'M', CAST('2009-02-06' AS DATE), 'Bicolor', CAST('2017-10-03' AS DATE)),
        (042, 'Kiki', 01, 03, NULL, 'F', CAST('2015-07-07' AS DATE), 'Tricolor', CAST('2019-11-16' AS DATE)),
        (043, 'King', 02, 02, NULL, 'M', CAST('2015-09-12' AS DATE), 'Tuxedo', CAST('2017-08-29' AS DATE)),
        (044, 'Kona', 02, 05, NULL, 'F', CAST('2008-10-16' AS DATE), 'Bicolor', CAST('2019-12-13' AS DATE)),
        (045, 'Layla', 02, 03, NULL, 'F', CAST('2006-03-11' AS DATE), 'Solid', CAST('2018-06-14' AS DATE)),
        (046, 'Lexi', 02, 02, NULL, 'F', CAST('2017-09-17' AS DATE), 'Tuxedo', CAST('2018-06-22' AS DATE)),
        (047, 'Lily', 02, 01, 'Schnauzer', 'F', CAST('2001-04-03' AS DATE), 'Tricolor', CAST('2016-06-18' AS DATE)),
        (048, 'Lucy', 02, 02, 'Weimaraner', 'F', CAST('2003-04-04' AS DATE), 'Tuxedo', CAST('2018-02-22' AS DATE)),
        (049, 'Luke', 02, 05, NULL, 'M', CAST('2017-04-23' AS DATE), 'Bicolor', CAST('2017-12-23' AS DATE)),
        (050, 'Lulu', 01, 04, NULL, 'F', CAST('2003-12-19' AS DATE), 'Calico', CAST('2019-10-09' AS DATE)),
        (051, 'Luna', 02, 03, NULL, 'F', CAST('2009-01-14' AS DATE), 'Solid', CAST('2017-03-02' AS DATE)),
        (052, 'Luna', 04, 01, NULL, 'F', CAST('2010-11-16' AS DATE), 'Broken', CAST('2017-08-18' AS DATE)),
        (053, 'Mac', 02, 05, 'English setter', 'M', CAST('2006-12-23' AS DATE), 'Bicolor', CAST('2018-01-03' AS DATE)),
        (054, 'Maddie', 02, 02, NULL, 'F', CAST('2014-09-26' AS DATE), 'Tuxedo', CAST('2017-05-02' AS DATE)),
        (055, 'Max', 02, 05, NULL, 'M', CAST('2001-12-01' AS DATE), 'Bicolor', CAST('2017-07-26' AS DATE)),
        (056, 'Millie', 02, 04, NULL, 'F', CAST('2015-05-18' AS DATE), 'Bicolor', CAST('2016-10-27' AS DATE)),
        (057, 'Miss Kitty', 01, 01, 'Maine Coon', 'F', CAST('2016-09-19' AS DATE), 'Bicolor', CAST('2019-10-19' AS DATE)),
        (058, 'Misty', 01, 04, 'Siamese', 'F', CAST('2009-02-21' AS DATE), 'Spotted', CAST('2019-06-06' AS DATE)),
        (059, 'Mocha', 02, 02, NULL, 'F', CAST('2002-09-23' AS DATE), 'Tuxedo', CAST('2019-01-10' AS DATE)),
        (060, 'Nala', 02, 05, 'English setter', 'F', CAST('2018-06-02' AS DATE), 'Bicolor', CAST('2019-07-19' AS DATE)),
        (061, 'Nova', 01, 06, 'Sphynx', 'F', CAST('2011-04-07' AS DATE), 'Tortoiseshell', CAST('2017-12-09' AS DATE)),
        (062, 'Odin', 02, 04, NULL, 'M', CAST('2007-07-10' AS DATE), 'Bicolor', CAST('2016-09-15' AS DATE)),
        (063, 'Oscar', 01, 06, NULL, 'M', CAST('2008-06-08' AS DATE), 'Bicolor', CAST('2018-02-23' AS DATE)),
        (064, 'Otis', 02, 04, NULL, 'M', CAST('2008-05-15' AS DATE), 'Bicolor', CAST('2018-07-22' AS DATE)),
        (065, 'Patches', 01, 05, NULL, 'F', CAST('2014-07-29' AS DATE), 'Bicolor', CAST('2018-11-04' AS DATE)),
        (066, 'Peanut', 04, 05, NULL, 'M', CAST('2008-10-14' AS DATE), 'Broken', CAST('2018-04-11' AS DATE)),
        (067, 'Pearl', 01, 02, 'American Bobtail', 'F', CAST('2012-07-05' AS DATE), 'Tricolor', CAST('2019-04-09' AS DATE)),
        (068, 'Penelope', 01, 02, 'Scottish Fold', 'F', CAST('2000-09-21' AS DATE), 'Tabby', CAST('2017-07-12' AS DATE)),
        (069, 'Penelope', 02, 06, 'Bullmastiff', 'F', CAST('2008-06-28' AS DATE), 'Tuxedo', CAST('2016-01-14' AS DATE)),
        (070, 'Penny', 01, 03, NULL, 'F', CAST('2005-11-02' AS DATE), 'Tricolor', CAST('2017-02-15' AS DATE)),
        (071, 'Piper', 02, 04, NULL, 'F', CAST('2012-03-08' AS DATE), 'Bicolor', CAST('2016-03-21' AS DATE)),
        (072, 'Poppy', 02, 02, 'Weimaraner', 'F', CAST('2011-04-09' AS DATE), 'Tuxedo', CAST('2018-05-05' AS DATE)),
        (073, 'Prince', 02, 03, NULL, 'M', CAST('2016-11-06' AS DATE), 'Solid', CAST('2017-08-29' AS DATE)),
        (074, 'Pumpkin', 01, 05, 'Russian Blue', 'M', CAST('2002-12-28' AS DATE), 'Spotted', CAST('2019-01-18' AS DATE)),
        (075, 'Ranger', 02, 04, NULL, 'M', CAST('2015-07-12' AS DATE), 'Bicolor', CAST('2017-09-25' AS DATE)),
        (076, 'Remi / Remy', 02, 03, NULL, 'M', CAST('2001-08-12' AS DATE), 'Solid', CAST('2018-10-13' AS DATE)),
        (077, 'Riley', 02, 04, NULL, 'F', CAST('2013-05-01' AS DATE), 'Bicolor', CAST('2019-03-08' AS DATE)),
        (078, 'Rocky', 01, 02, NULL, 'M', CAST('2009-03-26' AS DATE), 'Solid', CAST('2019-11-18' AS DATE)),
        (079, 'Roxy', 02, 02, 'Weimaraner', 'F', CAST('2013-03-28' AS DATE), 'Tuxedo', CAST('2018-07-23' AS DATE)),
        (080, 'Rusty', 02, 04, NULL, 'M', CAST('2005-01-27' AS DATE), 'Bicolor', CAST('2016-01-05' AS DATE)),
        (081, 'Sadie', 01, 05, NULL, 'F', CAST('2016-08-24' AS DATE), 'Bicolor', CAST('2016-09-19' AS DATE)),
        (082, 'Salem', 01, 04, 'Sphynx', 'M', CAST('2011-02-26' AS DATE), 'Spotted', CAST('2017-10-29' AS DATE)),
        (083, 'Sam', 01, 05, NULL, 'M', CAST('2016-09-18' AS DATE), 'Bicolor', CAST('2018-10-09' AS DATE)),
        (084, 'Sammy', 02, 01, NULL, 'M', CAST('2012-08-24' AS DATE), 'Tricolor', CAST('2018-04-05' AS DATE)),
        (085, 'Samson', 02, 04, NULL, 'M', CAST('2008-01-24' AS DATE), 'Bicolor', CAST('2018-12-28' AS DATE)),
        (086, 'Shadow', 02, 01, NULL, 'M', CAST('2014-07-09' AS DATE), 'Tricolor', CAST('2016-04-07' AS DATE)),
        (087, 'Shelby', 02, 05, NULL, 'F', CAST('2004-08-04' AS DATE), 'Bicolor', CAST('2016-01-28' AS DATE)),
        (088, 'Simon', 01, 05, NULL, 'M', CAST('2008-07-19' AS DATE), 'Bicolor', CAST('2017-10-23' AS DATE)),
        (089, 'Skye', 02, 06, 'Bullmastiff', 'F', CAST('2013-12-10' AS DATE), 'Tuxedo', CAST('2016-04-20' AS DATE)),
        (090, 'Stanley', 01, 03, NULL, 'M', CAST('2005-01-19' AS DATE), 'Tabby', CAST('2019-11-26' AS DATE)),
        (091, 'Stella', 02, 03, NULL, 'F', CAST('2005-03-11' AS DATE), 'Solid', CAST('2017-02-18' AS DATE)),
        (092, 'Thomas', 01, 02, NULL, 'M', CAST('2002-12-11' AS DATE), 'Tricolor', CAST('2018-08-04' AS DATE)),
        (093, 'Thor', 02, 01, NULL, 'M', CAST('2011-05-28' AS DATE), 'Tricolor', CAST('2016-07-24' AS DATE)),
        (094, 'Tigger', 01, 02, 'Turkish Angora', 'M', CAST('2005-06-07' AS DATE), 'Tabby', CAST('2016-01-18' AS DATE)),
        (095, 'Toby', 01, 05, NULL, 'M', CAST('2012-04-07' AS DATE), 'Spotted', CAST('2019-08-30' AS DATE)),
        (096, 'Toby', 02, 06, 'Bullmastiff', 'M', CAST('2003-10-05' AS DATE), 'Tuxedo', CAST('2019-05-08' AS DATE)),
        (097, 'Toby', 04, 06, NULL, 'M', CAST('2011-10-27' AS DATE), 'Broken', CAST('2019-05-23' AS DATE)),
        (098, 'Tyson', 02, 05, NULL, 'M', CAST('2016-01-09' AS DATE), 'Bicolor', CAST('2018-08-19' AS DATE)),
        (099, 'Walter', 02, 03, NULL, 'M', CAST('2001-12-24' AS DATE), 'Solid', CAST('2016-02-21' AS DATE)),
        (100, 'Whitney', 04, 01, 'Lionhead', 'F', CAST('2017-03-02' AS DATE), 'Broken', CAST('2017-09-08' AS DATE));

    SET @Message = 'Completed CREATE TABLE Shelter.Animal.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.Person.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.Person') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.Person already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.Person
    (
        PersonID TINYINT NOT NUll,
        Email NVARCHAR(100) NOT NULL,
        FirstName NVARCHAR(15) NOT NULL,
        LastName NVARCHAR(15) NOT NULL,
        BirthDate DATE NULL,
        Address NVARCHAR(100) NOT NULL,
        State NVARCHAR(20) NOT NULL,
        City NVARCHAR(30) NOT NULL,
        Zip NCHAR(5) NOT NULL,
        CONSTRAINT PK_Person_PersonID PRIMARY KEY CLUSTERED (PersonID),
        CONSTRAINT UK_Person_Email UNIQUE (Email)
    );
    INSERT INTO	Shelter.Person
        (PersonID, Email, FirstName, LastName, BirthDate, Address, State, City, Zip)
    VALUES
        (001, 'adam.brown@gmail.com', 'Adam', 'Brown', CAST('1984-12-22' AS DATE), '41 Hill', 'California', 'Norwalk', '90650'),
        (002, 'alan.cook@hotmail.com', 'Alan', 'Cook', NULL, '115 Sunset', 'California', 'Inglewood', '90301'),
        (003, 'albert.wood@gmail.com', 'Albert', 'Wood', CAST('1962-01-30' AS DATE), '780 Sixth', 'California', 'Bell Gardens', '90201'),
        (004, 'anna.thompson@hotmail.com', 'Anna', 'Thompson', CAST('1997-05-11' AS DATE), '716 Meadow', 'California', 'Los Angeles', '90032'),
        (005, 'anne.parker@icloud.com', 'Anne', 'Parker', CAST('1973-10-21' AS DATE), '130 Eleventh', 'California', 'Carson', '90248'),
        (006, 'ashley.adams@icloud.com', 'Ashley', 'Adams', CAST('1984-02-23' AS DATE), '101 North', 'California', 'Carson', '90749'),
        (007, 'ashley.flores@animalshelter.com', 'Ashley', 'Flores', CAST('1976-04-08' AS DATE), '282 North', 'California', 'Carson', '90749'),
        (008, 'benjamin.edwards@icloud.com', 'Benjamin', 'Edwards', CAST('1990-01-08' AS DATE), '578 Dogwood', 'California', 'Manhattan Beach', '90266'),
        (009, 'bonnie.davis@icloud.com', 'Bonnie', 'Davis', CAST('1951-01-29' AS DATE), '193 Lake', 'California', 'West Hollywood', '90048'),
        (010, 'brenda.martin@gmail.com', 'Brenda', 'Martin', CAST('1952-04-16' AS DATE), '129 South', 'California', 'Santa Monica', '90403'),
        (011, 'bruce.cook@icloud.com', 'Bruce', 'Cook', CAST('1953-01-12' AS DATE), '667 Church', 'California', 'South Whittier', '90605'),
        (012, 'bruce.harris@hotmail.com', 'Bruce', 'Harris', CAST('1957-11-26' AS DATE), '370 Church', 'California', 'South Whittier', '90605'),
        (013, 'carol.mitchell@gmail.com', 'Carol', 'Mitchell', CAST('1994-02-11' AS DATE), '506 Cherry', 'California', 'Torrance', '90503'),
        (014, 'carolyn.nelson@icloud.com', 'Carolyn', 'Nelson', CAST('1985-11-27' AS DATE), '39 Third', 'California', 'Whittier', '90605'),
        (015, 'catherine.howard@icloud.com', 'Catherine', 'Howard', CAST('1952-03-07' AS DATE), '806 Second', 'California', 'Los Angeles', '90068'),
        (016, 'catherine.nguyen@hotmail.com', 'Catherine', 'Nguyen', CAST('1946-03-29' AS DATE), '882 Second', 'California', 'Los Angeles', '90068'),
        (017, 'charles.phillips@gmail.com', 'Charles', 'Phillips', CAST('1980-05-11' AS DATE), '812 Hill', 'California', 'Long Beach', '90813'),
        (018, 'cynthia.campbell@hotmail.com', 'Cynthia', 'Campbell', CAST('1969-01-02' AS DATE), '902 Eighth', 'California', 'Inglewood', '90307'),
        (019, 'denise.ortiz@yahoo.com', 'Denise', 'Ortiz', CAST('1982-04-01' AS DATE), '996 Cherry', 'California', 'Santa Monica', '90407'),
        (020, 'dennis.hill@animalshelter.com', 'Dennis', 'Hill', NULL, '941 Thirteenth', 'California', 'Gardena', '90247'),
        (021, 'diane.thompson@hotmail.com', 'Diane', 'Thompson', CAST('1998-06-25' AS DATE), '762 Church', 'California', 'Willowbrook', '90059'),
        (022, 'donna.brooks@hotmail.com', 'Donna', 'Brooks', CAST('1966-04-05' AS DATE), '972 Cherry', 'California', 'Los Angeles', '90068'),
        (023, 'doris.young@icloud.com', 'Doris', 'Young', CAST('1954-02-15' AS DATE), '511 Ridge', 'California', 'Torrance', '90501'),
        (024, 'elizabeth.clark@icloud.com', 'Elizabeth', 'Clark', CAST('1949-02-23' AS DATE), '443 Twelfth', 'California', 'Rancho Palos Verdes', '90275'),
        (025, 'emily.perez@gmail.com', 'Emily', 'Perez', CAST('1971-08-25' AS DATE), '759 Dogwood', 'California', 'Lynwood', '90262'),
        (026, 'eugene.howard@icloud.com', 'Eugene', 'Howard', CAST('1958-01-20' AS DATE), '647 Eleventh', 'California', 'Inglewood', '90309'),
        (027, 'evelyn.rodriguez@outlook.com', 'Evelyn', 'Rodriguez', CAST('1965-04-10' AS DATE), '793 Sixth', 'California', 'West Rancho Dominguez', '90059'),
        (028, 'frances.cook@yahoo.com', 'Frances', 'Cook', CAST('1973-08-13' AS DATE), '351 Forest', 'California', 'Compton', '90220'),
        (029, 'frances.hill@animalshelter.com', 'Frances', 'Hill', CAST('1953-01-29' AS DATE), '406 Forest', 'California', 'Compton', '90220'),
        (030, 'frank.smith@icloud.com', 'Frank', 'Smith', CAST('1997-09-20' AS DATE), '390 Jefferson', 'California', 'Walnut Park', '90255'),
        (031, 'fred.james@gmail.com', 'Fred', 'James', CAST('1972-08-08' AS DATE), '293 Second', 'California', 'Los Angeles', '90069'),
        (032, 'fred.patel@gmail.com', 'Fred', 'Patel', CAST('1953-03-10' AS DATE), '899 Second', 'California', 'Los Angeles', '90069'),
        (033, 'george.nzalez@icloud.com', 'George', 'nzalez', CAST('1952-12-11' AS DATE), '209 Cedar', 'California', 'Los Angeles', '90004'),
        (034, 'george.scott@hotmail.com', 'George', 'Scott', CAST('1982-05-03' AS DATE), '424 Cedar', 'California', 'Los Angeles', '90004'),
        (035, 'gerald.reyes@animalshelter.com', 'Gerald', 'Reyes', CAST('1956-02-10' AS DATE), '761 Eighth', 'California', 'Long Beach', '90853'),
        (036, 'gerald.thompson@icloud.com', 'Gerald', 'Thompson', CAST('1994-04-07' AS DATE), '631 Eighth', 'California', 'Long Beach', '90853'),
        (037, 'gloria.wright@hotmail.com', 'Gloria', 'Wright', CAST('1947-12-21' AS DATE), '439 Fourteenth', 'California', 'Whittier', '90603'),
        (038, 'grery.evans@icloud.com', 'Grery', 'Evans', CAST('1967-12-22' AS DATE), '481 Seventh', 'California', 'East Rancho Dominguez', '90221'),
        (039, 'grery.james@icloud.com', 'Grery', 'James', CAST('1994-09-24' AS DATE), '337 Seventh', 'California', 'East Rancho Dominguez', '90221'),
        (040, 'harold.clark@icloud.com', 'Harold', 'Clark', CAST('1987-09-26' AS DATE), '771 Ninth', 'California', 'Whittier', '90601'),
        (041, 'harry.wilson@yahoo.com', 'Harry', 'Wilson', CAST('1976-02-06' AS DATE), '886 Elm', 'California', 'Compton', '90223'),
        (042, 'heather.turner@yahoo.com', 'Heather', 'Turner', CAST('1974-09-11' AS DATE), '909 Twelfth', 'California', 'Paramount', '90723'),
        (043, 'howard.bailey@gmail.com', 'Howard', 'Bailey', CAST('1995-11-13' AS DATE), '1000 Adams', 'California', 'View Park-Windsor Hills', '90056'),
        (044, 'irene.mendoza@gmail.com', 'Irene', 'Mendoza', CAST('1985-11-23' AS DATE), '84 Elm', 'California', 'Florence-Graham', '90052'),
        (045, 'jacqueline.phillips@gmail.com', 'Jacqueline', 'Phillips', NULL, '519 Johnson', 'California', 'Long Beach', '90853'),
        (046, 'james.ramos@hotmail.com', 'James', 'Ramos', CAST('1962-08-07' AS DATE), '968 Cherry', 'California', 'Carson', '90745'),
        (047, 'janet.evans@gmail.com', 'Janet', 'Evans', CAST('1980-12-07' AS DATE), '519 Oak', 'California', 'Lakewood', '90711'),
        (048, 'jeffrey.mez@gmail.com', 'Jeffrey', 'mez', CAST('1961-04-17' AS DATE), '51 Cedar', 'California', 'Whittier', '90603'),
        (049, 'jerry.cox@icloud.com', 'Jerry', 'Cox', CAST('1958-04-04' AS DATE), '353 Johnson', 'California', 'South Whittier', '90605'),
        (050, 'jerry.mitchell@icloud.com', 'Jerry', 'Mitchell', CAST('1981-09-22' AS DATE), '732 Johnson', 'California', 'South Whittier', '90605'),
        (051, 'jesse.cox@yahoo.com', 'Jesse', 'Cox', CAST('1990-07-26' AS DATE), '544 North', 'California', 'South Gate', '90280'),
        (052, 'jesse.myers@gmail.com', 'Jesse', 'Myers', CAST('1975-02-14' AS DATE), '684 North', 'California', 'South Gate', '90280'),
        (053, 'jessica.ward@icloud.com', 'Jessica', 'Ward', CAST('1953-11-28' AS DATE), '515 West', 'California', 'Downey', '90242'),
        (054, 'jimmy.jones@yahoo.com', 'Jimmy', 'Jones', NULL, '226 Fourth', 'California', 'Inglewood', '90303'),
        (055, 'joan.cooper@icloud.com', 'Joan', 'Cooper', CAST('1986-04-03' AS DATE), '173 West', 'California', 'Compton', '90221'),
        (056, 'jonathan.mez@hotmail.com', 'Jonathan', 'mez', CAST('1989-07-09' AS DATE), '319 Johnson', 'California', 'Los Angeles', '90069'),
        (057, 'joyce.nzalez@hotmail.com', 'Joyce', 'nzalez', CAST('1970-07-02' AS DATE), '204 Cedar', 'California', 'View Park-Windsor Hills', '90043'),
        (058, 'julia.flores@yahoo.com', 'Julia', 'Flores', CAST('1988-01-12' AS DATE), '442 Lake view', 'California', 'Bell Gardens', '90201'),
        (059, 'julie.adams@gmail.com', 'Julie', 'Adams', CAST('1957-01-31' AS DATE), '133 Hill', 'California', 'Gardena', '90247'),
        (060, 'julie.price@icloud.com', 'Julie', 'Price', CAST('1962-11-29' AS DATE), '2 Hill', 'California', 'Gardena', '90247'),
        (061, 'justin.ruiz@hotmail.com', 'Justin', 'Ruiz', CAST('1991-07-13' AS DATE), '157 Church', 'California', 'Gardena', '90247'),
        (062, 'justin.sanchez@yahoo.com', 'Justin', 'Sanchez', CAST('1992-02-03' AS DATE), '415 Church', 'California', 'Gardena', '90247'),
        (063, 'karen.smith@icloud.com', 'Karen', 'Smith', CAST('1948-03-01' AS DATE), '110 North', 'California', 'West Rancho Dominguez', '90220'),
        (064, 'katherine.murphy@gmail.com', 'Katherine', 'Murphy', CAST('1957-05-15' AS DATE), '191 Lincoln', 'California', 'Commerce', '90022'),
        (065, 'katherine.price@gmail.com', 'Katherine', 'Price', CAST('1997-09-23' AS DATE), '949 Lincoln', 'California', 'Commerce', '90022'),
        (066, 'kathryn.lopez@icloud.com', 'Kathryn', 'Lopez', CAST('1990-08-30' AS DATE), '622 Madison', 'California', 'Los Angeles', '90034'),
        (067, 'kathy.thomas@gmail.com', 'Kathy', 'Thomas', CAST('1952-04-08' AS DATE), '427 Main', 'California', 'Lakewood', '90712'),
        (068, 'kelly.allen@hotmail.com', 'Kelly', 'Allen', NULL, '651 Hickory', 'California', 'Long Beach', '90840'),
        (069, 'kevin.diaz@hotmail.com', 'Kevin', 'Diaz', CAST('1974-01-18' AS DATE), '262 Jackson', 'California', 'Torrance', '90509'),
        (070, 'kimberly.morgan@gmail.com', 'Kimberly', 'Morgan', CAST('1956-01-29' AS DATE), '2 Washington', 'California', 'Torrance', '90503'),
        (071, 'laura.young@gmail.com', 'Laura', 'Young', CAST('1987-05-19' AS DATE), '29 First', 'California', 'Torrance', '90503'),
        (072, 'linda.kelly@gmail.com', 'Linda', 'Kelly', CAST('1997-04-26' AS DATE), '51 Seventh', 'California', 'Compton', '90221'),
        (073, 'lisa.perez@icloud.com', 'Lisa', 'Perez', CAST('1949-08-08' AS DATE), '502 River', 'California', 'Hawthorne', '90310'),
        (074, 'lori.smith@icloud.com', 'Lori', 'Smith', CAST('1977-02-11' AS DATE), '324 Sixth', 'California', 'Signal Hill', '90755'),
        (075, 'margaret.campbell@hotmail.com', 'Margaret', 'Campbell', CAST('1960-11-03' AS DATE), '424 Eleventh', 'California', 'Los Angeles', '90247'),
        (076, 'margaret.hall@gmail.com', 'Margaret', 'Hall', CAST('1994-09-15' AS DATE), '344 Eleventh', 'California', 'Los Angeles', '90247'),
        (077, 'matthew.lopez@gmail.com', 'Matthew', 'Lopez', CAST('1988-02-15' AS DATE), '38 Dogwood', 'California', 'Torrance', '90510'),
        (078, 'matthew.ward@icloud.com', 'Matthew', 'Ward', CAST('1949-12-04' AS DATE), '240 Dogwood', 'California', 'Torrance', '90510'),
        (079, 'melissa.lopez@gmail.com', 'Melissa', 'Lopez', NULL, '43 Park', 'California', 'Bell Gardens', '90202'),
        (080, 'melissa.moore@icloud.com', 'Melissa', 'Moore', CAST('1960-06-27' AS DATE), '156 Park', 'California', 'Bell Gardens', '90202'),
        (081, 'mildred.gray@yahoo.com', 'Mildred', 'Gray', CAST('1949-03-23' AS DATE), '193 Sixth', 'California', 'Long Beach', '90847'),
        (082, 'nancy.howard@hotmail.com', 'Nancy', 'Howard', CAST('1970-03-15' AS DATE), '587 Hickory', 'California', 'Carson', '90224'),
        (083, 'nicholas.rivera@icloud.com', 'Nicholas', 'Rivera', CAST('1993-09-07' AS DATE), '129 Adams', 'California', 'Long Beach', '90853'),
        (084, 'nicole.evans@gmail.com', 'Nicole', 'Evans', CAST('1954-07-02' AS DATE), '608 Jefferson', 'California', 'Signal Hill', '90755'),
        (085, 'nicole.mendoza@gmail.com', 'Nicole', 'Mendoza', NULL, '76 Jefferson', 'California', 'Signal Hill', '90755'),
        (086, 'patricia.wright@icloud.com', 'Patricia', 'Wright', CAST('1953-07-18' AS DATE), '486 Chestnut', 'California', 'Santa Fe Springs', '90670'),
        (087, 'patrick.hughes@animalshelter.com', 'Patrick', 'Hughes', CAST('1988-10-11' AS DATE), '660 Spruce', 'California', 'La Mirada', '90638'),
        (088, 'peter.smith@hotmail.com', 'Peter', 'Smith', CAST('1986-08-27' AS DATE), '56 Main', 'California', 'Los Angeles', '90004'),
        (089, 'phyllis.davis@icloud.com', 'Phyllis', 'Davis', CAST('1993-10-20' AS DATE), '508 Eighth', 'California', 'Santa Monica', '90408'),
        (090, 'phyllis.moore@gmail.com', 'Phyllis', 'Moore', CAST('1988-09-22' AS DATE), '583 Eighth', 'California', 'Santa Monica', '90408'),
        (091, 'randy.bailey@icloud.com', 'Randy', 'Bailey', CAST('1973-07-13' AS DATE), '980 Oak', 'California', 'Compton', '90223'),
        (092, 'richard.castillo@icloud.com', 'Richard', 'Castillo', CAST('1978-12-26' AS DATE), '287 River', 'California', 'Culver City', '90233'),
        (093, 'robin.miller@yahoo.com', 'Robin', 'Miller', CAST('1965-12-11' AS DATE), '216 Hill', 'California', 'East Los Angeles', '90022'),
        (094, 'robin.murphy@animalshelter.com', 'Robin', 'Murphy', CAST('1974-10-13' AS DATE), '673 Hill', 'California', 'East Los Angeles', '90022'),
        (095, 'roger.adams@hotmail.com', 'Roger', 'Adams', CAST('1947-05-09' AS DATE), '639 West', 'California', 'Los Angeles', '90031'),
        (096, 'roy.rogers@hotmail.com', 'Roy', 'Rogers', CAST('1958-07-29' AS DATE), '836 Twelfth', 'California', 'Los Angeles', '90039'),
        (097, 'ruby.lopez@yahoo.com', 'Ruby', 'Lopez', CAST('1979-04-05' AS DATE), '808 Cedar', 'California', 'Long Beach', '90804'),
        (098, 'ryan.garcia@hotmail.com', 'Ryan', 'Garcia', CAST('1975-03-09' AS DATE), '787 Wilson', 'California', 'Downey', '90239'),
        (099, 'ryan.hill@icloud.com', 'Ryan', 'Hill', CAST('1960-11-03' AS DATE), '105 Wilson', 'California', 'Downey', '90239'),
        (100, 'ryan.jackson@icloud.com', 'Ryan', 'Jackson', CAST('1947-10-07' AS DATE), '487 Wilson', 'California', 'Downey', '90239'),
        (101, 'ryan.wright@hotmail.com', 'Ryan', 'Wright', NULL, '600 Wilson', 'California', 'Downey', '90239'),
        (102, 'samuel.baker@gmail.com', 'Samuel', 'Baker', CAST('1980-01-17' AS DATE), '889 Maple', 'California', 'Los Angeles', '90247'),
        (103, 'samuel.morales@icloud.com', 'Samuel', 'Morales', NULL, '896 Maple', 'California', 'Los Angeles', '90247'),
        (104, 'sara.nelson@icloud.com', 'Sara', 'Nelson', CAST('1990-10-15' AS DATE), '340 Fifth', 'California', 'View Park-Windsor Hills', '90043'),
        (105, 'scott.baker@gmail.com', 'Scott', 'Baker', CAST('1986-01-11' AS DATE), '190 Lake view', 'California', 'Los Angeles', '90089'),
        (106, 'scott.gutierrez@gmail.com', 'Scott', 'Gutierrez', CAST('1985-11-26' AS DATE), '993 Lake view', 'California', 'Los Angeles', '90089'),
        (107, 'sean.nelson@icloud.com', 'Sean', 'Nelson', CAST('1986-04-28' AS DATE), '339 Ninth', 'California', 'Los Angeles', '90034'),
        (108, 'sharon.davis@animalshelter.com', 'Sharon', 'Davis', CAST('1988-09-25' AS DATE), '372 Seventh', 'California', 'Los Angeles', '90068'),
        (109, 'sharon.thompson@gmail.com', 'Sharon', 'Thompson', CAST('1970-06-24' AS DATE), '688 Seventh', 'California', 'Los Angeles', '90068'),
        (110, 'shirley.williams@outlook.com', 'Shirley', 'Williams', CAST('1966-08-17' AS DATE), '11 Lincoln', 'California', 'Santa Monica', '90408'),
        (111, 'stephanie.mez@icloud.com', 'Stephanie', 'mez', CAST('1994-06-26' AS DATE), '539 West', 'California', 'Long Beach', '90899'),
        (112, 'susan.murphy@icloud.com', 'Susan', 'Murphy', CAST('1961-08-02' AS DATE), '246 Spruce', 'California', 'Long Beach', '90808'),
        (113, 'theresa.carter@icloud.com', 'Theresa', 'Carter', CAST('1968-08-27' AS DATE), '401 Lincoln', 'California', 'Long Beach', '90831'),
        (114, 'timothy.anderson@gmail.com', 'Timothy', 'Anderson', CAST('1973-05-08' AS DATE), '33 Seventh', 'California', 'Commerce', '90023'),
        (115, 'virginia.baker@gmail.com', 'Virginia', 'Baker', CAST('1990-11-25' AS DATE), '6 Jefferson', 'California', 'Santa Monica', '90410'),
        (116, 'walter.edwards@icloud.com', 'Walter', 'Edwards', CAST('1963-09-04' AS DATE), '137 Church', 'California', 'Pico Rivera', '90661'),
        (117, 'wanda.gray@icloud.com', 'Wanda', 'Gray', CAST('1963-03-18' AS DATE), '946 Cedar', 'California', 'Los Angeles', '90710'),
        (118, 'wanda.myers@animalshelter.com', 'Wanda', 'Myers', CAST('1975-02-05' AS DATE), '663 Cedar', 'California', 'Los Angeles', '90710'),
        (119, 'wayne.carter@animalshelter.com', 'Wayne', 'Carter', CAST('1988-03-15' AS DATE), '341 Washington', 'California', 'Inglewood', '90309'),
        (120, 'wayne.turner@icloud.com', 'Wayne', 'Turner', CAST('1966-02-18' AS DATE), '350 Washington', 'California', 'Inglewood', '90309');

    SET @Message = 'Completed CREATE TABLE Shelter.Person.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.Staff.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.Staff') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.Staff already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.Staff
    (
        PersonID TINYINT NOT NUll,
        HireDate DATE NOT NULL,
        CONSTRAINT PK_Staff_PersonID PRIMARY KEY CLUSTERED (PersonID)
    );
    INSERT INTO	Shelter.Staff
        (PersonID, HireDate)
    VALUES
        (007, CAST('2016-01-01' AS DATE)),
        (020, CAST('2018-10-07' AS DATE)),
        (029, CAST('2016-01-01' AS DATE)),
        (035, CAST('2018-03-20' AS DATE)),
        (087, CAST('2018-12-15' AS DATE)),
        (094, CAST('2018-08-15' AS DATE)),
        (108, CAST('2016-01-01' AS DATE)),
        (118, CAST('2016-01-01' AS DATE)),
        (119, CAST('2018-04-02' AS DATE));

    SET @Message = 'Completed CREATE TABLE Shelter.Staff.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.Vaccine.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.Vaccine') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.Vaccine already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.Vaccine
    (
        AnimalID TINYINT NOT NULL,
        PersonID TINYINT NOT NULL,
        Name VARCHAR(50) NOT NULL,
        Batch VARCHAR(20) NOT NULL,
        Time DATETIME2(7) NOT NULL,
        Comments VARCHAR(500) NULL,
        CONSTRAINT PK_Vaccine_AnimalID_Name_Time PRIMARY KEY CLUSTERED (AnimalID, Name, Time)
    );
    INSERT INTO	Shelter.Vaccine
        (AnimalID, PersonID, Name, Batch, Time, Comments)
    VALUES
        (001, 007, 'Distemper Virus', 'N-178784096', CAST('2017-04-19T09:01:00.0000000' AS DATETIME2), NULL),
        (001, 118, 'Distemper Virus', 'L-107687717', CAST('2018-04-19T10:44:00.0000000' AS DATETIME2), NULL),
        (003, 118, 'Distemper Virus', 'L-353180534', CAST('2017-05-04T10:38:00.0000000' AS DATETIME2), NULL),
        (003, 118, 'Distemper Virus', 'A-271237673', CAST('2018-05-04T09:47:00.0000000' AS DATETIME2), NULL),
        (003, 118, 'Rabies', 'V-180603107', CAST('2017-05-04T12:49:00.0000000' AS DATETIME2), NULL),
        (003, 007, 'Rabies', 'P-118670651', CAST('2018-05-04T11:18:00.0000000' AS DATETIME2), NULL),
        (005, 007, 'Calicivirus', 'J-460970834', CAST('2017-11-20T09:35:00.0000000' AS DATETIME2), NULL),
        (005, 007, 'Panleukopenia Virus', 'F-164759480', CAST('2017-11-20T09:35:00.0000000' AS DATETIME2), NULL),
        (007, 118, 'Adenovirus', 'M-471677500', CAST('2016-09-28T07:36:00.0000000' AS DATETIME2), NULL),
        (007, 118, 'Adenovirus', 'V-256362103', CAST('2017-09-29T12:35:00.0000000' AS DATETIME2), NULL),
        (007, 007, 'Distemper Virus', 'N-147820695', CAST('2016-09-28T10:01:00.0000000' AS DATETIME2), NULL),
        (007, 118, 'Rabies', 'K-430117096', CAST('2016-09-28T07:41:00.0000000' AS DATETIME2), NULL),
        (007, 007, 'Rabies', 'B-384980558', CAST('2017-09-29T07:32:00.0000000' AS DATETIME2), NULL),
        (009, 118, 'Rabies', 'V-411899194', CAST('2016-09-01T07:00:00.0000000' AS DATETIME2), NULL),
        (012, 007, 'Adenovirus', 'D-237655965', CAST('2019-01-02T09:44:00.0000000' AS DATETIME2), NULL),
        (012, 094, 'Rabies', 'H-405534627', CAST('2019-01-02T13:19:00.0000000' AS DATETIME2), NULL),
        (014, 020, 'Myxomatosis', 'I-176340730', CAST('2018-12-27T13:39:00.0000000' AS DATETIME2), NULL),
        (014, 007, 'Myxomatosis', 'O-237649828', CAST('2019-12-27T13:32:00.0000000' AS DATETIME2), NULL),
        (014, 118, 'Rabies', 'N-100666243', CAST('2016-12-26T12:08:00.0000000' AS DATETIME2), NULL),
        (014, 118, 'Rabies', 'Z-365201947', CAST('2017-12-27T10:09:00.0000000' AS DATETIME2), NULL),
        (014, 094, 'Rabies', 'O-282699517', CAST('2018-12-27T11:09:00.0000000' AS DATETIME2), NULL),
        (014, 035, 'Rabies', 'C-219506249', CAST('2019-12-27T09:23:00.0000000' AS DATETIME2), NULL),
        (015, 035, 'Rabies', 'D-353567999', CAST('2019-09-03T11:58:00.0000000' AS DATETIME2), NULL),
        (017, 118, 'Adenovirus', 'K-99075733', CAST('2018-11-28T12:26:00.0000000' AS DATETIME2), NULL),
        (017, 119, 'Distemper Virus', 'U-104436672', CAST('2018-11-28T07:17:00.0000000' AS DATETIME2), NULL),
        (024, 007, 'Distemper Virus', 'K-334308175', CAST('2017-10-13T09:41:00.0000000' AS DATETIME2), NULL),
        (026, 007, 'Adenovirus', 'F-202325284', CAST('2018-09-27T08:16:00.0000000' AS DATETIME2), NULL),
        (026, 119, 'Adenovirus', 'O-402995062', CAST('2019-09-27T10:29:00.0000000' AS DATETIME2), NULL),
        (026, 094, 'Rabies', 'T-302536393', CAST('2018-09-27T14:45:00.0000000' AS DATETIME2), NULL),
        (028, 118, 'Calicivirus', 'C-259489422', CAST('2017-12-18T11:15:00.0000000' AS DATETIME2), NULL),
        (028, 118, 'Panleukopenia Virus', 'Y-412311976', CAST('2017-12-18T14:17:00.0000000' AS DATETIME2), NULL),
        (031, 118, 'Adenovirus', 'B-141623834', CAST('2017-03-07T08:33:00.0000000' AS DATETIME2), NULL),
        (032, 119, 'Distemper Virus', 'H-384444123', CAST('2019-08-22T08:52:00.0000000' AS DATETIME2), NULL),
        (035, 007, 'Panleukopenia Virus', 'X-224232315', CAST('2016-12-26T12:54:00.0000000' AS DATETIME2), NULL),
        (036, 094, 'Rabies', 'D-117727724', CAST('2019-07-15T13:14:00.0000000' AS DATETIME2), NULL),
        (038, 035, 'Myxomatosis', 'H-250858054', CAST('2018-08-28T08:09:00.0000000' AS DATETIME2), NULL),
        (038, 094, 'Rabies', 'U-255625602', CAST('2018-08-28T09:41:00.0000000' AS DATETIME2), NULL),
        (038, 035, 'Viral Haemorrhagic Disease', 'I-404631209', CAST('2018-08-28T10:08:00.0000000' AS DATETIME2), NULL),
        (040, 118, 'Adenovirus', 'T-332043529', CAST('2017-12-08T07:46:00.0000000' AS DATETIME2), NULL),
        (048, 007, 'Distemper Virus', 'L-258258441', CAST('2018-05-22T07:46:00.0000000' AS DATETIME2), NULL),
        (051, 119, 'Adenovirus', 'O-245391721', CAST('2019-09-03T13:30:00.0000000' AS DATETIME2), NULL),
        (058, 020, 'Calicivirus', 'I-259629161', CAST('2019-08-09T09:13:00.0000000' AS DATETIME2), NULL),
        (058, 035, 'Panleukopenia Virus', 'Y-383139393', CAST('2019-08-09T09:00:00.0000000' AS DATETIME2), NULL),
        (060, 007, 'Adenovirus', 'S-115426515', CAST('2019-07-26T13:15:00.0000000' AS DATETIME2), NULL),
        (061, 007, 'Leukemia Virus', 'E-489987614', CAST('2018-08-13T14:32:00.0000000' AS DATETIME2), NULL),
        (061, 007, 'Rabies', 'C-386537135', CAST('2018-08-13T11:35:00.0000000' AS DATETIME2), NULL),
        (062, 094, 'Adenovirus', 'Z-490194302', CAST('2019-10-25T14:02:00.0000000' AS DATETIME2), NULL),
        (062, 007, 'Rabies', 'N-322162073', CAST('2017-10-25T07:58:00.0000000' AS DATETIME2), NULL),
        (062, 119, 'Rabies', 'L-181928453', CAST('2019-10-25T09:11:00.0000000' AS DATETIME2), NULL),
        (063, 118, 'Herpesvirus', 'L-196623340', CAST('2018-03-22T07:15:00.0000000' AS DATETIME2), NULL),
        (063, 007, 'Panleukopenia Virus', 'S-427830689', CAST('2018-03-22T07:12:00.0000000' AS DATETIME2), NULL),
        (063, 007, 'Rabies', 'K-153175906', CAST('2018-03-22T13:19:00.0000000' AS DATETIME2), NULL),
        (065, 118, 'Leukemia Virus', 'H-151581256', CAST('2019-10-21T09:56:00.0000000' AS DATETIME2), NULL),
        (068, 118, 'Calicivirus', 'H-233459270', CAST('2017-12-22T08:29:00.0000000' AS DATETIME2), NULL),
        (068, 118, 'Rabies', 'T-245247914', CAST('2017-12-22T09:42:00.0000000' AS DATETIME2), NULL),
        (069, 007, 'Distemper Virus', 'M-466473114', CAST('2017-01-12T12:42:00.0000000' AS DATETIME2), NULL),
        (069, 007, 'Rabies', 'R-249697441', CAST('2017-01-12T14:39:00.0000000' AS DATETIME2), NULL),
        (069, 007, 'Rabies', 'G-252982705', CAST('2018-01-12T08:20:00.0000000' AS DATETIME2), NULL),
        (072, 094, 'Rabies', 'W-142526378', CAST('2018-12-17T09:34:00.0000000' AS DATETIME2), NULL),
        (074, 035, 'Herpesvirus', 'R-266824458', CAST('2019-08-07T11:03:00.0000000' AS DATETIME2), NULL),
        (074, 094, 'Rabies', 'C-414219200', CAST('2019-08-07T09:09:00.0000000' AS DATETIME2), NULL),
        (075, 007, 'Adenovirus', 'P-300099414', CAST('2018-11-28T11:39:00.0000000' AS DATETIME2), NULL),
        (075, 007, 'Distemper Virus', 'W-358599750', CAST('2017-11-28T11:59:00.0000000' AS DATETIME2), NULL),
        (075, 118, 'Distemper Virus', 'K-483728872', CAST('2018-11-28T07:27:00.0000000' AS DATETIME2), NULL),
        (076, 035, 'Distemper Virus', 'S-337547458', CAST('2018-11-14T11:49:00.0000000' AS DATETIME2), NULL),
        (079, 007, 'Adenovirus', 'Q-206330713', CAST('2019-01-04T07:55:00.0000000' AS DATETIME2), NULL),
        (079, 020, 'Distemper Virus', 'P-281685593', CAST('2019-01-04T12:58:00.0000000' AS DATETIME2), NULL),
        (081, 007, 'Panleukopenia Virus', 'C-229285711', CAST('2016-10-06T07:02:00.0000000' AS DATETIME2), NULL),
        (083, 118, 'Herpesvirus', 'W-462716953', CAST('2018-11-09T13:46:00.0000000' AS DATETIME2), NULL),
        (084, 118, 'Adenovirus', 'Q-336566517', CAST('2018-07-06T12:29:00.0000000' AS DATETIME2), NULL),
        (084, 007, 'Distemper Virus', 'H-245193858', CAST('2018-07-06T10:58:00.0000000' AS DATETIME2), NULL),
        (085, 035, 'Distemper Virus', 'R-497123324', CAST('2019-11-15T10:11:00.0000000' AS DATETIME2), NULL),
        (086, 118, 'Distemper Virus', 'T-135880561', CAST('2016-12-29T08:43:00.0000000' AS DATETIME2), NULL),
        (087, 007, 'Adenovirus', 'L-438221809', CAST('2016-04-18T14:04:00.0000000' AS DATETIME2), NULL),
        (087, 118, 'Adenovirus', 'U-447076076', CAST('2017-04-19T13:33:00.0000000' AS DATETIME2), NULL),
        (088, 035, 'Calicivirus', 'Q-478638360', CAST('2018-05-30T14:15:00.0000000' AS DATETIME2), NULL),
        (089, 007, 'Distemper Virus', 'E-236843325', CAST('2016-08-10T10:51:00.0000000' AS DATETIME2), NULL),
        (089, 118, 'Rabies', 'A-171447806', CAST('2016-08-10T09:53:00.0000000' AS DATETIME2), NULL),
        (091, 007, 'Adenovirus', 'K-380962117', CAST('2018-01-03T08:20:00.0000000' AS DATETIME2), NULL),
        (092, 119, 'Leukemia Virus', 'N-431089273', CAST('2019-05-09T07:25:00.0000000' AS DATETIME2), NULL),
        (092, 118, 'Rabies', 'Z-112256475', CAST('2019-05-09T12:27:00.0000000' AS DATETIME2), NULL),
        (093, 007, 'Adenovirus', 'U-127749818', CAST('2017-03-22T11:45:00.0000000' AS DATETIME2), NULL),
        (093, 118, 'Adenovirus', 'M-229481627', CAST('2019-03-22T14:24:00.0000000' AS DATETIME2), NULL),
        (093, 007, 'Distemper Virus', 'I-370298118', CAST('2017-03-22T09:58:00.0000000' AS DATETIME2), NULL),
        (093, 020, 'Distemper Virus', 'A-455989697', CAST('2019-03-22T07:15:00.0000000' AS DATETIME2), NULL),
        (094, 007, 'Leukemia Virus', 'F-321237388', CAST('2018-01-04T13:28:00.0000000' AS DATETIME2), NULL),
        (094, 035, 'Leukemia Virus', 'P-236394443', CAST('2019-01-04T11:15:00.0000000' AS DATETIME2), NULL),
        (094, 118, 'Panleukopenia Virus', 'R-191602716', CAST('2017-01-04T14:52:00.0000000' AS DATETIME2), NULL),
        (094, 020, 'Panleukopenia Virus', 'T-370701265', CAST('2019-01-04T08:49:00.0000000' AS DATETIME2), NULL),
        (094, 007, 'Rabies', 'L-382821941', CAST('2018-01-04T10:27:00.0000000' AS DATETIME2), NULL),
        (094, 094, 'Rabies', 'V-177428557', CAST('2019-01-04T09:08:00.0000000' AS DATETIME2), NULL),
        (099, 007, 'Distemper Virus', 'B-226925017', CAST('2018-08-27T11:10:00.0000000' AS DATETIME2), NULL),
        (099, 119, 'Distemper Virus', 'X-480746334', CAST('2019-08-27T12:32:00.0000000' AS DATETIME2), NULL),
        (099, 094, 'Rabies', 'O-242396268', CAST('2018-08-27T14:21:00.0000000' AS DATETIME2), NULL),
        (099, 094, 'Rabies', 'L-366676246', CAST('2019-08-27T09:03:00.0000000' AS DATETIME2), NULL);


    SET @Message = 'Completed CREATE TABLE Shelter.Vaccine.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.StaffRole.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.StaffRole') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.StaffRole already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.StaffRole
    (
        RoleID TINYINT NOT NUll,
        Role NVARCHAR(20) NOT NULL,
        CONSTRAINT PK_StaffRole_RoleID PRIMARY KEY CLUSTERED (RoleID)

    );
    INSERT INTO	Shelter.StaffRole
        (RoleID, Role)
    VALUES
        (01, 'Assistant'),
        (02, 'Janitor'),
        (03, 'Manager'),
        (04, 'Receptionist'),
        (05, 'Veterinarian');

    SET @Message = 'Completed CREATE TABLE Shelter.StaffRole.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.StaffTask.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.StaffTask') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.StaffTask already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.StaffTask
    (
        PersonID TINYINT NOT NUll,
        RoleID TINYINT NOT NUll,
        TaskDate DATE NOT NULL,
        CONSTRAINT PK_StaffTask_PersonID PRIMARY KEY CLUSTERED (PersonID, RoleID)

    );
    INSERT INTO	Shelter.StaffTask
        (PersonID, RoleID, TaskDate)
    VALUES
        (007, 05, CAST('2016-01-01' AS DATE)),
        (020, 05, CAST('2018-10-07' AS DATE)),
        (029, 04, CAST('2016-01-01' AS DATE)),
        (035, 01, CAST('2018-03-20' AS DATE)),
        (087, 04, CAST('2018-12-15' AS DATE)),
        (094, 01, CAST('2018-08-15' AS DATE)),
        (108, 03, CAST('2016-01-01' AS DATE)),
        (118, 01, CAST('2016-01-01' AS DATE)),
        (119, 01, CAST('2018-04-02' AS DATE));


    SET @Message = 'Completed CREATE TABLE Shelter.StaffTask.';
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table Shelter.Adoption.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'Shelter.Adoption') AND type in (N'U'))
BEGIN
    SET @Message = 'Table Shelter.Adoption already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN

    CREATE TABLE Shelter.Adoption
    (
        AnimalID TINYINT NOT NULL,
        PersonID TINYINT NOT NULL,
        Date DATE NOT NULL,
        Fee MONEY NOT NULL,
        CONSTRAINT PK_Adoption_AnimalID_PersonID PRIMARY KEY CLUSTERED (AnimalID, PersonID)

    );
    INSERT INTO	Shelter.Adoption
        (AnimalID, PersonID, Date, Fee)
    VALUES
        (001, 087, CAST('2018-08-30' AS DATE), 58),
        (002, 061, CAST('2019-10-26' AS DATE), 68),
        (005, 087, CAST('2018-08-30' AS DATE), 82),
        (008, 120, CAST('2019-07-26' AS DATE), 50),
        (009, 051, CAST('2017-12-16' AS DATE), 58),
        (010, 110, CAST('2018-04-15' AS DATE), 90),
        (011, 108, CAST('2018-11-18' AS DATE), 97),
        (016, 034, CAST('2019-02-21' AS DATE), 83),
        (017, 115, CAST('2019-01-28' AS DATE), 66),
        (018, 063, CAST('2019-09-27' AS DATE), 73),
        (019, 088, CAST('2018-09-06' AS DATE), 57),
        (021, 074, CAST('2019-12-29' AS DATE), 86),
        (022, 001, CAST('2018-05-27' AS DATE), 65),
        (023, 079, CAST('2019-12-15' AS DATE), 56),
        (024, 073, CAST('2018-01-10' AS DATE), 61),
        (025, 021, CAST('2019-06-16' AS DATE), 100),
        (026, 071, CAST('2019-12-30' AS DATE), 93),
        (027, 080, CAST('2019-12-28' AS DATE), 76),
        (028, 050, CAST('2018-02-23' AS DATE), 96),
        (030, 069, CAST('2018-09-13' AS DATE), 97),
        (031, 059, CAST('2017-03-07' AS DATE), 79),
        (032, 074, CAST('2019-12-26' AS DATE), 54),
        (033, 035, CAST('2017-09-09' AS DATE), 82),
        (034, 028, CAST('2018-12-29' AS DATE), 96),
        (035, 114, CAST('2017-11-08' AS DATE), 73),
        (037, 067, CAST('2019-12-24' AS DATE), 57),
        (038, 068, CAST('2019-01-17' AS DATE), 85),
        (040, 110, CAST('2019-11-12' AS DATE), 84),
        (041, 120, CAST('2018-04-01' AS DATE), 85),
        (042, 046, CAST('2019-12-01' AS DATE), 87),
        (043, 017, CAST('2019-07-18' AS DATE), 57),
        (046, 115, CAST('2018-07-28' AS DATE), 54),
        (047, 081, CAST('2019-09-01' AS DATE), 99),
        (048, 092, CAST('2018-07-07' AS DATE), 78),
        (049, 098, CAST('2018-05-04' AS DATE), 65),
        (052, 101, CAST('2019-04-14' AS DATE), 55),
        (053, 091, CAST('2018-06-12' AS DATE), 51),
        (054, 113, CAST('2017-09-18' AS DATE), 87),
        (055, 096, CAST('2017-09-23' AS DATE), 62),
        (056, 092, CAST('2018-05-21' AS DATE), 98),
        (057, 004, CAST('2019-11-11' AS DATE), 83),
        (058, 029, CAST('2019-12-13' AS DATE), 86),
        (059, 095, CAST('2019-07-22' AS DATE), 93),
        (060, 120, CAST('2019-07-26' AS DATE), 77),
        (061, 116, CAST('2018-09-03' AS DATE), 98),
        (063, 012, CAST('2018-11-19' AS DATE), 79),
        (064, 023, CAST('2019-08-02' AS DATE), 51),
        (066, 092, CAST('2019-03-21' AS DATE), 83),
        (067, 023, CAST('2019-10-13' AS DATE), 94),
        (068, 025, CAST('2018-06-02' AS DATE), 54),
        (069, 115, CAST('2018-10-22' AS DATE), 54),
        (070, 096, CAST('2017-04-08' AS DATE), 66),
        (071, 075, CAST('2016-06-16' AS DATE), 61),
        (072, 090, CAST('2019-03-15' AS DATE), 93),
        (073, 115, CAST('2018-03-13' AS DATE), 95),
        (074, 106, CAST('2019-09-12' AS DATE), 64),
        (075, 017, CAST('2019-01-06' AS DATE), 61),
        (076, 051, CAST('2019-04-29' AS DATE), 61),
        (077, 104, CAST('2019-09-30' AS DATE), 54),
        (078, 086, CAST('2019-11-21' AS DATE), 60),
        (079, 059, CAST('2019-08-07' AS DATE), 86),
        (080, 045, CAST('2016-04-23' AS DATE), 50),
        (081, 056, CAST('2018-12-07' AS DATE), 85),
        (082, 011, CAST('2018-02-09' AS DATE), 55),
        (083, 028, CAST('2018-12-29' AS DATE), 51),
        (086, 120, CAST('2018-04-01' AS DATE), 73),
        (089, 050, CAST('2016-09-25' AS DATE), 67),
        (092, 034, CAST('2019-05-23' AS DATE), 96),
        (097, 090, CAST('2019-11-26' AS DATE), 96),
        (100, 075, CAST('2019-07-17' AS DATE), 75);

    SET @Message = 'Completed CREATE TABLE Shelter.Adoption.';
END
-------------------------------------------------------------------------------



SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));   
RAISERROR(@Message, 0,1) WITH NOWAIT;

END TRY

BEGIN CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

SET @ErrorText = 'Error: '+CONVERT(VARCHAR,ISNULL(ERROR_NUMBER(),'NULL'))      
                  +', Severity = '+CONVERT(VARCHAR,ISNULL(ERROR_SEVERITY(),'NULL'))      
                  +', State = '+CONVERT(VARCHAR,ISNULL(ERROR_STATE(),'NULL'))      
                  +', Line = '+CONVERT(VARCHAR,ISNULL(ERROR_LINE(),'NULL'))      
                  +', Procedure = '+CONVERT(VARCHAR,ISNULL(ERROR_PROCEDURE(),'NULL'))      
                  +', Server Error Message = '+CONVERT(VARCHAR(100),ISNULL(ERROR_MESSAGE(),'NULL'))      
                  +', SP Defined Error Text = '+@ErrorText;

RAISERROR(@ErrorText,18,127) WITH NOWAIT;
END CATCH;      

