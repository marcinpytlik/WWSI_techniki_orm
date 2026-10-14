# Wykład 01 — Wprowadzenie do ORM i architektury EF Core

**Data:** 25.10.2026  
**Czas:** 45 minut zegarowych  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student potrafi nazwać warstwy EF Core i wyjaśnić, dlaczego kod C# nie jest planem wykonania SQL.

## Tok wykładu

### 1. Dlaczego ORM?

Impedance mismatch: obiekty, dziedziczenie i graf referencji kontra tabele, klucze obce, zbiory i NULL. ORM mapuje dane; nie eliminuje konieczności rozumienia SQL.

### 2. Architektura

Aplikacja → LINQ → provider EF Core → T-SQL → SQL Server; wyniki → materializacja encji; DbContext pełni rolę jednostki pracy.

### 3. ORM i alternatywy

Porównaj EF Core, ADO.NET i micro-ORM (np. Dapper): produktywność, kontrola SQL, testowanie, wydajność, złożoność modelu.

### 4. Kiedy ORM przeszkadza?

Wysokowolumenowe operacje, nietypowe zapytania i ukryta liczba round-tripów; dostępny SQL surowy i procedury, ale należy dbać o parametryzację.

## Przykład do omówienia

```csharp
public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public List<Order> Orders { get; set; } = [];
}
public class Order
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public Customer Customer { get; set; } = null!;
}
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Załóżmy, że ekran pokazuje listę 100 klientów z zamówieniami. Ile zapytań SQL wygeneruje implementacja i od czego to zależy?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 01: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
