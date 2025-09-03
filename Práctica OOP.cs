using System;
using System.Collections.Generic; 
public class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("--- 1. Clase Persona y Estudiante ---");

        Persona persona1 = new Persona("Ana López", 30, "Madrid");
        persona1.MostrarInformacion();

        Console.WriteLine(); 

        
        Estudiante estudiante1 = new Estudiante("Carlos Ruiz", 22, "Barcelona", "Ingeniería de Software", "S-2024-001");
        estudiante1.MostrarInformacionCompleta();

        Console.WriteLine("\n-----------------------------------------------\n");

        Console.WriteLine("--- 3. Polimorfismo con Figuras ---");

        List<Figura> misFiguras = new List<Figura>
        {
            new Rectangulo(10, 5),
            new Circulo(7),          
            new Triangulo(8, 4)     
        };

        foreach (var figura in misFiguras)
        {
            Console.WriteLine($"El área de un {figura.GetType().Name} es: {figura.CalcularArea():F2}");
        }
    }
}
public class Persona
{
    public string Nombre { get; set; }
    public int Edad { get; set; }
    public string Ciudad { get; set; }

    public Persona(string nombre, int edad, string ciudad)
    {
        Nombre = nombre;
        Edad = edad;
        Ciudad = ciudad;
    }

    public void MostrarInformacion()
    {
        Console.WriteLine($"Nombre: {Nombre}, Edad: {Edad}, Ciudad: {Ciudad}");
    }

    public int CalcularEdadEnAnios()
    {
   
        return Edad;
    }
}

public class Estudiante : Persona
{
    public string Carrera { get; set; }
    public string Matricula { get; set; }

    public Estudiante(string nombre, int edad, string ciudad, string carrera, string matricula)
        : base(nombre, edad, ciudad)
    {
        Carrera = carrera;
        Matricula = matricula;
    }

    public void MostrarInformacionCompleta()
    {
        base.MostrarInformacion();
        Console.WriteLine($"Carrera: {Carrera}, Matrícula: {Matricula}");
    }
}

public abstract class Figura
{
    public abstract double CalcularArea();
}

public class Rectangulo : Figura
{
    public double Base { get; set; }
    public double Altura { get; set; }

    public Rectangulo(double @base, double altura)
    {
        Base = @base; 
        Altura = altura;
    }

    public override double CalcularArea()
    {
        return Base * Altura;
    }
}

public class Circulo : Figura
{
    public double Radio { get; set; }

    public Circulo(double radio)
    {
        Radio = radio;
    }

    public override double CalcularArea()
    {
        return Math.PI * Radio * Radio;
    }
}

public class Triangulo : Figura
{
    public double Base { get; set; }
    public double Altura { get; set; }

    public Triangulo(double @base, double altura)
    {
        Base = @base;
        Altura = altura;
    }

    public override double CalcularArea()
    {
        return (Base * Altura) / 2;
    }
}