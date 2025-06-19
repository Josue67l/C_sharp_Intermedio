-- Creación y Selección de la Base de Datos
-- Usar la base de datos master para poder crear o eliminar bases de datos
USE master;
GO

-- Eliminar la base de datos si ya existe para empezar desde cero 
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TaxiAppDB')
BEGIN
    ALTER DATABASE TaxiAppDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TaxiAppDB;
END;
GO

-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'TaxiAppDB')
BEGIN
    CREATE DATABASE TaxiAppDB;
END;
GO

-- Usar la base de datos recién creada o existente para los siguientes comandos
USE TaxiAppDB;
GO

-- Eliminación de Tablas Existentes (en orden inverso de dependencia para FKs)
-- Esto evita errores 

IF OBJECT_ID('DetalleViaje', 'U') IS NOT NULL DROP TABLE DetalleViaje;
IF OBJECT_ID('Viaje', 'U') IS NOT NULL DROP TABLE Viaje;
IF OBJECT_ID('SolicitudesGrupoUsuarios', 'U') IS NOT NULL DROP TABLE SolicitudesGrupoUsuarios;
IF OBJECT_ID('UsuarioGrupo', 'U') IS NOT NULL DROP TABLE UsuarioGrupo;
IF OBJECT_ID('GrupoUsuariosDetalle', 'U') IS NOT NULL DROP TABLE GrupoUsuariosDetalle;
IF OBJECT_ID('UsuarioRol', 'U') IS NOT NULL DROP TABLE UsuarioRol;
IF OBJECT_ID('Taxi', 'U') IS NOT NULL DROP TABLE Taxi;
IF OBJECT_ID('Usuario', 'U') IS NOT NULL DROP TABLE Usuario;
IF OBJECT_ID('GrupoUsuarios', 'U') IS NOT NULL DROP TABLE GrupoUsuarios;
IF OBJECT_ID('Rol', 'U') IS NOT NULL DROP TABLE Rol;
GO

-- Creación de Tablas (en orden de dependencia: tablas "padre" primero)
-- Basado en el Diagrama ER 

-- 1. Tabla: Rol
CREATE TABLE Rol (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombreRol VARCHAR(50) UNIQUE NOT NULL
);
GO

-- 2. Tabla: Usuario
CREATE TABLE Usuario (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Documento VARCHAR(20) UNIQUE NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL
);
GO

-- 3. Tabla: UsuarioRol (Tabla de relación Many-to-Many entre Usuario y Rol)
CREATE TABLE UsuarioRol (
    UsuarioId INT NOT NULL,
    RolId INT NOT NULL,
    PRIMARY KEY (UsuarioId, RolId), -- Clave compuesta
    FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id),
    FOREIGN KEY (RolId) REFERENCES Rol(Id)
);
GO

-- 4. Tabla: GrupoUsuarios
CREATE TABLE GrupoUsuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombreGrupo VARCHAR(100) UNIQUE NOT NULL
);
GO

-- 5. Tabla: UsuarioGrupo (Tabla de relación Many-to-Many entre Usuario y GrupoUsuarios)
CREATE TABLE UsuarioGrupo (
    UsuarioId INT NOT NULL,
    GrupoUsuarioId INT NOT NULL,
    PRIMARY KEY (UsuarioId, GrupoUsuarioId), -- Clave compuesta
    FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id),
    FOREIGN KEY (GrupoUsuarioId) REFERENCES GrupoUsuarios(Id)
);
GO

-- 6. Tabla: GrupoUsuariosDetalle
CREATE TABLE GrupoUsuariosDetalle (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    GrupoUsuarioId INT NOT NULL,
    Descripcion VARCHAR(255),
    Valor VARCHAR(255),
    FOREIGN KEY (GrupoUsuarioId) REFERENCES GrupoUsuarios(Id)
);
GO

