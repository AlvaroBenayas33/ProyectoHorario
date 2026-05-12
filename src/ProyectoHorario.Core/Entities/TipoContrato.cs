namespace ProyectoHorario.Core.Entities;

public class TipoContrato
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;

    public ICollection<Trabajador> Trabajadores { get; set; } = [];
}
