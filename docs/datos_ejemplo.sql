-- ============================================================
-- ProyectoHorarios - Datos de ejemplo
-- Ejecutar DESPUES de crear_tablas.sql
-- ============================================================

USE ProyectoHorarios;
GO

-- ============================================================
-- NOTA SOBRE CONTRASEÑAS
-- El campo PasswordHash debe contener la contraseña cifrada
-- con BCrypt. Los valores de abajo son placeholders.
-- Cuando se implemente la autenticacion, generar hashes reales.
-- Contrasena de todos los usuarios de ejemplo: Password123!
-- ============================================================

-- ============================================================
-- USUARIOS (1 Supervisor, 2 Managers, 1 RRHH)
-- ============================================================

INSERT INTO Usuarios (Nombre, Apellidos, Email, PasswordHash, RolId, Activo)
VALUES
    ('Ana',    'Garcia Lopez',    'ana.garcia@empresa.com',    'PLACEHOLDER_HASH', 3, 1),  -- Supervisor
    ('Carlos', 'Lopez Martinez',  'carlos.lopez@empresa.com',  'PLACEHOLDER_HASH', 2, 1),  -- Manager
    ('Maria',  'Martinez Ruiz',   'maria.martinez@empresa.com','PLACEHOLDER_HASH', 2, 1),  -- Manager
    ('Pedro',  'Sanchez Gomez',   'pedro.sanchez@empresa.com', 'PLACEHOLDER_HASH', 1, 1);  -- RRHH
GO

-- ============================================================
-- TRABAJADORES
-- Entre semana: Laura, Miguel, Sofia, Javier
-- Fin de semana: Elena, Tomas
-- Conciliacion familiar: Sofia (turno mediodía en vez de tarde)
-- ============================================================

INSERT INTO Trabajadores (Nombre, Apellidos, DNI, Email, Telefono, TipoContratoId, TurnoId, TieneConciliacionFamiliar, Activo, FechaAlta)
VALUES
    -- Entre semana — turno mañana
    ('Laura',  'Fernandez Gil',   '11111111A', 'laura.fernandez@email.com',  '600111001', 1, 1, 0, 1, '2023-03-01'),
    ('Miguel', 'Torres Vega',     '22222222B', 'miguel.torres@email.com',    '600111002', 1, 1, 0, 1, '2022-06-15'),

    -- Entre semana — turno mediodía
    ('Sofia',  'Moreno Castro',   '33333333C', 'sofia.moreno@email.com',     '600111003', 1, 2, 1, 1, '2021-09-10'),  -- conciliacion

    -- Entre semana — turno tarde
    ('Javier', 'Ruiz Blanco',     '44444444D', 'javier.ruiz@email.com',      '600111004', 1, 3, 0, 1, '2023-01-20'),

    -- Fin de semana — turno mañana
    ('Elena',  'Jimenez Pardo',   '55555555E', 'elena.jimenez@email.com',    '600111005', 2, 1, 0, 1, '2022-11-05'),

    -- Fin de semana — turno tarde
    ('Tomas',  'Navarro Leal',    '66666666F', 'tomas.navarro@email.com',    '600111006', 2, 3, 0, 1, '2023-07-01');
GO

-- ============================================================
-- FESTIVOS 2026 (nacionales España)
-- ============================================================

INSERT INTO Festivos (Fecha, Descripcion)
VALUES
    ('2026-01-01', 'Año Nuevo'),
    ('2026-01-06', 'Reyes Magos'),
    ('2026-04-02', 'Jueves Santo'),
    ('2026-04-03', 'Viernes Santo'),
    ('2026-05-01', 'Dia del Trabajador'),
    ('2026-08-15', 'Asuncion de la Virgen'),
    ('2026-10-12', 'Dia de la Hispanidad'),
    ('2026-11-01', 'Todos los Santos'),
    ('2026-12-06', 'Dia de la Constitucion'),
    ('2026-12-08', 'Inmaculada Concepcion'),
    ('2026-12-25', 'Navidad');
