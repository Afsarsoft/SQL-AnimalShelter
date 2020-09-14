SELECT COUNT(*)
FROM Shelter.Staff
--  9 

SELECT COUNT(*)
FROM Shelter.StaffRole
-- 5 

-- CROSS JOIN
SELECT *
FROM Shelter.Staff 
	CROSS JOIN 
	Shelter.StaffRole;
-- (45 rows affected)

SELECT 9 * 5
-- 45


-- INNER JOIN
SELECT *
FROM Shelter.Staff
	INNER JOIN
	Shelter.StaffRole
	ON 1 = 1;
-- (45 rows affected)

SELECT *
FROM Shelter.Animal AS A
		CROSS JOIN 
		Shelter.Adoption AS AD;
-- (7000 rows affected)

-- Show all animals adopted 
SELECT A.Name, A.Breed, AD.*
FROM Shelter.Animal AS A
	INNER JOIN
	Shelter.Adoption AS AD
	ON	A.AnimalID = AD.AnimalID;
-- (70 rows affected)

-- Show all animals adopted info regardless adopted or not V1
SELECT A.Name, A.Breed, AD.*
FROM Shelter.Animal AS A
	LEFT OUTER JOIN
	Shelter.Adoption AS AD
	ON	A.AnimalID = AD.AnimalID;
-- (100 rows affected)

-- Show all animals adopted info regardless adopted or not V2
SELECT AD.PersonID, AD.Date, A.*
FROM Shelter.Animal AS A
	LEFT OUTER JOIN
	Shelter.Adoption AS AD
	ON	A.AnimalID = AD.AnimalID;
-- (100 rows affected)

-- Show all animals adopted, more info 
SELECT P.FirstName, P.LastName, AN.Name AS AnimalName, AN.Breed, AD.Date AS AdoptionDate, AD.Fee AS AdoptionFee
FROM Shelter.Animal AS AN
	INNER JOIN
	Shelter.Adoption AS AD
	ON AD.AnimalID = AN.AnimalID
	INNER JOIN
	Shelter.Person AS P
	ON	AD.PersonID = P.PersonID;
-- (70 rows affected)

-- INNER JOIN for Person table not leting us to display all animals adopted info regardless adopted or not
SELECT P.FirstName, P.LastName, AN.Name AS AnimalName, AN.Breed, AD.Date AS AdoptionDate, AD.Fee AS AdoptionFee
FROM Shelter.Animal AS AN
	LEFT OUTER JOIN
	Shelter.Adoption AS AD
	ON AD.AnimalID = AN.AnimalID
	INNER JOIN
	Shelter.Person AS P
	ON	AD.PersonID = P.PersonID;
-- (70 rows affected)

-- By removing the INNER JOIN for Person table, we are able to display all animals adopted info regardless adopted or not
SELECT AN.Name AS AnimalName, AN.Breed, AD.Date AS AdoptionDate, AD.Fee AS AdoptionFee
FROM Shelter.Animal AS AN
	LEFT OUTER JOIN
	Shelter.Adoption AS AD
	ON AD.AnimalID = AN.AnimalID
-- (100 rows affected)

-- To get the info for Person table without loosing the animal rows we are doing LEFT JOIN for Person table
SELECT P.FirstName, P.LastName, AN.Name AS AnimalName, AN.Breed, AD.Date AS AdoptionDate, AD.Fee AS AdoptionFee
FROM Shelter.Animal AS AN
	LEFT OUTER JOIN
	Shelter.Adoption AS AD
	ON AD.AnimalID = AN.AnimalID
	LEFT OUTER JOIN
	Shelter.Person AS P
	ON	AD.PersonID = P.PersonID;
-- (100 rows affected)

-- We do not need LEFT JOIN between Adoption and Person, so imporve the performance, we can have it as follow:
SELECT P.FirstName, P.LastName, AN.Name AS AnimalName, AN.Breed, AD.Date AS AdoptionDate, AD.Fee AS AdoptionFee
FROM Shelter.Animal AS AN
	LEFT OUTER JOIN
	(
	Shelter.Adoption AS AD
	INNER JOIN
	Shelter.Person AS P
	ON	AD.PersonID = P.PersonID
	)
	ON AD.AnimalID = AN.AnimalID;
-- (100 rows affected)

