namespace ProyectoHorario.Core.Entities;

public class Horario
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public DateOnly FechaInicio { get; set; }
    public DateOnly FechaFin { get; set; }
    public int CreadoPorId { get; set; }
    public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;

    public Usuario CreadoPor { get; set; } = null!;
    public ICollection<AsignacionTrabajador> AsignacionesTrabajador { get; set; } = [];
    public ICollection<AsignacionManager> AsignacionesManager { get; set; } = [];
}
