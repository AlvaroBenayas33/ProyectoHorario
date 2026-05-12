namespace ProyectoHorario.Core.Entities;

public class AsignacionManager
{
    public int Id { get; set; }
    public int HorarioId { get; set; }
    public int UsuarioId { get; set; }
    public DateOnly Fecha { get; set; }
    public int TurnoId { get; set; }

    public Horario Horario { get; set; } = null!;
    public Usuario Usuario { get; set; } = null!;
    public Turno Turno { get; set; } = null!;
}
