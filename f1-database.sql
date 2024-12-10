-- Crear base de datos
CREATE DATABASE F1_Championships;
USE F1_Championships;

-- Tabla de Pilotos
CREATE TABLE Pilotos (
    PilotoID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Nacionalidad VARCHAR(50),
    FechaNacimiento DATE,
    PrimeraTemporada INT,
    UltimaTemporada INT
);

-- Tabla de Equipos
CREATE TABLE Equipos (
    EquipoID INT PRIMARY KEY,
    NombreEquipo VARCHAR(100),
    Pais VARCHAR(50),
    AñoFundacion INT
);

-- Tabla de Temporadas
CREATE TABLE Temporadas (
    Año INT PRIMARY KEY,
    CampeonPiloto INT,
    CampeonConstructor INT,
    FOREIGN KEY (CampeonPiloto) REFERENCES Pilotos(PilotoID),
    FOREIGN KEY (CampeonConstructor) REFERENCES Equipos(EquipoID)
);

-- Tabla de Carreras
CREATE TABLE Carreras (
    CarreraID INT PRIMARY KEY,
    Año INT,
    GranPremio VARCHAR(100),
    Circuito VARCHAR(100),
    Pais VARCHAR(50),
    Fecha DATE,
    FOREIGN KEY (Año) REFERENCES Temporadas(Año)
);

-- Tabla de Resultados
CREATE TABLE Resultados (
    ResultadoID INT PRIMARY KEY,
    CarreraID INT,
    PilotoID INT,
    EquipoID INT,
    Posicion INT,
    PuntosMundial INT,
    TiempoCarrera TIME,
    FOREIGN KEY (CarreraID) REFERENCES Carreras(CarreraID),
    FOREIGN KEY (PilotoID) REFERENCES Pilotos(PilotoID),
    FOREIGN KEY (EquipoID) REFERENCES Equipos(EquipoID)
);

-- Insertar datos de ejemplo
-- Pilotos
INSERT INTO Pilotos (PilotoID, Nombre, Nacionalidad, FechaNacimiento, PrimeraTemporada, UltimaTemporada)
VALUES 
(1, 'Lewis Hamilton', 'Británico', '1985-01-07', 2007, NULL),
(2, 'Michael Schumacher', 'Alemán', '1969-01-03', 1991, 2012),
(3, 'Max Verstappen', 'Holandés', '1997-09-30', 2015, NULL);

-- Equipos
INSERT INTO Equipos (EquipoID, NombreEquipo, Pais, AñoFundacion)
VALUES 
(1, 'Mercedes AMG Petronas', 'Alemania', 2010),
(2, 'Red Bull Racing', 'Austria', 2005),
(3, 'Ferrari', 'Italia', 1929);

-- Temporadas
INSERT INTO Temporadas (Año, CampeonPiloto, CampeonConstructor)
VALUES 
(2020, 1, 1),
(2021, 3, 2),
(2022, 3, 2);

-- Carreras (algunos ejemplos)
INSERT INTO Carreras (CarreraID, Año, GranPremio, Circuito, Pais, Fecha)
VALUES 
(1, 2022, 'Gran Premio de Abu Dhabi', 'Yas Marina', 'Emiratos Árabes Unidos', '2022-11-20'),
(2, 2022, 'Gran Premio de Brasil', 'Interlagos', 'Brasil', '2022-11-13'),
(3, 2022, 'Gran Premio de Mónaco', 'Circuit de Monaco', 'Mónaco', '2022-05-29');

-- Resultados (algunos ejemplos)
INSERT INTO Resultados (ResultadoID, CarreraID, PilotoID, EquipoID, Posicion, PuntosMundial, TiempoCarrera)
VALUES 
(1, 1, 3, 2, 1, 25, '01:24:12.504'),
(2, 1, 1, 1, 2, 18, '01:24:15.784'),
(3, 2, 3, 2, 1, 25, '01:32:48.104');

-- Consultas de ejemplo
-- 1. Todos los campeones mundiales
SELECT t.Año, p.Nombre AS Campeon, e.NombreEquipo AS Equipo
FROM Temporadas t
JOIN Pilotos p ON t.CampeonPiloto = p.PilotoID
JOIN Equipos e ON t.CampeonConstructor = e.EquipoID;

-- 2. Número de victorias por piloto
SELECT p.Nombre, COUNT(r.ResultadoID) AS Victorias
FROM Pilotos p
JOIN Resultados r ON p.PilotoID = r.PilotoID
WHERE r.Posicion = 1
GROUP BY p.Nombre
ORDER BY Victorias DESC;

-- 3. Resultados de un Gran Premio específico
SELECT c.GranPremio, c.Fecha, p.Nombre AS Piloto, e.NombreEquipo AS Equipo, r.Posicion
FROM Carreras c
JOIN Resultados r ON c.CarreraID = r.CarreraID
JOIN Pilotos p ON r.PilotoID = p.PilotoID
JOIN Equipos e ON r.EquipoID = e.EquipoID
WHERE c.CarreraID = 1
ORDER BY r.Posicion;
