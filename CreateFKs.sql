
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
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Shelter.Vaccine.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'Shelter.FK_Vaccine_Animal_AnimalID')
  AND parent_object_id = OBJECT_ID(N'Shelter.Vaccine')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table Shelter.Vaccine already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE Shelter.Vaccine
   ADD CONSTRAINT FK_Vaccine_Animal_AnimalID FOREIGN KEY (AnimalID)
      REFERENCES Shelter.Animal (AnimalID),
      CONSTRAINT FK_Vaccine_Staff_PersonID FOREIGN KEY (PersonID)
      REFERENCES Shelter.Staff (PersonID);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE Shelter.Vaccine.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Shelter.Adoption.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'Shelter.FK_Adoption_Animal_AnimalID')
  AND parent_object_id = OBJECT_ID(N'Shelter.Adoption')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table Shelter.Adoption already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE Shelter.Adoption
   ADD CONSTRAINT FK_Adoption_Animal_AnimalID FOREIGN KEY (AnimalID)
      REFERENCES Shelter.Animal (AnimalID),
      CONSTRAINT FK_Adoption_Person_PersonID FOREIGN KEY (PersonID)
      REFERENCES Shelter.Person (PersonID);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE Shelter.Adoption.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Shelter.Animal.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'FK_Animal_AnimalType_TypeID')
  AND parent_object_id = OBJECT_ID(N'Shelter.Animal')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table Shelter.Animal already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE Shelter.Animal
   ADD CONSTRAINT FK_Animal_AnimalType_TypeID FOREIGN KEY (TypeID)
      REFERENCES Shelter.AnimalType (TypeID),
CONSTRAINT FK_Animal_AnimalColor_ColorID FOREIGN KEY (ColorID)
      REFERENCES Shelter.AnimalColor (ColorID);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE Shelter.Animal.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Shelter.StaffTask.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'FK_StaffTask_Task_PersonID')
  AND parent_object_id = OBJECT_ID(N'Shelter.StaffTask')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table Shelter.StaffTask already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE Shelter.StaffTask
   ADD CONSTRAINT FK_StaffTask_Task_PersonID FOREIGN KEY (PersonID)
      REFERENCES Shelter.Staff (PersonID),
CONSTRAINT FK_StaffTask_StaffRole_RoleID FOREIGN KEY (RoleID)
      REFERENCES Shelter.StaffRole (RoleID);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE Shelter.StaffTask.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table Shelter.Staff.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'FK_Staff_Person_PersonID')
  AND parent_object_id = OBJECT_ID(N'Shelter.Staff')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table Shelter.Staff already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE Shelter.Staff
   ADD CONSTRAINT FK_Staff_Person_PersonID FOREIGN KEY (PersonID)
      REFERENCES Shelter.Person (PersonID);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE Shelter.Staff.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
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

