SELECT 'Hello World!';

SELECT *
FROM Shelter.Person;

SELECT 'SQL is Fun!' AS Fact
FROM Shelter.Person;

-- Notice use of NULL, use only IS ans IS NOT 
SELECT *
FROM Shelter.Animal
WHERE	Breed = NULL;

SELECT *
FROM Shelter.Animal
WHERE	Breed <> NULL;

SELECT *
FROM Shelter.Animal
WHERE	Breed = NULL
	OR
	Breed <> NULL;

SELECT *
FROM Shelter.Animal
WHERE	Breed = 'Bullmastiff'
	OR
	Breed <> 'Bullmastiff';

SELECT *
FROM Shelter.Animal
WHERE	Breed IS NULL;

SELECT *
FROM Shelter.Animal
WHERE	Breed IS NOT NULL;


SELECT *
FROM Shelter.Animal
WHERE	Breed <> 'Bullmastiff';

SELECT *
FROM Shelter.Animal
WHERE	Breed <> 'Bullmastiff'
	OR
	Breed IS NULL;

SELECT *
FROM Shelter.Animal
WHERE 	ISNULL(Breed, 'Some value') <> 'Bullmastiff';

-- Granular detail rows
SELECT *
FROM Shelter.Adoption;

-- How many were adopted?
SELECT COUNT(*) AS NumberOfAdoptions
FROM Shelter.Adoption;

-- But - beware!, Error
SELECT AnimalID,
	COUNT(*) AS NumberOfAdoptions
FROM Shelter.Adoption;

-- Granular detail rows
SELECT *
FROM Shelter.Vaccine;


-- Using ordinal positions
SELECT *
FROM Shelter.Animal
ORDER BY 2, 5, 1;

-- Order by
SELECT AD.Date AS AdoptionDate,
	AT.Name AS AnimalType,
	AN.Name AS AnimalName
FROM Shelter.Adoption AS AD
	INNER JOIN Shelter.Animal AS AN
	ON AD.AnimalID = AN.ANimalID
	INNER JOIN Shelter.AnimalTYpe AS AT
	ON AN.TypeID = AT.TypeID
ORDER BY AdoptionDate DESC;
-- (70 rows affected)

-- Paging
SELECT TOP(3)
	*
FROM Shelter.Animal;

SELECT TOP(3)
	*
FROM Shelter.Animal AS A
	INNER JOIN Shelter.AnimalColor AC
	ON A.ColorID = AC.ColorID
ORDER BY AC.Name;



