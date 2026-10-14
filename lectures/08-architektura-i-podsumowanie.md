# Wykład 08 — Architektura dostępu do danych, testowanie i podsumowanie

**Data:** termin do ustalenia  
**Czas:** 100 minut zegarowych według planu (wymaga potwierdzenia rozliczenia dydaktycznego)  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student uzasadnia architekturę dostępu do danych i potrafi wskazać ryzyka testów niezgodnych z produkcyjnym providerem.

## Tok wykładu

### 1. Architektura aplikacji

Warstwy API → usługi → DbContext → SQL Server; odpowiedzialność serwisów, transakcje, konfiguracja DI.

### 2. Repozytorium i Unit of Work

Czy opakowywać DbContext dodatkowym repository? Kiedy abstrakcja pomaga, kiedy ukrywa LINQ oraz szczegóły wydajnościowe.

### 3. Testowanie

Testy integracyjne na rzeczywistym SQL Server; ograniczenia providerów InMemory/SQLite jako zamienników semantyki T-SQL.

### 4. Podsumowanie i kryteria

Dobry ORM wymaga modelu domenowego, kontroli wygenerowanego SQL, pomiarów i rozsądnej strategii migracji.

## Przykład do omówienia

```csharp
// Przykładowy punkt rejestracji DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("Sql")));
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Jakie trzy rzeczy sprawdzisz przed wdrożeniem nowego zapytania EF Core do systemu produkcyjnego?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 08: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
