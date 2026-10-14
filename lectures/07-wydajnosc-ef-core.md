# Wykład 07 — Wydajność ORM: N+1, indeksy i plany wykonania

**Data:** 24.01.2027  
**Czas:** 45 minut zegarowych  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student rozpoznaje typowe antywzorce i proponuje pomiar zamiast intuicyjnej optymalizacji.

## Tok wykładu

### 1. Koszty zapytań

Round-trip, liczba wierszy, szerokość wiersza, CPU, IO i czas materializacji; obserwuj wynik w SQL Server, nie tylko czas C#.

### 2. N+1 oraz Include

Wielokrotne zapytania przy lazy loading; Include może prowadzić do Cartesian explosion; split query ma własne koszty.

### 3. Profilowanie

EF logging, ToQueryString, SET STATISTICS IO/TIME, actual execution plan; Query Store do analizy dłuższych trendów.

### 4. Optymalizacje

Projekcje DTO, AsNoTracking, odpowiednie indeksy, paginacja, operacje zbiorowe; kompilowane zapytania tylko po pomiarze.

## Przykład do omówienia

```csharp
var result = await db.Orders
    .AsNoTracking()
    .Where(o => o.Lines.Sum(l => l.UnitPrice * l.Quantity) > 100)
    .Select(o => new { o.Id, Customer = o.Customer.Name })
    .Take(50)
    .ToListAsync();
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Która wersja jest szybsza: Include całego grafu czy projekcja trzech pól? Jak to uczciwie zmierzyć?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 07: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
