using Microsoft.EntityFrameworkCore;
using ProyectoHorario.Core.Entities;

namespace ProyectoHorario.Infrastructure.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Rol> Roles { get; set; }
    public DbSet<Usuario> Usuarios { get; set; }
    public DbSet<TipoContrato> TiposContrato { get; set; }
    public DbSet<Turno> Turnos { get; set; }
    public DbSet<Trabajador> Trabajadores { get; set; }
    public DbSet<TipoAusencia> TiposAusencia { get; set; }
    public DbSet<AusenciaTrabajador> AusenciasTrabajador { get; set; }
    public DbSet<AusenciaUsuario> AusenciasUsuario { get; set; }
    public DbSet<Horario> Horarios { get; set; }
    public DbSet<AsignacionTrabajador> AsignacionesTrabajador { get; set; }
    public DbSet<AsignacionManager> AsignacionesManager { get; set; }
    public DbSet<Festivo> Festivos { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Rol>()
            .HasIndex(r => r.Nombre).IsUnique();

        modelBuilder.Entity<Usuario>()
            .HasIndex(u => u.Email).IsUnique();

        modelBuilder.Entity<Trabajador>()
            .HasIndex(t => t.DNI).IsUnique();

        modelBuilder.Entity<Festivo>()
            .HasIndex(f => f.Fecha).IsUnique();

        // Un trabajador no puede tener dos turnos el mismo dia en el mismo horario
        modelBuilder.Entity<AsignacionTrabajador>()
            .HasIndex(a => new { a.HorarioId, a.TrabajadorId, a.Fecha }).IsUnique();

        // Un manager no puede tener dos turnos el mismo dia en el mismo horario
        modelBuilder.Entity<AsignacionManager>()
            .HasIndex(a => new { a.HorarioId, a.UsuarioId, a.Fecha }).IsUnique();

        // Tabla AsignacionesManager -> nombre de tabla explicito para evitar pluralizacion incorrecta
        modelBuilder.Entity<AsignacionManager>()
            .ToTable("AsignacionesManager");
    }
}
