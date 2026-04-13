# Guia de Preparacion — ProyectoHorario

> Este documento recoge todos los pasos necesarios para preparar el entorno y el proyecto desde cero.
> Esta pensado para que cualquier persona pueda replicar la configuracion completa sin conocimiento previo del proyecto.

---

## Indice

1. [Aplicaciones a instalar](#1-aplicaciones-a-instalar)
2. [Extensiones de VS Code](#2-extensiones-de-vs-code)
3. [Crear el repositorio en GitHub](#3-crear-el-repositorio-en-github)
4. [Estructura de carpetas](#4-estructura-de-carpetas)
5. [Proyectos .NET](#5-proyectos-net)
6. [Frontend — Vue 3](#6-frontend--vue-3)
7. [Entity Framework Core y SQL Server](#7-entity-framework-core-y-sql-server)
8. [Verificacion final](#8-verificacion-final)

---

## 1. Aplicaciones a instalar

Antes de empezar necesitas tener instaladas las siguientes herramientas en tu maquina.
El orden de instalacion no es critico, pero se recomienda seguirlo para evitar problemas.

---

### .NET SDK
El SDK de .NET es la herramienta principal para desarrollar, compilar y ejecutar aplicaciones C#.
Sin el no es posible crear ni arrancar los proyectos de backend.

- **Version usada:** 10.0.201
- **Descarga:** https://dotnet.microsoft.com/download

Una vez instalado, verifica que funciona ejecutando:
```bash
dotnet --version
```

---

### Node.js
Node.js es el entorno de ejecucion de JavaScript necesario para trabajar con el frontend.
Al instalarlo tambien se instala automaticamente **npm**, el gestor de paquetes que usaremos para instalar las dependencias de Vue.

- **Version usada:** 24.8.0 (npm 11.6.0)
- **Descarga:** https://nodejs.org

Verifica la instalacion:
```bash
node --version
npm --version
```

---

### Git
Git es el sistema de control de versiones. Permite llevar un historial de todos los cambios del proyecto
y sincronizarlos con GitHub para que el codigo este siempre a salvo y accesible.

- **Version usada:** 2.45.1
- **Descarga:** https://git-scm.com/downloads

Verifica la instalacion:
```bash
git --version
```

---

### SQL Server
Es el motor de base de datos que usa el proyecto para almacenar toda la informacion.

- **Version usada:** 17.0.1000.7
- **Descarga:** https://www.microsoft.com/sql-server

---

### SQL Server Management Studio (SSMS)
Herramienta grafica para gestionar SQL Server. Permite crear bases de datos, ejecutar consultas,
ver tablas y administrar usuarios de forma visual sin necesidad de escribir comandos.

- **Descarga:** https://aka.ms/ssmsfullsetup

---

### Visual Studio Code
Editor de codigo ligero y potente que usaremos como entorno de desarrollo principal.
Funciona bien tanto para C# como para Vue gracias a sus extensiones.

- **Descarga:** https://code.visualstudio.com

---

## 2. Extensiones de VS Code

Las extensiones añaden funcionalidades al editor. Instalas desde el panel de extensiones (`Ctrl+Shift+X`)
buscando el nombre o el ID.

| Extension | ID | Que hace |
|---|---|---|
| C# Dev Kit | `ms-dotnettools.csdevkit` | Autocompletado, depuracion y soporte completo para proyectos .NET en VS Code |
| Vue - Official (Volar) | `Vue.volar` | Soporte para Vue 3 con TypeScript: sintaxis, autocompletado y deteccion de errores |
| ESLint | `dbaeumer.vscode-eslint` | Detecta errores y malas practicas en el codigo JavaScript y TypeScript |
| GitLens | `eamodio.gitlens` | Muestra informacion del historial de Git directamente en el editor (quien cambio cada linea, cuando, etc.) |
| SQL Server (mssql) | `ms-mssql.mssql` | Permite conectarse a SQL Server y ejecutar consultas directamente desde VS Code |

---

## 3. Crear el repositorio en GitHub

GitHub es la plataforma donde se aloja el codigo del proyecto de forma remota.
Tener el codigo en GitHub permite colaborar, hacer copias de seguridad y llevar un historial de cambios.

### Paso 1 — Crear el repositorio en la web

1. Ir a **https://github.com/new**
2. Escribir el nombre: `ProyectoHorario`
3. Elegir visibilidad (publica o privada)
4. **MUY IMPORTANTE:** No marcar ninguna opcion adicional (sin README, sin .gitignore, sin licencia).
   Si se marcan, GitHub crea un commit inicial que puede entrar en conflicto al subir el proyecto local.
5. Clic en **Create repository**

### Paso 2 — Subir el proyecto local a GitHub

Desde la raiz del proyecto (`horario/`) ejecutar:

```bash
# Inicializa Git en la carpeta del proyecto
git init

# Añade todos los archivos al area de preparacion
git add .

# Crea el primer commit con todos los archivos
git commit -m "first commit"

# Renombra la rama principal a 'main' (estandar actual)
git branch -M main

# Enlaza el repositorio local con el remoto de GitHub
git remote add origin https://github.com/AlvaroBenayas33/ProyectoHorario.git

# Sube el codigo a GitHub por primera vez (-u guarda la referencia para futuros push)
git push -u origin main
```

### Subir cambios en el dia a dia

Cada vez que se quiera guardar y subir cambios nuevos:

```bash
# Marca los archivos modificados para incluirlos en el commit
git add .

# Crea un punto de guardado con una descripcion del cambio
git commit -m "descripcion del cambio"

# Sube el commit a GitHub
git push
```

---

## 4. Estructura de carpetas

El proyecto sigue una arquitectura llamada **Clean Architecture**, que organiza el codigo en capas
con responsabilidades bien separadas. Esto hace que el proyecto sea mas facil de mantener y de testear.

- **API:** La capa mas externa. Recibe las peticiones HTTP y devuelve respuestas.
- **Core:** El nucleo del proyecto. Contiene las entidades (modelos de negocio) y las interfaces (contratos).
  No depende de ninguna otra capa.
- **Infrastructure:** Se encarga del acceso a datos (base de datos). Implementa los contratos definidos en Core.
- **Client:** El frontend en Vue. Es una aplicacion completamente separada que consume la API.

```
horario/
|
+-- src/
|   |
|   +-- ProyectoHorario.API/            <- Controladores y configuracion de ASP.NET Core
|   |   +-- Controllers/                   Reciben las peticiones HTTP y devuelven respuestas
|   |   +-- DTOs/                          Objetos de transferencia de datos (lo que entra y sale por la API)
|   |   +-- Middleware/                    Logica que se ejecuta antes o despues de cada peticion
|   |   +-- Models/                        Modelos especificos de la API
|   |   +-- Services/                      Servicios de aplicacion (orquestan la logica)
|   |
|   +-- ProyectoHorario.Core/           <- Logica de negocio pura, sin dependencias externas
|   |   +-- Entities/                      Las clases principales del dominio (ej: Empleado, Turno)
|   |   +-- Interfaces/                    Contratos que Infrastructure debe implementar
|   |   +-- Services/                      Reglas de negocio
|   |
|   +-- ProyectoHorario.Infrastructure/ <- Todo lo relacionado con el acceso a datos
|   |   +-- Data/                          DbContext de Entity Framework
|   |   +-- Migrations/                    Historial de cambios en la base de datos (generado automaticamente)
|   |   +-- Repositories/                  Implementacion del acceso a datos
|   |
|   +-- ProyectoHorario.Client/         <- Aplicacion Vue 3 + TypeScript + Vite (frontend)
|
+-- tests/
|   +-- ProyectoHorario.API.Tests/      <- Tests de los controladores y servicios de API
|   +-- ProyectoHorario.Core.Tests/     <- Tests de la logica de negocio
|
+-- docs/                               <- Documentacion del proyecto
```

### Comando para crear todas las carpetas de una vez

```bash
mkdir -p src/ProyectoHorario.API/{Controllers,Models,DTOs,Services,Middleware} \
         src/ProyectoHorario.Core/{Entities,Interfaces,Services} \
         src/ProyectoHorario.Infrastructure/{Data,Repositories,Migrations} \
         src/ProyectoHorario.Client \
         tests/ProyectoHorario.API.Tests \
         tests/ProyectoHorario.Core.Tests \
         docs
```

---

## 5. Proyectos .NET

Cada carpeta de `src/` y `tests/` es un proyecto .NET independiente con su propio archivo `.csproj`.
Todos ellos se agrupan en un archivo de solucion (`.slnx`) que permite trabajar con todos a la vez.

### Crear los proyectos

```bash
# webapi: plantilla de ASP.NET Core con soporte para controladores REST
dotnet new webapi -n ProyectoHorario.API -o src/ProyectoHorario.API --no-restore

# classlib: libreria de clases sin punto de entrada, ideal para logica reutilizable
dotnet new classlib -n ProyectoHorario.Core -o src/ProyectoHorario.Core --no-restore
dotnet new classlib -n ProyectoHorario.Infrastructure -o src/ProyectoHorario.Infrastructure --no-restore

# xunit: plantilla de proyecto de tests con el framework xUnit
dotnet new xunit -n ProyectoHorario.API.Tests -o tests/ProyectoHorario.API.Tests --no-restore
dotnet new xunit -n ProyectoHorario.Core.Tests -o tests/ProyectoHorario.Core.Tests --no-restore
```

> El flag `--no-restore` evita que cada comando descargue dependencias por separado.
> Es mas rapido crear todos los proyectos primero y luego restaurar una sola vez.

### Crear la solucion y añadir los proyectos

El archivo de solucion (`.slnx`) agrupa todos los proyectos. Esto permite compilarlos todos
con un solo comando (`dotnet build`) y abrirlos juntos en el editor.

```bash
# Crea el archivo de solucion en la raiz
dotnet new sln -n ProyectoHorario

# Añade todos los proyectos a la solucion
dotnet sln add src/ProyectoHorario.API/ProyectoHorario.API.csproj \
               src/ProyectoHorario.Core/ProyectoHorario.Core.csproj \
               src/ProyectoHorario.Infrastructure/ProyectoHorario.Infrastructure.csproj \
               tests/ProyectoHorario.API.Tests/ProyectoHorario.API.Tests.csproj \
               tests/ProyectoHorario.Core.Tests/ProyectoHorario.Core.Tests.csproj
```

### Configurar las referencias entre proyectos

Las referencias indican que proyecto puede usar el codigo de cual.
Siguiendo Clean Architecture, Core no depende de nadie, y las capas externas dependen de las internas.

```
API  -->  Infrastructure  -->  Core
 \                              ^
  \-----------------------------/
```

```bash
# API puede usar codigo de Core y de Infrastructure
dotnet add src/ProyectoHorario.API/ProyectoHorario.API.csproj reference \
    src/ProyectoHorario.Core/ProyectoHorario.Core.csproj \
    src/ProyectoHorario.Infrastructure/ProyectoHorario.Infrastructure.csproj

# Infrastructure solo puede usar codigo de Core (no de API)
dotnet add src/ProyectoHorario.Infrastructure/ProyectoHorario.Infrastructure.csproj reference \
    src/ProyectoHorario.Core/ProyectoHorario.Core.csproj
```

---

## 6. Frontend — Vue 3

El frontend es una aplicacion completamente independiente del backend.
Se comunica con la API a traves de peticiones HTTP.

### Crear el proyecto con Vite

**Vite** es la herramienta de construccion que usamos en lugar del antiguo Vue CLI.
Es mucho mas rapida y se ha convertido en el estandar actual para proyectos Vue.

```bash
cd src/ProyectoHorario.Client

# Crea el proyecto Vue con la plantilla de TypeScript
npm create vite@latest . -- --template vue-ts

# Instala las dependencias del proyecto recien creado
npm install
```

### Instalar dependencias adicionales

```bash
# vue-router: gestiona la navegacion entre paginas de la aplicacion
# pinia:      gestiona el estado global de la app (datos compartidos entre componentes)
npm install vue-router@4 pinia
```

---

## 7. Entity Framework Core y SQL Server

**Entity Framework Core (EF Core)** es el ORM (Object-Relational Mapper) que usamos para
interactuar con SQL Server desde C#. Permite trabajar con la base de datos usando clases C#
en lugar de escribir SQL directamente.

### Instalar los paquetes NuGet

Los paquetes NuGet son el sistema de dependencias de .NET, equivalente a npm en JavaScript.

```bash
# Microsoft.EntityFrameworkCore        -> nucleo de EF Core
# Microsoft.EntityFrameworkCore.SqlServer -> conector especifico para SQL Server
# Microsoft.EntityFrameworkCore.Design -> herramientas para generar migraciones
dotnet add src/ProyectoHorario.Infrastructure/ProyectoHorario.Infrastructure.csproj package Microsoft.EntityFrameworkCore
dotnet add src/ProyectoHorario.Infrastructure/ProyectoHorario.Infrastructure.csproj package Microsoft.EntityFrameworkCore.SqlServer
dotnet add src/ProyectoHorario.Infrastructure/ProyectoHorario.Infrastructure.csproj package Microsoft.EntityFrameworkCore.Design

# En API tambien se necesita Design para poder ejecutar comandos de migraciones
dotnet add src/ProyectoHorario.API/ProyectoHorario.API.csproj package Microsoft.EntityFrameworkCore.Design
```

### Datos de conexion a la base de datos

| Parametro | Valor |
|---|---|
| Servidor | `PMADJC1124` |
| Base de datos | `ProyectoHorarios` |
| Autenticacion | SQL Server Authentication |
| Usuario | `desarrollo` |

### Cadena de conexion

La cadena de conexion es el string que le dice a EF Core como conectarse a la base de datos.
Se guarda en `appsettings.json` para no tenerla hardcodeada en el codigo.

Ubicacion: `src/ProyectoHorario.API/appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=PMADJC1124;Database=ProyectoHorarios;User Id=desarrollo;Password=desarrollo;TrustServerCertificate=True;"
  }
}
```

> **IMPORTANTE:** En produccion nunca escribir credenciales directamente en este archivo.
> Usar variables de entorno o un gestor de secretos como Azure Key Vault.

### DbContext

El `AppDbContext` es la clase central de EF Core. Representa una sesion con la base de datos
y es el punto de acceso a todas las tablas. Cada entidad que se quiera persistir se registra aqui.

Ubicacion: `src/ProyectoHorario.Infrastructure/Data/AppDbContext.cs`

```csharp
using Microsoft.EntityFrameworkCore;

namespace ProyectoHorario.Infrastructure.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        // Aqui se configuraran las entidades cuando se vayan añadiendo
    }
}
```

### Registro del DbContext en la API

Para que la API pueda usar el `AppDbContext`, hay que registrarlo en el sistema de inyeccion de dependencias.
Esto se hace en `Program.cs`:

```csharp
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
```

Con esto, cualquier controlador o servicio puede recibir el `AppDbContext` automaticamente
sin necesidad de instanciarlo manualmente.

### Comandos de migraciones (para cuando se añadan entidades)

Las **migraciones** son archivos que describen los cambios en la estructura de la base de datos.
Cada vez que se añade o modifica una entidad, hay que crear una migracion y aplicarla.

```bash
# Solo la primera vez: instalar la herramienta global de EF Core
dotnet tool install --global dotnet-ef

# Crear una nueva migracion (reemplazar 'NombreDeLaMigracion' por algo descriptivo, ej: 'AgregarTablaEmpleados')
dotnet ef migrations add NombreDeLaMigracion \
    --project src/ProyectoHorario.Infrastructure \
    --startup-project src/ProyectoHorario.API

# Aplicar las migraciones pendientes a la base de datos
dotnet ef database update \
    --project src/ProyectoHorario.Infrastructure \
    --startup-project src/ProyectoHorario.API
```

---

## 8. Verificacion final

Una vez completados todos los pasos anteriores, ejecuta estos comandos para confirmar que todo funciona.

```bash
# Compila toda la solucion. Debe terminar con '0 Errores'
dotnet build

# Arranca la API (disponible por defecto en https://localhost:7xxx)
dotnet run --project src/ProyectoHorario.API

# Arranca el frontend en modo desarrollo (disponible en http://localhost:5173)
cd src/ProyectoHorario.Client
npm run dev
```