-- 7. Tabla: SolicitudesGrupoUsuarios (Basado en el Diagrama ER)
CREATE TABLE SolicitudesGrupoUsuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioId INT NOT NULL,
    GrupoUsuarioId INT NOT NULL,
    FechaSolicitud DATETIME NOT NULL DEFAULT GETDATE(),
    EstadoSolicitud VARCHAR(50) NOT NULL DEFAULT 'Pendiente', -- Ej: 'Pendiente', 'Aprobada', 'Rechazada'
    FechaRespuesta DATETIME NULL,
    FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id),
    FOREIGN KEY (GrupoUsuarioId) REFERENCES GrupoUsuarios(Id)
);
GO

-- 8. Tabla: Taxi
CREATE TABLE Taxi (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Placa VARCHAR(10) UNIQUE NOT NULL
);
GO

-- 9. Tabla: Viaje
CREATE TABLE Viaje (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioId INT NOT NULL, -- Cliente que solicita el viaje
    TaxiId INT NULL,         -- Taxi asignado (puede ser NULL si aún no se ha asignado)
    FechaInicio DATETIME NOT NULL,
    FechaFin DATETIME NULL,
    Desde VARCHAR(255) NOT NULL, -- Origen (dirección o coordenadas)
    Hasta VARCHAR(255) NOT NULL, -- Destino (dirección o coordenadas)
    Calificacion INT NULL CHECK (Calificacion >= 1 AND Calificacion <= 5), -- Valor numérico para la calificación (ej: 1-5)
    EstadoViaje VARCHAR(50) NOT NULL DEFAULT 'Pendiente', -- Ej: 'Pendiente', 'En Curso', 'Completado', 'Cancelado'
    FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id),
    FOREIGN KEY (TaxiId) REFERENCES Taxi(Id)
);
GO

-- 10. Tabla: DetalleViaje
CREATE TABLE DetalleViaje (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ViajeId INT NOT NULL,
    Fecha DATETIME NOT NULL,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    FOREIGN KEY (ViajeId) REFERENCES Viaje(Id)
);
GO

-- Scripts DML - INSERT, UPDATE, DELETE
-- Los IDs se obtienen dinámicamente 

-- DML para Rol
PRINT '--- DML para la tabla Rol ---';
GO -- Separador para que las variables y SELECT * se ejecuten en su propio lote

-- INSERT
INSERT INTO Rol (NombreRol) VALUES ('Administrador');
INSERT INTO Rol (NombreRol) VALUES ('Cliente');
INSERT INTO Rol (NombreRol) VALUES ('Conductor');
SELECT 'Roles insertados:', * FROM Rol;
GO

-- UPDATE: Cambiar 'Administrador' a 'Gestor'
UPDATE Rol SET NombreRol = 'Gestor' WHERE NombreRol = 'Administrador';
SELECT 'Roles después de UPDATE (Administrador -> Gestor):', * FROM Rol;
GO

-- DELETE: Eliminar 'Conductor'
DELETE FROM Rol WHERE NombreRol = 'Conductor';
SELECT 'Roles después de DELETE (Conductor):', * FROM Rol;
GO

-- DML para Usuario
PRINT '--- DML para la tabla Usuario ---';
GO

-- INSERT
INSERT INTO Usuario (Documento, Nombre, Apellido) VALUES ('1001', 'Juan', 'Perez');
INSERT INTO Usuario (Documento, Nombre, Apellido) VALUES ('1002', 'Maria', 'Gomez');
INSERT INTO Usuario (Documento, Nombre, Apellido) VALUES ('1003', 'Carlos', 'Ruiz');
SELECT 'Usuarios insertados:', * FROM Usuario;
GO

-- UPDATE: Cambiar apellido de Juan Perez
UPDATE Usuario SET Apellido = 'Gonzales' WHERE Documento = '1001';
SELECT 'Usuarios después de UPDATE (Juan Perez -> Gonzales):', * FROM Usuario;
GO