-- We can have the above as follow as well 
SELECT P.FirstName, P.LastName, AN.Name AS AnimalName, AN.Breed, AD.Date AS AdoptionDate, AD.Fee AS AdoptionFee
FROM Shelter.Animal AS AN
	LEFT OUTER JOIN
	Shelter.Adoption AS AD
	INNER JOIN
	Shelter.Person AS P
	ON	AD.PersonID = P.PersonID
	ON AD.AnimalID = AN.AnimalID;
-- (100 rows affected)


/*
Animal vaccinations report.
---------------------------
Write a query to report all animals and their vaccinations.
Animals that have not been vaccinated should be included.
The report should include the following attributes:
Animal's name, species, breed, and primary color,
vaccination time and the vaccine name,
the staff member's first name, last name, and role.

Guidelines:
-----------
Use the minimal number of tables required.
Use the correct logical join types and force join order as needed.
*/
-- Frist cut
SELECT A.Name AS AnimalName,
	A.TypeID,
	A.ColorID,
	A.Breed,
	V.Time AS VaccineTime,
	V.Name,
	P.FirstName,
	P.LastName
FROM Shelter.Animal AS A
	LEFT OUTER JOIN
	(
	Shelter.Vaccine AS V
	INNER JOIN
	Shelter.Staff AS S
	ON S.PersonID = V.PersonID
	INNER JOIN
	Shelter.Person AS P
	ON P.PersonID = V.PersonID
	)
	ON	A.AnimalID = V.AnimalID
ORDER BY AnimalName, A.Breed, VaccineTime DESC;
-- (149 rows affected)

-- Complete one
SELECT A.Name AS AnimalName,
	AT.Name AS AnimalType,
	AC.Name AS AnimalColor,
	A.Breed,
	V.Time AS VaccineTime,
	V.Name,
	P.FirstName,
	P.LastName
FROM Shelter.Animal AS A
	LEFT OUTER JOIN
	(
	Shelter.Vaccine AS V
	INNER JOIN
	Shelter.Staff AS S
	ON S.PersonID = V.PersonID
	INNER JOIN
	Shelter.Person AS P
	ON P.PersonID = V.PersonID
	)
	ON	A.AnimalID = V.AnimalID
	INNER JOIN
	Shelter.AnimalType AS AT
	ON A.TypeID = AT.TypeID
	INNER JOIN
	Shelter.AnimalColor AS AC
	ON A.ColorID = AC.ColorID
ORDER BY AnimalName, A.Breed, VaccineTime DESC;
-- (149 rows affected)

-- Filtering some rows
SELECT A.AnimalID, A.Name, AT.Name AS AnmialType, A.Breed, A.Gender, A.BirthDate
FROM Shelter.Animal AS A
	INNER JOIN
	Shelter.AnimalType AT
	ON A.TypeID = AT.TypeID
WHERE	AT.Name = 'Dog'
	AND
	A.Breed <> 'Bullmastiff';
-- (15 rows affected)

-- Filtering some rows based on BirthDate
SELECT *
FROM Shelter.Person
WHERE	BirthDate <> '20000101';
-- (111 rows affected)

-- Number of vaccinations per animal
SELECT V.AnimalID, A.Name,
	COUNT(*) AS NumberOfVaccinations
FROM Shelter.Vaccine AS V
	INNER JOIN Shelter.Animal AS A
	ON V.AnimalID = A.AnimalID
GROUP BY V.AnimalID, A.Name;
-- (46 rows affected)

-- Count of animals per type and Breeds, not checking NULL for Breed
SELECT AT.Name AS AnimalType,
	A.Breed,
	COUNT(*) AS NumberOfAnimals
FROM Shelter.Animal AS A
	INNER JOIN Shelter.AnimalType AS AT
	ON A.TypeID = AT.TypeID
GROUP BY AT.Name, A.Breed;
-- (18 rows affected)

-- Count of animals per type and Breeds checking NULL for Breed
SELECT AT.Name AS AnimalType,
	A.Breed,
	COUNT(*) AS NumberOfAnimals
FROM Shelter.Animal AS A
	INNER JOIN Shelter.AnimalType AS AT
	ON A.TypeID = AT.TypeID
WHERE A.Breed IS NOT NULL
GROUP BY AT.Name, A.Breed;
-- (15 rows affected)

-- Dealing with Date
SELECT YEAR(BirthDate) AS YearBorn,
	COUNT(*) AS NumberOfPersons
FROM Shelter.Person
GROUP BY YEAR(BirthDate);

-- Dealing with Date
SELECT YEAR(CURRENT_TIMESTAMP) - YEAR(BirthDate) AS Age,
	COUNT(*) AS NumberOfPersons
