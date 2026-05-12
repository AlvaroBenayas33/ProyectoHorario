namespace ProyectoHorario.Core.Entities;

public class AusenciaUsuario
{
    public int Id { get; set; }
    public int UsuarioId { get; set; }
    public int TipoAusenciaId { get; set; }
    public DateOnly FechaInicio { get; set; }
    public DateOnly FechaFin { get; set; }
    public string? Observaciones { get; set; }

    public Usuario Usuario { get; set; } = null!;
    public TipoAusencia TipoAusencia { get; set; } = null!;
}
