CREATE DATABASE GroupsApp
use GroupsApp
CREATE TABLE Groups(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL,
Limit INT NOT NULL,
BeginDate DATE NOT NULL,
EndDate DATE NOT NULL
)
CREATE TABLE Students(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL,
Email NVARCHAR(50) DEFAULT 'example@gmail.com',
PhoneNumber NVARCHAR(50) DEFAULT '+994xxxxxxxxx',
BirthDate DATE NOT NULL,
Gpa DECIMAL(3,2) NOT NULL,
GroupId INT FOREIGN KEY REFERENCES Groups(Id)
)

CREATE TRIGGER trg_AddStudentWithLimitation
ON Students
AFTER INSERT
AS
BEGIN
SELECT Groups.Name AS 'Group Name', Students.Name AS 'Student Name', Students.Surname AS 'Student Surname' FROM Students
JOIN Groups ON Students.GroupId = Groups.Id;
END

CREATE TRIGGER trg_AddStudentsWithAge
ON Students
AFTER INSERT
AS
BEGIN
DECLARE @Age INT
SELECT @Age = 'Current_Date' - 'BirthDate FROM inserted';
IF @Age < 16
BEGIN
THROW 51000, 'Not allowed', 1;
END
ELSE
BEGIN
SELECT Name, Surname, GroupId FROM inserted
END

CREATE FUNCTION AverageGpaFunction (@GroupId INT)
RETURNS DECIMAL
AS
BEGIN
DECLARE @AvgGpa DECIMAL
SELECT @AvgGpa = AVG(Gpa) FROM Students 
WHERE Students.GroupId = @GroupId
RETURN @AvgGpa
END