FROM Shelter.Person
GROUP BY YEAR(BirthDate);

-- Dealing with Date
SELECT City,
	MIN(YEAR(CURRENT_TIMESTAMP) - YEAR(BirthDate)) AS YoungestPerson,
	MAX(YEAR(CURRENT_TIMESTAMP) - YEAR(BirthDate)) AS OldestPerson,
	COUNT(*) AS NumberOfPersons
FROM Shelter.Person
GROUP BY City;

-- Number of Adoptions per people 
SELECT P.FirstName, P.LastName, P.Email,
	COUNT(*) AS NumberOfAdoptions
FROM Shelter.Adoption AS A
	INNER JOIN Shelter.Person AS P
	ON A.PersonID = P.PersonID
GROUP BY P.FirstName, P.LastName, P.Email
ORDER BY NumberOfAdoptions DESC;
-- (49 rows affected)

-- Number of Adoptions per people with more than one
-- Error, need use of HAVING instead of WHERE 
SELECT P.FirstName, P.LastName, P.Email,
	COUNT(*) AS NumberOfAdoptions
FROM Shelter.Adoption AS A
	INNER JOIN Shelter.Person AS P
	ON A.PersonID = P.PersonID
WHERE	COUNT(*) > 1
GROUP BY P.FirstName, P.LastName, P.Email
ORDER BY NumberOfAdoptions DESC;

-- Number of Adoptions per people with more than one
SELECT P.FirstName, P.LastName, P.Email,
	COUNT(*) AS NumberOfAdoptions
FROM Shelter.Adoption AS A
	INNER JOIN Shelter.Person AS P
	ON A.PersonID = P.PersonID
GROUP BY P.FirstName, P.LastName, P.Email
HAVING	COUNT(*) > 1
ORDER BY NumberOfAdoptions DESC;
-- (16 rows affected)

-- Number of Adoptions per people with more than one with more filtering 
SELECT P.FirstName, P.LastName, P.Email,
	COUNT(*) AS NumberOfAdoptions
FROM Shelter.Adoption AS A
	INNER JOIN Shelter.Person AS P
	ON A.PersonID = P.PersonID
GROUP BY P.FirstName, P.LastName, P.Email
HAVING	COUNT(*) > 1
	AND P.Email NOT LIKE '%gmail.com'
ORDER BY NumberOfAdoptions DESC;
-- (12 rows affected)

-- Number of Adoptions per people with more than one with more filtering, better way 
SELECT P.FirstName, P.LastName, P.Email,
	COUNT(*) AS NumberOfAdoptions
FROM Shelter.Adoption AS A
	INNER JOIN Shelter.Person AS P
	ON A.PersonID = P.PersonID
WHERE P.Email NOT LIKE '%gmail.com'
GROUP BY P.FirstName, P.LastName, P.Email
HAVING	COUNT(*) > 1
ORDER BY NumberOfAdoptions DESC;
-- (12 rows affected)

/*
Animal vaccination report
--------------------------

Write a query to report the number of vaccinations each animal has received.
Include animals that were never adopted.
Exclude all rabbits.
Exclude all Rabies vaccinations.
Exclude all animals that were last vaccinated on or after October first, 2019.

The report should return the following attributes:
Animals Name, Species, Primary Color, Breed,
and the number of vaccinations this animal has received,

-- Guidelines
Use the correct logical join types and force order if needed.
Use the  correct logical group by expressions.
*/
SELECT A.Name AS AnimalName,
	AT.Name AS AnimalType,
	MAX(AC.Name) AS PrimaryColor, -- Dummy aggregate, functionally dependent.
	MAX(A.Breed) AS Breed, -- Dummy aggregate, functionally dependent.
	COUNT(V.Name) AS NumberOfVaccines
FROM Shelter.Animal AS A
	INNER JOIN Shelter.AnimalType AS AT
	ON A.TypeID = AT.TypeID
	INNER JOIN Shelter.AnimalColor AS AC
	ON A.ColorID = AC.ColorID
	LEFT OUTER JOIN
	Shelter.Vaccine AS V
	ON A.AnimalID = V.AnimalID
WHERE	AT.Name <> 'Rabbit'
	AND
	(V.Name <> 'Rabies' OR V.Name IS NULL)
GROUP BY	AT.Name,
			A.Name
HAVING	MAX(V.Time) < '20191001'
	OR
	MAX(V.Time) IS NULL
ORDER BY	AT.Name,
			A.Name;
-- (84 rows affected)