-- DELETE: Eliminar Carlos Ruiz (asume que no tiene dependencias activas todavía)
DELETE FROM Usuario WHERE Documento = '1003';
SELECT 'Usuarios después de DELETE (Carlos Ruiz):', * FROM Usuario;
GO

-- DML para UsuarioRol (necesita IDs de Usuario y Rol)
PRINT '--- DML para la tabla UsuarioRol ---';
GO

-- INSERT
-- Obtener IDs dinámicamente para este bloque GO
INSERT INTO UsuarioRol (UsuarioId, RolId) VALUES
    ((SELECT Id FROM Usuario WHERE Documento = '1001'), (SELECT Id FROM Rol WHERE NombreRol = 'Gestor')),   -- Juan como Gestor
    ((SELECT Id FROM Usuario WHERE Documento = '1002'), (SELECT Id FROM Rol WHERE NombreRol = 'Cliente')), -- Maria como Cliente
    ((SELECT Id FROM Usuario WHERE Documento = '1001'), (SELECT Id FROM Rol WHERE NombreRol = 'Cliente'));   -- Juan también como Cliente
SELECT 'UsuarioRoles insertados:', * FROM UsuarioRol;
GO

-- Eliminar la asociación de Juan (1001) como Gestor
DELETE FROM UsuarioRol WHERE UsuarioId = (SELECT Id FROM Usuario WHERE Documento = '1001') AND RolId = (SELECT Id FROM Rol WHERE NombreRol = 'Gestor');
SELECT 'UsuarioRoles después de "UPDATE" (Juan ya no es Gestor):', * FROM UsuarioRol;
GO

-- DELETE: Eliminar la asociación de Maria (1002) como Cliente
DELETE FROM UsuarioRol WHERE UsuarioId = (SELECT Id FROM Usuario WHERE Documento = '1002') AND RolId = (SELECT Id FROM Rol WHERE NombreRol = 'Cliente');
SELECT 'UsuarioRoles después de DELETE (Maria ya no es Cliente):', * FROM UsuarioRol;
GO

-- DML para GrupoUsuarios
PRINT '--- DML para la tabla GrupoUsuarios ---';
GO

-- INSERT
INSERT INTO GrupoUsuarios (NombreGrupo) VALUES ('Clientes VIP');
INSERT INTO GrupoUsuarios (NombreGrupo) VALUES ('Conductores Activos');
SELECT 'Grupos de Usuarios insertados:', * FROM GrupoUsuarios;
GO

-- UPDATE: Renombrar un grupo
UPDATE GrupoUsuarios SET NombreGrupo = 'VIP del Mes' WHERE NombreGrupo = 'Clientes VIP';
SELECT 'Grupos de Usuarios después de UPDATE:', * FROM GrupoUsuarios;
GO

-- DELETE: Eliminar un grupo
DELETE FROM GrupoUsuarios WHERE NombreGrupo = 'Conductores Activos';
SELECT 'Grupos de Usuarios después de DELETE:', * FROM GrupoUsuarios;
GO

-- DML para UsuarioGrupo (necesita IDs de Usuario y GrupoUsuarios)
PRINT '--- DML para la tabla UsuarioGrupo ---';
GO