GO

-- ============================================================
-- HORARIO DE EJEMPLO — Semana 21 (18-24 mayo 2026)
-- Creado por Carlos Lopez (Manager, Id=2)
-- ============================================================

INSERT INTO Horarios (Nombre, FechaInicio, FechaFin, CreadoPorId)
VALUES ('Semana 21 - Mayo 2026', '2026-05-18', '2026-05-24', 2);
GO

-- Asignaciones de trabajadores de entre semana (lunes a viernes)
-- Laura  (Id=1) — mañana toda la semana
-- Miguel (Id=2) — mañana toda la semana
-- Sofia  (Id=3) — mediodía toda la semana (conciliacion)
-- Javier (Id=4) — tarde toda la semana

INSERT INTO AsignacionesTrabajador (HorarioId, TrabajadorId, Fecha, TurnoId)
VALUES
    -- Laura — turno mañana (TurnoId=1)
    (1, 1, '2026-05-18', 1), (1, 1, '2026-05-19', 1), (1, 1, '2026-05-20', 1),
    (1, 1, '2026-05-21', 1), (1, 1, '2026-05-22', 1),

    -- Miguel — turno mañana (TurnoId=1)
    (1, 2, '2026-05-18', 1), (1, 2, '2026-05-19', 1), (1, 2, '2026-05-20', 1),
    (1, 2, '2026-05-21', 1), (1, 2, '2026-05-22', 1),

    -- Sofia — turno mediodía (TurnoId=2) por conciliacion
    (1, 3, '2026-05-18', 2), (1, 3, '2026-05-19', 2), (1, 3, '2026-05-20', 2),
    (1, 3, '2026-05-21', 2), (1, 3, '2026-05-22', 2),

    -- Javier — turno tarde (TurnoId=3)
    (1, 4, '2026-05-18', 3), (1, 4, '2026-05-19', 3), (1, 4, '2026-05-20', 3),
    (1, 4, '2026-05-21', 3), (1, 4, '2026-05-22', 3),

    -- Elena y Tomas — fin de semana (sabado y domingo)
    (1, 5, '2026-05-23', 1), (1, 5, '2026-05-24', 1),  -- Elena mañana
    (1, 6, '2026-05-23', 3), (1, 6, '2026-05-24', 3);   -- Tomas tarde
GO

-- Asignacion del manager — Carlos Lopez (UsuarioId=2) cubre mediodía toda la semana
INSERT INTO AsignacionesManager (HorarioId, UsuarioId, Fecha, TurnoId)
VALUES
    (1, 2, '2026-05-18', 2), (1, 2, '2026-05-19', 2), (1, 2, '2026-05-20', 2),
    (1, 2, '2026-05-21', 2), (1, 2, '2026-05-22', 2);
GO

-- ============================================================
-- AUSENCIAS DE EJEMPLO
-- ============================================================

-- Miguel de baja medica la semana siguiente (TipoAusencia Baja medica = Id 1)
INSERT INTO AusenciasTrabajador (TrabajadorId, TipoAusenciaId, FechaInicio, FechaFin, Observaciones)
VALUES (2, 1, '2026-05-25', '2026-05-29', 'Baja por gripe');
GO

-- Sofia de vacaciones en agosto (Vacaciones = Id 2)
INSERT INTO AusenciasTrabajador (TrabajadorId, TipoAusenciaId, FechaInicio, FechaFin, Observaciones)
VALUES (3, 2, '2026-08-03', '2026-08-14', NULL);
GO

-- Manager Maria Martinez de vacaciones en julio (UsuarioId=3)
INSERT INTO AusenciasUsuario (UsuarioId, TipoAusenciaId, FechaInicio, FechaFin, Observaciones)
VALUES (3, 2, '2026-07-13', '2026-07-24', NULL);
GO

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
