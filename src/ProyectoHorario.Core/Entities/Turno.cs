namespace ProyectoHorario.Core.Entities;

public class Turno
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public TimeOnly HoraInicio { get; set; }
    public TimeOnly HoraFin { get; set; }

    public ICollection<Trabajador> Trabajadores { get; set; } = [];
    public ICollection<AsignacionTrabajador> AsignacionesTrabajador { get; set; } = [];
    public ICollection<AsignacionManager> AsignacionesManager { get; set; } = [];
}
