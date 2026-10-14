# Wykład 05 — Change Tracker, CRUD i cykl życia encji

**Data:** 20.12.2026  
**Czas:** 45 minut zegarowych  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student zna stany encji i rozumie, skąd EF Core wie, które operacje DML wykonać.

## Tok wykładu

### 1. Śledzenie encji

Stany Detached, Unchanged, Added, Modified, Deleted; identity resolution, zakres życia DbContext.

### 2. SaveChanges

DetectChanges, jednostka pracy, SQL INSERT/UPDATE/DELETE; transakcja domyślna przy SaveChanges dla relacyjnych providerów, gdy to możliwe.

### 3. Tracking i no-tracking

AsNoTracking dla odczytów; modyfikacja grafu odłączonego, ryzyko Update ustawiającego wszystkie pola.

### 4. Walidacja

Walidacja aplikacyjna kontra constraints w bazie; błędy zapisu, unikalność i wyjątki.

## Przykład do omówienia

```csharp
var customer = await db.Customers.FindAsync(customerId);
if (customer is null) return;
customer.Name = "Nowa nazwa";
await db.SaveChangesAsync();
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Czy wywołanie Update na encji otrzymanej z API jest równoważne zmianie tylko jednego pola?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 05: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