-- INSERT
INSERT INTO UsuarioGrupo (UsuarioId, GrupoUsuarioId)
VALUES ((SELECT Id FROM Usuario WHERE Documento = '1001'), (SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes')); -- Juan en Grupo VIP
SELECT 'UsuarioGrupo insertados:', * FROM UsuarioGrupo;
GO

-- UPDATE: No hay un UPDATE directo lógico para una PK compuesta sin otros campos.
PRINT 'UPDATE para UsuarioGrupo generalmente implica DELETE e INSERT si cambian los componentes de la PK.';
GO

-- DELETE: Eliminar a Juan del grupo VIP
DELETE FROM UsuarioGrupo WHERE UsuarioId = (SELECT Id FROM Usuario WHERE Documento = '1001') AND GrupoUsuarioId = (SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes');
SELECT 'UsuarioGrupo después de DELETE:', * FROM UsuarioGrupo;
GO

-- DML para GrupoUsuariosDetalle (necesita IDs de GrupoUsuarios)
PRINT '--- DML para la tabla GrupoUsuariosDetalle ---';
GO

-- INSERT
INSERT INTO GrupoUsuariosDetalle (GrupoUsuarioId, Descripcion, Valor)
VALUES ((SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes'), 'Beneficio', 'Descuento 10%');
INSERT INTO GrupoUsuariosDetalle (GrupoUsuarioId, Descripcion, Valor)
VALUES ((SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes'), 'Fecha Creacion', CONVERT(VARCHAR, GETDATE(), 120)); -- Formatear fecha a string
SELECT 'Detalles de Grupo de Usuarios insertados:', * FROM GrupoUsuariosDetalle;
GO

-- UPDATE: Modificar un detalle específico
UPDATE GrupoUsuariosDetalle SET Valor = 'Descuento 15%'
WHERE Descripcion = 'Beneficio' AND GrupoUsuarioId = (SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes');
SELECT 'Detalles de Grupo de Usuarios después de UPDATE:', * FROM GrupoUsuariosDetalle;
GO

-- DELETE: Eliminar un detalle
DELETE FROM GrupoUsuariosDetalle
WHERE Descripcion = 'Fecha Creacion' AND GrupoUsuarioId = (SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes');
SELECT 'Detalles de Grupo de Usuarios después de DELETE:', * FROM GrupoUsuariosDetalle;
GO

-- DML para SolicitudesGrupoUsuarios (necesita IDs de Usuario y GrupoUsuarios)
PRINT '--- DML para la tabla SolicitudesGrupoUsuarios ---';
GO

-- INSERT
INSERT INTO SolicitudesGrupoUsuarios (UsuarioId, GrupoUsuarioId, FechaSolicitud, EstadoSolicitud)
VALUES ((SELECT Id FROM Usuario WHERE Documento = '1001'), (SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes'), GETDATE(), 'Pendiente');
SELECT 'Solicitudes de Grupo de Usuarios insertadas:', * FROM SolicitudesGrupoUsuarios;
GO

-- UPDATE: Cambiar estado de solicitud (usamos los IDs de la última inserción de forma segura)
UPDATE SolicitudesGrupoUsuarios SET EstadoSolicitud = 'Aprobada', FechaRespuesta = GETDATE()
WHERE UsuarioId = (SELECT Id FROM Usuario WHERE Documento = '1001') AND GrupoUsuarioId = (SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes');
SELECT 'Solicitudes de Grupo de Usuarios después de UPDATE:', * FROM SolicitudesGrupoUsuarios;
GO

-- DELETE: Eliminar una solicitud
DELETE FROM SolicitudesGrupoUsuarios
WHERE UsuarioId = (SELECT Id FROM Usuario WHERE Documento = '1001') AND GrupoUsuarioId = (SELECT Id FROM GrupoUsuarios WHERE NombreGrupo = 'VIP del Mes');
SELECT 'Solicitudes de Grupo de Usuarios después de DELETE:', * FROM SolicitudesGrupoUsuarios;
GO

-- DML para Taxi
PRINT '--- DML para la tabla Taxi ---';
GO

-- INSERT
INSERT INTO Taxi (Placa) VALUES ('ABC-123');
INSERT INTO Taxi (Placa) VALUES ('XYZ-789');
SELECT 'Taxis insertados:', * FROM Taxi;
GO

-- UPDATE: Cambiar placa de un taxi
UPDATE Taxi SET Placa = 'DEF-456' WHERE Placa = 'ABC-123';
SELECT 'Taxis después de UPDATE:', * FROM Taxi;
GO

-- DELETE: Eliminar un taxi
DELETE FROM Taxi WHERE Placa = 'XYZ-789';
SELECT 'Taxis después de DELETE:', * FROM Taxi;
GO

-- DML para Viaje (necesita IDs de Usuario y Taxi)
PRINT '--- DML para la tabla Viaje ---';
GO

-- INSERT (Necesito asegurar que los IDs de Usuario y Taxi existan, se obtienen dinámicamente)
INSERT INTO Viaje (UsuarioId, TaxiId, FechaInicio, Desde, Hasta, EstadoViaje)
VALUES (
    (SELECT Id FROM Usuario WHERE Documento = '1001'),
    (SELECT Id FROM Taxi WHERE Placa = 'DEF-456'),
    GETDATE(),
    'Origen Calle Falsa 123',
    'Destino Av. Siempre Viva 742',
    'En Curso'
);
SELECT 'Viajes insertados:', * FROM Viaje;
GO

-- UPDATE: Actualizar estado y calificación de un viaje
-- Uso el MAX(Id) de Viaje para referirnos al último viaje insertado
UPDATE Viaje SET EstadoViaje = 'Completado', FechaFin = GETDATE(), Calificacion = 5
WHERE Id = (SELECT MAX(Id) FROM Viaje) AND UsuarioId = (SELECT Id FROM Usuario WHERE Documento = '1001');
SELECT 'Viajes después de UPDATE:', * FROM Viaje;
GO

-- DELETE: Eliminar un viaje 
DELETE FROM Viaje
WHERE Id = (SELECT MAX(Id) FROM Viaje) AND UsuarioId = (SELECT Id FROM Usuario WHERE Documento = '1001');
SELECT 'Viajes después de DELETE:', * FROM Viaje;
GO

-- DML para DetalleViaje (necesita IDs de Viaje)
PRINT '--- DML para la tabla DetalleViaje ---';
GO

-- Para insertar un detalle de viaje, necesitamos un ViajeId existente.
-- Volvemos a insertar un Viaje para asegurarnos de tener un ID de referencia.
INSERT INTO Viaje (UsuarioId, TaxiId, FechaInicio, Desde, Hasta, EstadoViaje)
VALUES (
    (SELECT Id FROM Usuario WHERE Documento = '1001'),
    (SELECT Id FROM Taxi WHERE Placa = 'DEF-456'),
    GETDATE(),
    'Punto A',
    'Punto B',
    'En Curso'
);
-- Obtener el ID del viaje que acabamos de insertar
DECLARE @UltimoViajeId_Detalle INT = (SELECT MAX(Id) FROM Viaje);

-- INSERT
INSERT INTO DetalleViaje (ViajeId, Fecha, Latitude, Longitude)
VALUES (@UltimoViajeId_Detalle, GETDATE(), 18.486058, -69.930919); -- Coordenadas de Santo Domingo
INSERT INTO DetalleViaje (ViajeId, Fecha, Latitude, Longitude)
VALUES (@UltimoViajeId_Detalle, DATEADD(minute, 5, GETDATE()), 18.475890, -69.940000);
SELECT 'Detalles de Viaje insertados:', * FROM DetalleViaje;
GO

-- UPDATE: Modificar la latitud/longitud de un detalle de viaje
UPDATE DetalleViaje SET Latitude = 18.490000, Longitude = -69.935000
WHERE ViajeId = (SELECT MAX(Id) FROM Viaje) AND Latitude = 18.486058; -- Asumiendo que es el detalle recién insertado
SELECT 'Detalles de Viaje después de UPDATE:', * FROM DetalleViaje;
GO

-- DELETE: Eliminar un detalle de viaje
DELETE FROM DetalleViaje
WHERE ViajeId = (SELECT MAX(Id) FROM Viaje) AND Latitude = 18.490000;
SELECT 'Detalles de Viaje después de DELETE:', * FROM DetalleViaje;
GO

PRINT '--- FIN DEL SCRIPT COMPLETO ---';