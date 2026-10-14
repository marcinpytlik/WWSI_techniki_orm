# Wykład 02 — Encje, DbContext, mapowanie i migracje

**Data:** 08.11.2026  
**Czas:** 45 minut zegarowych  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student odróżnia konfigurację modelu od modyfikacji schematu oraz umie wskazać zagrożenia migracji.

## Tok wykładu

### 1. Model domenowy i schemat

Encja nie jest kopią tabeli 1:1 w każdym scenariuszu. Klucze, required/optional, nullable reference types, wartości domyślne.

### 2. Konwencje i Fluent API

Konwencje ułatwiają start; Fluent API umożliwia jawne nazwy tabel, długości, precyzję decimal, klucze i indeksy.

### 3. Migrations

Model snapshot, Up/Down, różnice schematu, skrypt SQL; migracja jest zmianą operacyjną, którą w produkcji trzeba przejrzeć.

### 4. Code First vs Database First

Dobór podejścia do nowych i istniejących baz; scaffolding nie zastępuje przeglądu modelu.

## Przykład do omówienia

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Product>(e =>
    {
        e.HasKey(x => x.Id);
        e.Property(x => x.Name).HasMaxLength(120).IsRequired();
        e.Property(x => x.Price).HasPrecision(18, 2);
        e.HasIndex(x => x.Sku).IsUnique();
    });
}
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Co może pójść źle, jeśli bez przeglądu wykonamy migrację usuwającą kolumnę z danymi?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 02: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
