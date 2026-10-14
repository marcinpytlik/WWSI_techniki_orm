# Wykład 03 — Relacje, klucze i integralność danych

**Data:** 22.11.2026  
**Czas:** 45 minut zegarowych  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student umie narysować relacje i przewidzieć wpływ mapowania na ograniczenia SQL Server.

## Tok wykładu

### 1. Typy relacji

1:1, 1:N, N:M; klucze główne, obce, tabelka łącznikowa i właściwości nawigacyjne.

### 2. Właścicielstwo relacji

Principal/dependent, klucz obcy w tabeli zależnej, relacja opcjonalna a required.

### 3. Usuwanie i spójność

DeleteBehavior, ograniczenia FK, cascade i restrict/no action — skutki dla danych.

### 4. Modelowanie a SQL

Indeksy na FK, kardynalność, koszt JOIN, separacja odpowiedzialności między EF Core i bazą.

## Przykład do omówienia

```csharp
modelBuilder.Entity<Order>()
    .HasOne(x => x.Customer)
    .WithMany(x => x.Orders)
    .HasForeignKey(x => x.CustomerId)
    .OnDelete(DeleteBehavior.Restrict);
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Czy dodanie właściwości ICollection gwarantuje wydajne pobieranie kolekcji?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 03: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
