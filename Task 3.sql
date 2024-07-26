CREATE DATABASE DepartmentsApp
use DepartmentsApp
CREATE TABLE Departments (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL
);
CREATE TABLE Positions (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL,
Limit INT NOT NULL
);
CREATE TABLE Workers (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) NOT NULL,
Surname NVARCHAR(50) NOT NULL,
PhoneNumber NVARCHAR(50) NOT NULL,
Salary DECIMAL(10, 2) NOT NULL,
BirthDate DATE NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
PositionId INT FOREIGN KEY REFERENCES Positions(Id)
);

CREATE FUNCTION GetAvgSalaryOfWorkers (@DepartmentId INT)
RETURNS DECIMAL
AS
BEGIN
DECLARE @Average DECIMAL
SELECT @Average = AVG(Salary) FROM Workers 
WHERE Workers.DepartmentId = @DepartmentId
RETURN @Average
END

CREATE TRIGGER trg_AddWorkersWithAge
ON Workers
AFTER INSERT
AS
BEGIN
DECLARE @Age INT
SELECT @Age = 'Current_Date' - 'BirthDate FROM inserted';
IF @Age < 18
BEGIN
THROW 51000, 'Not allowed', 1;
END
ELSE
BEGIN
SELECT Name, Surname, DepartmentId FROM inserted
END

