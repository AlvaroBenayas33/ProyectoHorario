namespace ProyectoHorario.Core.Entities;

public class Trabajador
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Apellidos { get; set; } = string.Empty;
    public string DNI { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? Telefono { get; set; }
    public int TipoContratoId { get; set; }
    public int TurnoId { get; set; }
    public bool TieneConciliacionFamiliar { get; set; } = false;
    public bool Activo { get; set; } = true;
    public DateOnly FechaAlta { get; set; }

    public TipoContrato TipoContrato { get; set; } = null!;
    public Turno Turno { get; set; } = null!;
    public ICollection<AsignacionTrabajador> Asignaciones { get; set; } = [];
    public ICollection<AusenciaTrabajador> Ausencias { get; set; } = [];
}
