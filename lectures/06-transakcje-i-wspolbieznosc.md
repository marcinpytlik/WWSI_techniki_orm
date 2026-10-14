# Wykład 06 — Transakcje i współbieżność w aplikacjach ORM

**Data:** 17.01.2027  
**Czas:** 45 minut zegarowych  
**Technologie:** C#, EF Core 10, SQL Server 2022 CU26

## Cel wykładu

Student wyjaśnia optimistic concurrency i potrafi opisać sposób obsługi konfliktu zapisu.

## Tok wykładu

### 1. ACID w praktyce

Granice transakcji, izolacja, blokady, deadlock, timeout; nie utożsamiaj SaveChanges z pełną transakcją biznesową.

### 2. Współbieżność optymistyczna

Concurrency token i rowversion; UPDATE z warunkiem na wersję, DbUpdateConcurrencyException, strategie rozstrzygnięcia konfliktu.

### 3. Transakcje jawne

BeginTransactionAsync, CommitAsync, RollbackAsync, obsługa wyjątków; ryzyko długich transakcji.

### 4. Retries i idempotencja

Execution strategies i ostrożność wobec powtórzeń operacji o skutkach ubocznych; integralność chroniona w bazie.

## Przykład do omówienia

```csharp
modelBuilder.Entity<Product>()
    .Property(p => p.RowVersion)
    .IsRowVersion();
// w Product: public byte[] RowVersion { get; set; } = null!;
```

**Komentarz prowadzącego:** Przejdź od znaczenia instrukcji C# do operacji wykonanej przez SQL Server. Rozróżnij opis koncepcyjny od dokładnego T-SQL zależnego od modelu i wersji providera. Przykłady są fragmentami do omówienia; pełny kompilowalny projekt znajdzie się w laboratoriach.

## Pytanie do dyskusji

> Dwóch użytkowników edytuje tę samą cenę — czy ostatni zapis zawsze powinien wygrać?

## Sprawdzenie zrozumienia

- Poproś studenta o własne wyjaśnienie najważniejszej różnicy między zachowaniem EF Core i relacyjnej bazy danych.
- Poproś o przewidzenie operacji SQL lub ograniczenia bazy dla zaprezentowanego przykładu.
- Zidentyfikuj jeden potencjalny problem produkcyjny oraz sposób jego weryfikacji.

## Powiązanie z laboratorium

Lab 06: zastosowanie przedstawionych mechanizmów w aplikacji podłączonej do SQL Server 2022 CU26.

## Źródła referencyjne

- [EF Core — dokumentacja Microsoft](https://learn.microsoft.com/ef/core/)
- [SQL Server — dokumentacja Microsoft](https://learn.microsoft.com/sql/sql-server/)
