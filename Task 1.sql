CREATE DATABASE MoviesApp
use MoviesApp
CREATE TABLE Directors (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50) ,
Surname NVARCHAR(50)
)
CREATE TABLE Actors (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50),
Surname NVARCHAR(50)
)
CREATE TABLE Genres (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50),
)
CREATE TABLE Languages (
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50),
)
CREATE TABLE Movies(
Id INT PRIMARY KEY IDENTITY(1,1),
Name NVARCHAR(50),
Description NVARCHAR(200),
CoverPhotoURL NVARCHAR(100),
DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
LanguageId INT FOREIGN KEY REFERENCES Languages(Id)
)
CREATE TABLE MoviesActors (
Id INT PRIMARY KEY IDENTITY(1,1),
MovieId INT FOREIGN KEY REFERENCES Movies(Id),
ActorId INT FOREIGN KEY REFERENCES Actors(Id)
)
CREATE TABLE MoviesGenres (
Id INT PRIMARY KEY IDENTITY(1,1),
MovieId INT FOREIGN KEY REFERENCES Movies(Id),
GenreId INT FOREIGN KEY REFERENCES Genres(Id)
)
INSERT INTO Directors 
VALUES ('Christopher', 'Nolan'), 
('Quentin', 'Tarantino'), 
('Steven', 'Spielberg')
INSERT INTO Languages 
VALUES ('English'), 
('French'), 
('Spanish')
INSERT INTO Movies
VALUES ('Inception', 'A mind-bending thriller', 'inception.jpg', 1, 1),
('Pulp Fiction', 'A cult classic', 'pulp_fiction.jpg', 2, 1),
('Jurassic Park', 'Dinosaurs come to life', 'jurassic_park.jpg', 3, 1)
INSERT INTO Actors
VALUES ('Leonardo', 'DiCaprio'), 
('Samuel', 'Jackson'), 
('Tom', 'Hanks')
INSERT INTO Genres
VALUES ('Thriller'), 
('Action'), 
('Sci-Fi')
INSERT INTO MoviesActors
VALUES (1, 1), 
(2, 2), 
(3, 3), 
(1, 2)
INSERT INTO MoviesGenres
VALUES (1, 1), 
(2, 2), 
(3, 3), 
(1, 2)

CREATE PROCEDURE DirectorsMovies @DirectorId INT
AS
BEGIN
SELECT Movies.Name AS Name, Languages.Name AS Language FROM Movies
JOIN Languages ON Movies.LanguageId = Languages.Id
WHERE Movies.DirectorId = @DirectorId
END

CREATE PROCEDURE GetMoviesByGenre @GenreId INT
AS
BEGIN
SELECT Movies.Name AS MovieName, D.Name AS DirectorName, D.Surname AS DirectorSurname FROM Movies 
JOIN MoviesGenres ON Movies.Id = MoviesGenres.MovieId
JOIN Directors D ON Movies.DirectorId = D.Id
WHERE MoviesGenres.GenreId = @GenreId;
END
 
CREATE FUNCTION GetCountOfMoviesInSameLanguage (@LanguageId INT)
RETURNS INT
AS
BEGIN
DECLARE @Count INT;
SELECT @Count = COUNT(*) FROM Movies
WHERE Movies.LanguageId = @LanguageId;
RETURN @Count;
END

CREATE FUNCTION GetActorsWithMoreThanThreeMovies (@ActorId INT) 
RETURNS BIT
AS
BEGIN
DECLARE @Count INT;
SELECT @Count = COUNT(*) FROM MoviesActors
WHERE ActorId = @ActorId;
RETURN (SELECT CASE WHEN @Count > 3 THEN 1 ELSE 0 END)
END

CREATE TRIGGER trg_GetAllMoviesAfterInsert
ON Movies
AFTER INSERT
AS
BEGIN
SELECT Movies.Name AS MovieName, Languages.Name AS Language, Directors.Name AS DirectorName FROM Movies 
JOIN Directors ON Movies.DirectorId = Directors.Id
JOIN Languages ON Movies.LanguageId = Languages.Id;
END