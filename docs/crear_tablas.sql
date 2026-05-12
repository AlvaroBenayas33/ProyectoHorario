-- ============================================================
-- ProyectoHorarios - Script de creacion de tablas
-- Servidor: PMADJC1124
-- Base de datos: ProyectoHorarios
-- ============================================================

USE ProyectoHorarios;
GO

-- ============================================================
-- BLOQUE 1: USUARIOS Y ACCESO
-- ============================================================

CREATE TABLE Roles (
    Id      INT           NOT NULL IDENTITY(1,1),
    Nombre  NVARCHAR(50)  NOT NULL,

    CONSTRAINT PK_Roles PRIMARY KEY (Id),
    CONSTRAINT UQ_Roles_Nombre UNIQUE (Nombre)
);
GO

-- Valores iniciales
INSERT INTO Roles (Nombre) VALUES ('RRHH'), ('Manager'), ('Supervisor');
GO

CREATE TABLE Usuarios (
    Id             INT            NOT NULL IDENTITY(1,1),
    Nombre         NVARCHAR(100)  NOT NULL,
    Apellidos      NVARCHAR(100)  NOT NULL,
    Email          NVARCHAR(200)  NOT NULL,
    PasswordHash   NVARCHAR(500)  NOT NULL,
    RolId          INT            NOT NULL,
    Activo         BIT            NOT NULL DEFAULT 1,
    FechaCreacion  DATETIME2      NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Usuarios        PRIMARY KEY (Id),
    CONSTRAINT UQ_Usuarios_Email  UNIQUE (Email),
    CONSTRAINT FK_Usuarios_Roles  FOREIGN KEY (RolId) REFERENCES Roles(Id)
);
GO

-- ============================================================
-- BLOQUE 2: TRABAJADORES
-- ============================================================

CREATE TABLE TiposContrato (
    Id      INT          NOT NULL IDENTITY(1,1),
    Nombre  NVARCHAR(50) NOT NULL,

    CONSTRAINT PK_TiposContrato        PRIMARY KEY (Id),
    CONSTRAINT UQ_TiposContrato_Nombre UNIQUE (Nombre)
);
GO

INSERT INTO TiposContrato (Nombre) VALUES ('Entre semana'), ('Fin de semana');
GO

CREATE TABLE Turnos (
    Id          INT          NOT NULL IDENTITY(1,1),
    Nombre      NVARCHAR(50) NOT NULL,
    HoraInicio  TIME         NOT NULL,
    HoraFin     TIME         NOT NULL,

    CONSTRAINT PK_Turnos        PRIMARY KEY (Id),
    CONSTRAINT UQ_Turnos_Nombre UNIQUE (Nombre)
);
GO

INSERT INTO Turnos (Nombre, HoraInicio, HoraFin) VALUES
    ('Manana',   '06:00', '14:00'),
    ('Mediodia', '14:00', '22:00'),
    ('Tarde',    '22:00', '06:00');
GO

CREATE TABLE Trabajadores (
    Id                       INT            NOT NULL IDENTITY(1,1),
    Nombre                   NVARCHAR(100)  NOT NULL,
    Apellidos                NVARCHAR(100)  NOT NULL,
    DNI                      NVARCHAR(20)   NOT NULL,
    Email                    NVARCHAR(200)  NULL,
    Telefono                 NVARCHAR(20)   NULL,
    TipoContratoId           INT            NOT NULL,
    TurnoId                  INT            NOT NULL,
    TieneConciliacionFamiliar BIT           NOT NULL DEFAULT 0,
    Activo                   BIT            NOT NULL DEFAULT 1,
    FechaAlta                DATE           NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Trabajadores           PRIMARY KEY (Id),
    CONSTRAINT UQ_Trabajadores_DNI       UNIQUE (DNI),
    CONSTRAINT FK_Trabajadores_Contrato  FOREIGN KEY (TipoContratoId) REFERENCES TiposContrato(Id),
    CONSTRAINT FK_Trabajadores_Turno     FOREIGN KEY (TurnoId)        REFERENCES Turnos(Id)
);
GO

-- ============================================================
-- BLOQUE 3: AUSENCIAS
-- ============================================================

CREATE TABLE TiposAusencia (
    Id      INT          NOT NULL IDENTITY(1,1),
    Nombre  NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_TiposAusencia        PRIMARY KEY (Id),
    CONSTRAINT UQ_TiposAusencia_Nombre UNIQUE (Nombre)
);
GO

INSERT INTO TiposAusencia (Nombre) VALUES
    ('Baja medica'),
    ('Vacaciones'),
    ('Permiso retribuido'),
    ('Permiso no retribuido'),
    ('Maternidad / Paternidad'),
    ('Otros');
GO

