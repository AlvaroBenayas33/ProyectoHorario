# Estructura del Proyecto — ProyectoHorario

> Este documento explica en detalle para que sirve cada carpeta del proyecto,
> que responsabilidad tiene y que tipo de archivos contendra.

---

## Vision general

El proyecto esta dividido en tres grandes bloques:

- **`src/`** — Todo el codigo fuente de la aplicacion (backend y frontend)
- **`tests/`** — Los proyectos de pruebas automatizadas
- **`docs/`** — Documentacion del proyecto

Dentro de `src/` el backend sigue una arquitectura llamada **Clean Architecture**,
que organiza el codigo en capas con una regla fundamental:
las capas internas no saben nada de las capas externas.

```
+-------------------------+
|     ProyectoHorario.API |  <- Capa externa: recibe peticiones del mundo real
+-------------------------+
|ProyectoHorario.Infra... |  <- Capa media: habla con la base de datos
+-------------------------+
|  ProyectoHorario.Core   |  <- Capa interna: logica pura de negocio
+-------------------------+
```

Esto hace que la logica de negocio sea independiente de la base de datos y del framework web,
lo que facilita hacer cambios y escribir tests.

---

## src/ProyectoHorario.Core

**Que es:** El nucleo del proyecto. Aqui vive toda la logica de negocio pura.

**Regla importante:** Esta capa no depende de ninguna otra. No sabe que existe SQL Server,
ni ASP.NET, ni ningun framework externo. Esto la hace completamente testeable y portable.

---

### Core/Entities/

**Para que sirve:** Contiene las clases que representan los conceptos principales del negocio.
Son los "objetos del mundo real" que el sistema gestiona.

**Que tendra:**
Cada archivo es una clase que modela una entidad del dominio. Por ejemplo:

```
Entities/
+-- Empleado.cs       <- Datos de un empleado (nombre, departamento, etc.)
+-- Turno.cs          <- Un turno de trabajo (fecha, hora inicio, hora fin)
+-- Horario.cs        <- El horario semanal o mensual asignado a un empleado
+-- Departamento.cs   <- Agrupacion de empleados
```

Estas clases son simples: tienen propiedades y, si aplica, alguna validacion de negocio.
No tienen logica de base de datos ni de red.

---

### Core/Interfaces/

**Para que sirve:** Define los contratos que la capa de Infrastructure debe cumplir.
Una interfaz es como un "acuerdo": dice que metodos existiran, sin decir como se implementan.

**Por que es util:** Core no puede depender de Infrastructure, pero necesita poder acceder
a los datos. La solucion es que Core define la interfaz, y Infrastructure la implementa.
Asi Core trabaja con el contrato, no con la implementacion concreta.

**Que tendra:**

```
Interfaces/
+-- IEmpleadoRepository.cs    <- Define metodos como ObtenerTodos(), ObtenerPorId(), Guardar()...
+-- ITurnoRepository.cs
+-- IHorarioRepository.cs
+-- IUnitOfWork.cs             <- Agrupa todos los repositorios y gestiona las transacciones
```

---

### Core/Services/

**Para que sirve:** Contiene la logica de negocio que no pertenece a una sola entidad.
Cuando una operacion involucra varias entidades o reglas complejas, va aqui.

**Que tendra:**

```
Services/
+-- HorarioService.cs     <- Logica de asignacion de turnos, validacion de solapamientos, etc.
+-- EmpleadoService.cs    <- Reglas especificas de empleados
```

---

## src/ProyectoHorario.Infrastructure

**Que es:** La capa de acceso a datos. Se encarga de todo lo relacionado con la base de datos.
Implementa los contratos (interfaces) que Core ha definido.

**Depende de:** Core (para implementar sus interfaces y usar sus entidades)

---

### Infrastructure/Data/

**Para que sirve:** Contiene el `DbContext`, que es la clase central de Entity Framework Core.
El DbContext representa la sesion activa con la base de datos y es el punto de acceso a las tablas.

**Que tendra:**

```
Data/
+-- AppDbContext.cs    <- Clase principal de EF Core. Aqui se registran todas las entidades
                          como DbSet<> para que EF Core sepa que tablas gestionar.
```

Ejemplo de como quedara cuando haya entidades:

```csharp
public DbSet<Empleado> Empleados { get; set; }
public DbSet<Turno> Turnos { get; set; }
public DbSet<Horario> Horarios { get; set; }
```

---

### Infrastructure/Repositories/

**Para que sirve:** Aqui se implementan las interfaces definidas en Core.
Cada repositorio contiene las consultas reales a la base de datos usando EF Core.

**Que tendra:**

```
Repositories/
+-- EmpleadoRepository.cs    <- Implementa IEmpleadoRepository con consultas reales a SQL Server
+-- TurnoRepository.cs
+-- HorarioRepository.cs
+-- UnitOfWork.cs             <- Implementa IUnitOfWork, gestiona el guardado de cambios
```

---

### Infrastructure/Migrations/

**Para que sirve:** Carpeta gestionada automaticamente por Entity Framework Core.
Cada vez que se modifica el modelo de datos, EF Core genera aqui un archivo de migracion
que describe los cambios que hay que aplicar en la base de datos.

**Que tendra:**

```
Migrations/
+-- 20240101_InitialCreate.cs         <- Primera migracion: crea las tablas iniciales
+-- 20240115_AgregarCampoTelefono.cs  <- Ejemplo: una migracion posterior que añade un campo
+-- AppDbContextModelSnapshot.cs      <- Instantanea del estado actual del modelo (no editar manualmente)
```

> Estos archivos se generan con el comando `dotnet ef migrations add NombreMigracion`
> y nunca deben editarse a mano.

