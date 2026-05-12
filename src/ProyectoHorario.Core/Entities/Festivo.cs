namespace ProyectoHorario.Core.Entities;

public class Festivo
{
    public int Id { get; set; }
    public DateOnly Fecha { get; set; }
    public string Descripcion { get; set; } = string.Empty;
}
