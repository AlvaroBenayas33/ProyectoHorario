namespace ProyectoHorario.Core.Entities;

public class TipoAusencia
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;

    public ICollection<AusenciaTrabajador> AusenciasTrabajador { get; set; } = [];
    public ICollection<AusenciaUsuario> AusenciasUsuario { get; set; } = [];
}