---

## src/ProyectoHorario.API

**Que es:** La capa mas externa del backend. Es el proyecto que se ejecuta y escucha peticiones HTTP.
Actua como intermediario entre el cliente (Vue) y la logica de negocio (Core + Infrastructure).

**Depende de:** Core e Infrastructure

---

### API/Controllers/

**Para que sirve:** Los controladores reciben las peticiones HTTP que llegan desde el frontend
y devuelven las respuestas. Cada controlador agrupa los endpoints relacionados con una entidad.

**Que tendra:**

```
Controllers/
+-- EmpleadosController.cs    <- Endpoints: GET /empleados, POST /empleados, PUT /empleados/{id}...
+-- TurnosController.cs
+-- HorariosController.cs
```

Un controlador tipico expone operaciones CRUD (Crear, Leer, Actualizar, Eliminar)
y delega el trabajo real a los servicios de la capa Core.

---

### API/DTOs/

**Para que sirve:** DTO significa "Data Transfer Object". Son clases simples que definen
exactamente que datos entran y salen por la API, de forma independiente a las entidades del dominio.

**Por que no usar directamente las entidades:** Las entidades pueden tener campos internos
que no deben exponerse (contrasenas, campos calculados, relaciones circulares...).
Los DTOs permiten controlar exactamente que informacion se envia y se recibe.

**Que tendra:**

```
DTOs/
+-- EmpleadoDto.cs           <- Lo que devuelve la API al consultar un empleado
+-- CrearEmpleadoDto.cs      <- Lo que recibe la API al crear un empleado nuevo
+-- ActualizarEmpleadoDto.cs <- Lo que recibe la API al modificar un empleado
+-- TurnoDto.cs
+-- HorarioDto.cs
```

---

### API/Services/

**Para que sirve:** Servicios especificos de la capa API que no pertenecen al nucleo de negocio.
Por ejemplo, logica de autenticacion, generacion de tokens JWT, envio de notificaciones, etc.

**Que tendra:**

```
Services/
+-- AuthService.cs     <- Gestion de autenticacion y tokens JWT (si se implementa login)
+-- TokenService.cs    <- Generacion y validacion de tokens
```

---

### API/Middleware/

**Para que sirve:** El middleware son piezas de codigo que se ejecutan automaticamente
en cada peticion HTTP, antes o despues de que llegue al controlador.
Se usan para cosas transversales que aplican a toda la API.

**Que tendra:**

```
Middleware/
+-- ExceptionHandlingMiddleware.cs   <- Captura cualquier error no controlado y devuelve
                                        una respuesta JSON limpia en lugar de un error crudo
```

---

### API/Models/

**Para que sirve:** Modelos de respuesta estandarizados para la API.
Por ejemplo, un envoltorio comun para todas las respuestas que incluya el estado, el mensaje y los datos.

**Que tendra:**

```
Models/
+-- ApiResponse.cs    <- Modelo generico de respuesta: { success, message, data }
+-- PagedResult.cs    <- Modelo para respuestas paginadas: { items, totalCount, page }
```

---

## src/ProyectoHorario.Client

**Que es:** La aplicacion frontend construida con Vue 3, TypeScript y Vite.
Es completamente independiente del backend y se comunica con el unicamente a traves de la API REST.

La estructura interna de esta carpeta la genera Vite automaticamente y sigue las convenciones de Vue 3:

```
ProyectoHorario.Client/
+-- src/
|   +-- assets/          <- Imagenes, iconos, fuentes y estilos globales
|   +-- components/      <- Componentes Vue reutilizables (botones, tablas, formularios...)
|   +-- views/           <- Paginas completas de la aplicacion (una por ruta)
|   +-- router/          <- Configuracion de Vue Router (que URL carga que vista)
|   +-- stores/          <- Stores de Pinia (estado global: usuario logueado, datos cargados...)
|   +-- services/        <- Funciones para llamar a la API (fetch/axios)
|   +-- App.vue          <- Componente raiz de la aplicacion
|   +-- main.ts          <- Punto de entrada: arranca la app y registra plugins
+-- public/              <- Archivos estaticos que se sirven tal cual (favicon, etc.)
+-- index.html           <- HTML base de la SPA
+-- vite.config.ts       <- Configuracion del servidor de desarrollo y del build
```

---

## tests/

Los proyectos de test verifican que el codigo funciona correctamente de forma automatizada.
Usar xUnit como framework de testing.

---

### tests/ProyectoHorario.Core.Tests/

**Para que sirve:** Tests de la logica de negocio pura (los servicios y entidades de Core).
Son los mas importantes porque validan las reglas del negocio.

**Que tendra:**

```
ProyectoHorario.Core.Tests/
+-- Services/
|   +-- HorarioServiceTests.cs    <- Tests de las reglas de asignacion de turnos
|   +-- EmpleadoServiceTests.cs
+-- Entities/
    +-- TurnoTests.cs             <- Tests de validaciones dentro de las entidades
```

---

### tests/ProyectoHorario.API.Tests/

**Para que sirve:** Tests de los controladores y la configuracion de la API.
Verifican que los endpoints responden correctamente, que los DTOs se mapean bien
y que los codigos HTTP son los esperados.

**Que tendra:**

```
ProyectoHorario.API.Tests/
+-- Controllers/
    +-- EmpleadosControllerTests.cs
    +-- TurnosControllerTests.cs
```

---

## docs/

**Para que sirve:** Documentacion general del proyecto.

**Que tendra:**

```
docs/
+-- SETUP.md        <- Guia completa para preparar el entorno desde cero
+-- ESTRUCTURA.md   <- Este documento
```
