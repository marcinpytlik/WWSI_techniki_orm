# Wykład 04 — LINQ, translacja i wykonywanie zapytań

**Data:** 06.12.2026  
**Czas:** 45 minut zegarowych  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student rozróżnia zapytanie LINQ od rzeczywiście generowanego SQL i potrafi opisać jego wykonanie.

## Tok wykładu

### 1. IQueryable vs IEnumerable

Budowanie drzewa wyrażeń a wykonywanie po stronie klienta; moment materializacji i rola operatorów terminalnych.

### 2. Translacja do T-SQL

Where, Select, Join, OrderBy, Take; parametryzacja; ToQueryString do analizy, a logowanie do obserwacji wykonywania.

### 3. Projekcja i paginacja

Zwracaj tylko potrzebne kolumny; stabilne sortowanie; OFFSET/FETCH i alternatywa keyset pagination.

### 4. Ładowanie relacji

Eager, explicit, lazy loading; Include, AsSplitQuery i konsekwencje liczby zapytań.

## Przykład do omówienia

```csharp
var customers = await db.Customers
    .OrderBy(c => c.Id)
    .Take(100)
    .Include(c => c.Orders)
    .ToListAsync();
Console.WriteLine(db.Customers
    .Where(c => c.Name.StartsWith("A"))
    .ToQueryString());
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Dlaczego Include wraz z Take może prowadzić do podzapytania w FROM, a potem LEFT JOIN?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 04: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