CREATE TABLE AusenciasTrabajador (
    Id              INT            NOT NULL IDENTITY(1,1),
    TrabajadorId    INT            NOT NULL,
    TipoAusenciaId  INT            NOT NULL,
    FechaInicio     DATE           NOT NULL,
    FechaFin        DATE           NOT NULL,
    Observaciones   NVARCHAR(500)  NULL,

    CONSTRAINT PK_AusenciasTrabajador              PRIMARY KEY (Id),
    CONSTRAINT FK_AusenciasTrabajador_Trabajador   FOREIGN KEY (TrabajadorId)   REFERENCES Trabajadores(Id),
    CONSTRAINT FK_AusenciasTrabajador_TipoAusencia FOREIGN KEY (TipoAusenciaId) REFERENCES TiposAusencia(Id),
    CONSTRAINT CK_AusenciasTrabajador_Fechas       CHECK (FechaFin >= FechaInicio)
);
GO

CREATE TABLE AusenciasUsuario (
    Id              INT            NOT NULL IDENTITY(1,1),
    UsuarioId       INT            NOT NULL,
    TipoAusenciaId  INT            NOT NULL,
    FechaInicio     DATE           NOT NULL,
    FechaFin        DATE           NOT NULL,
    Observaciones   NVARCHAR(500)  NULL,

    CONSTRAINT PK_AusenciasUsuario              PRIMARY KEY (Id),
    CONSTRAINT FK_AusenciasUsuario_Usuario      FOREIGN KEY (UsuarioId)      REFERENCES Usuarios(Id),
    CONSTRAINT FK_AusenciasUsuario_TipoAusencia FOREIGN KEY (TipoAusenciaId) REFERENCES TiposAusencia(Id),
    CONSTRAINT CK_AusenciasUsuario_Fechas       CHECK (FechaFin >= FechaInicio)
);
GO

-- ============================================================
-- BLOQUE 4: HORARIOS
-- ============================================================

CREATE TABLE Horarios (
    Id           INT            NOT NULL IDENTITY(1,1),
    Nombre       NVARCHAR(200)  NOT NULL,
    FechaInicio  DATE           NOT NULL,
    FechaFin     DATE           NOT NULL,
    CreadoPorId  INT            NOT NULL,
    FechaCreacion DATETIME2     NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Horarios          PRIMARY KEY (Id),
    CONSTRAINT FK_Horarios_Usuario  FOREIGN KEY (CreadoPorId) REFERENCES Usuarios(Id),
    CONSTRAINT CK_Horarios_Fechas   CHECK (FechaFin >= FechaInicio)
);
GO

CREATE TABLE AsignacionesTrabajador (
    Id            INT   NOT NULL IDENTITY(1,1),
    HorarioId     INT   NOT NULL,
    TrabajadorId  INT   NOT NULL,
    Fecha         DATE  NOT NULL,
    TurnoId       INT   NOT NULL,

    CONSTRAINT PK_AsignacionesTrabajador             PRIMARY KEY (Id),
    CONSTRAINT FK_AsignacionesTrabajador_Horario     FOREIGN KEY (HorarioId)    REFERENCES Horarios(Id),
    CONSTRAINT FK_AsignacionesTrabajador_Trabajador  FOREIGN KEY (TrabajadorId) REFERENCES Trabajadores(Id),
    CONSTRAINT FK_AsignacionesTrabajador_Turno       FOREIGN KEY (TurnoId)      REFERENCES Turnos(Id),
    CONSTRAINT UQ_AsignacionesTrabajador             UNIQUE (HorarioId, TrabajadorId, Fecha)
);
GO

CREATE TABLE AsignacionesManager (
    Id         INT   NOT NULL IDENTITY(1,1),
    HorarioId  INT   NOT NULL,
    UsuarioId  INT   NOT NULL,
    Fecha      DATE  NOT NULL,
    TurnoId    INT   NOT NULL,

    CONSTRAINT PK_AsignacionesManager           PRIMARY KEY (Id),
    CONSTRAINT FK_AsignacionesManager_Horario   FOREIGN KEY (HorarioId)  REFERENCES Horarios(Id),
    CONSTRAINT FK_AsignacionesManager_Usuario   FOREIGN KEY (UsuarioId)  REFERENCES Usuarios(Id),
    CONSTRAINT FK_AsignacionesManager_Turno     FOREIGN KEY (TurnoId)    REFERENCES Turnos(Id),
    CONSTRAINT UQ_AsignacionesManager           UNIQUE (HorarioId, UsuarioId, Fecha)
);
GO

-- ============================================================
-- BLOQUE 5: FESTIVOS
-- ============================================================

CREATE TABLE Festivos (
    Id           INT            NOT NULL IDENTITY(1,1),
    Fecha        DATE           NOT NULL,
    Descripcion  NVARCHAR(200)  NOT NULL,

    CONSTRAINT PK_Festivos       PRIMARY KEY (Id),
    CONSTRAINT UQ_Festivos_Fecha UNIQUE (Fecha)
);
GO

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
