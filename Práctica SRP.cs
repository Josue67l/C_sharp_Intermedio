// Clase Persona: Solo gestiona los datos de la persona
using System;

public class Persona
{
    public string Nombre { get; set; }
    public int Edad { get; set; }
    public string Direccion { get; set; }
    public string CorreoElectronico { get; set; }

    public Persona(string nombre, int edad, string direccion, string correoElectronico)
    {
        Nombre = nombre;
        Edad = edad;
        Direccion = direccion;
        CorreoElectronico = correoElectronico;
    }
}

// Clase ServicioNotificacion: Se encarga de enviar notificaciones (en este caso, email)
public class ServicioNotificacion
{
    public void EnviarCorreoElectronico(string destinatario, string mensaje)
    {
        // Lógica para enviar correo electrónico
        Console.WriteLine($"Enviando correo a {destinatario}: {mensaje}");
        // Aquí iría la implementación real del envío de correo
    }
}

// Clase ImpresoraDatosPersona: Se encarga de mostrar los datos de la persona
public class ImpresoraDatosPersona
{
    public void ImprimirDatos(Persona persona)
    {
        Console.WriteLine($"Nombre: {persona.Nombre}");
        Console.WriteLine($"Edad: {persona.Edad}");
        Console.WriteLine($"Dirección: {persona.Direccion}");
        Console.WriteLine($"Correo electrónico: {persona.CorreoElectronico}");
    }
}

// Ejemplo de uso:
public class Programa
{
    public static void Main(string[] args)
    {
        // Crear una instancia de Persona
        Persona persona = new Persona("Juan Pérez", 30, "Calle Falsa 123", "juan.perez@example.com");

        // Usar la clase ImpresoraDatosPersona para mostrar los datos
        ImpresoraDatosPersona impresora = new ImpresoraDatosPersona();
        impresora.ImprimirDatos(persona);

        // Usar la clase ServicioNotificacion para enviar un correo
        ServicioNotificacion servicioNotificacion = new ServicioNotificacion();
        servicioNotificacion.EnviarCorreoElectronico(persona.CorreoElectronico, "¡Hola! Este es un correo de prueba.");
    }
}