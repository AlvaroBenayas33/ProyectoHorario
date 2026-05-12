namespace ProyectoHorario.Core.Entities;

public class Usuario
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Apellidos { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public int RolId { get; set; }
    public bool Activo { get; set; } = true;
    public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;

    public Rol Rol { get; set; } = null!;
    public ICollection<Horario> HorariosCreados { get; set; } = [];
    public ICollection<AsignacionManager> Asignaciones { get; set; } = [];
    public ICollection<AusenciaUsuario> Ausencias { get; set; } = [];
}
