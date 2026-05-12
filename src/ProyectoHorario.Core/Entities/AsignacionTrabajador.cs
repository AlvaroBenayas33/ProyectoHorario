namespace ProyectoHorario.Core.Entities;

public class AsignacionTrabajador
{
    public int Id { get; set; }
    public int HorarioId { get; set; }
    public int TrabajadorId { get; set; }
    public DateOnly Fecha { get; set; }
    public int TurnoId { get; set; }

    public Horario Horario { get; set; } = null!;
    public Trabajador Trabajador { get; set; } = null!;
    public Turno Turno { get; set; } = null!;
}
