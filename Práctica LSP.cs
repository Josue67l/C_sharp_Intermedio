using System;

public class Práctica_LSP
{
    protected double _base;
    protected double _altura;

    public virtual double Base
    {
        get { return _base; }
        set { _base = value; }
    }

    public virtual double Altura
    {
        get { return _altura; }
        set { _altura = value; }
    }

    public Práctica_LSP(double @base, double altura)
    {
        Base = @base;
        Altura = altura;
    }

    public virtual double CalcularArea()
    {
        return Base * Altura;
    }
}

// Clase derivada Rectangulo
public class Rectangulo : Práctica_LSP
{
    public Rectangulo(double @base, double altura) : base(@base, altura)
    {
    }
}

// Clase derivada Cuadrado (Cumpliendo con LSP)
public class Cuadrado : Práctica_LSP
{
    public Cuadrado(double lado) : base(lado, lado)
    {
    }

    // Sobrescribir los setters para forzar el invariante del cuadrado:
    // Si la base cambia, la altura también cambia. Si la altura cambia, la base también cambia.
    public override double Base
    {
        get { return _base; }
        set
        {
            _base = value;
            _altura = value; // Mantener invariante: la altura debe ser igual a la base
        }
    }

    public override double Altura
    {
        get { return _altura; }
        set
        {
            _altura = value;
            _base = value; // Mantener invariante: la base debe ser igual a la altura
        }
    }

    public override double CalcularArea()
    {
        return Base * Base;
    }
}


public class ProgramRefactorizado
{
    public static void Main(string[] args)
    {
        Console.WriteLine("\n--- Ejercicio 2: Refactorización para cumplir con LSP ---");

        // Rectangulo
        Rectangulo rectangulo = new Rectangulo(10, 5);
        Console.WriteLine($"Área del Rectángulo (10x5): {rectangulo.CalcularArea()}"); // Esperado: 50

        // Cuadrado (LSP Compliant)
        Cuadrado cuadradoLSP = new Cuadrado(6);
        Console.WriteLine($"Área del Cuadrado (lado 6 - Cumple LSP): {cuadradoLSP.CalcularArea()}"); // Esperado: 36

        // Probar el cambio de lado en Cuadrado y el cumplimiento de LSP
        Console.WriteLine("\nProbando cambio de lado en Cuadrado (Cumple LSP):");
        cuadradoLSP.Base = 8;
        Console.WriteLine($"Área del Cuadrado (lado 8 después de cambio): {cuadradoLSP.CalcularArea()}");
        Console.WriteLine($"Base del Cuadrado: {cuadradoLSP.Base}, Altura del Cuadrado: {cuadradoLSP.Altura}");


        Console.WriteLine("\nProbando sustitución con FiguraGeometrica (Cumple LSP):");
        Práctica_LSP fig3 = new Rectangulo(8, 4);
        Console.WriteLine($"Área de FiguraGeometrica (Rectángulo 8x4): {fig3.CalcularArea()}");

        Práctica_LSP fig4 = new Cuadrado(7);
        Console.WriteLine($"Área de FiguraGeometrica (Cuadrado 7x7 - Cumple LSP): {fig4.CalcularArea()}");

        // Demostrar la sustitución al modificar dimensiones a través de una referencia a la clase base
        Console.WriteLine("\nProbando modificación de dimensiones a través de referencia a FiguraGeometrica:");
        Console.WriteLine("FiguraGeometrica para un cuadrado (lado 7):");
        Console.WriteLine($"Original: Base={fig4.Base}, Altura={fig4.Altura}, Area={fig4.CalcularArea()}");

        fig4.Altura = 10;
        Console.WriteLine($"Después de fig4.Altura = 10:");
        Console.WriteLine($"Nuevo: Base={fig4.Base}, Altura={fig4.Altura}, Area={fig4.CalcularArea()}");

        Console.WriteLine("\nFiguraGeometrica para un rectángulo (8x4):");
        Console.WriteLine($"Original: Base={fig3.Base}, Altura={fig3.Altura}, Area={fig3.CalcularArea()}");

        fig3.Base = 12;
        Console.WriteLine($"Después de fig3.Base = 12:");
        Console.WriteLine($"Nuevo: Base={fig3.Base}, Altura={fig3.Altura}, Area={fig3.CalcularArea()}");


        Console.WriteLine("\nConclusión: El programa ahora funciona correctamente con todas las clases,");
        Console.WriteLine("y la clase Cuadrado se comporta de manera predecible y consistente");
        Console.WriteLine("cuando se sustituye por su tipo base FiguraGeometrica, porque mantiene");
        Console.WriteLine("su invariante de que Base y Altura siempre son iguales.");
    }
}