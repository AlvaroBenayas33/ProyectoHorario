namespace ProyectoHorario.Core.Entities;

public class AusenciaTrabajador
{
    public int Id { get; set; }
    public int TrabajadorId { get; set; }
    public int TipoAusenciaId { get; set; }
    public DateOnly FechaInicio { get; set; }
    public DateOnly FechaFin { get; set; }
    public string? Observaciones { get; set; }

    public Trabajador Trabajador { get; set; } = null!;
    public TipoAusencia TipoAusencia { get; set; } = null!;
}
