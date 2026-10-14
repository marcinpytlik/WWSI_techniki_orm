---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 06 · 17.01.2027'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 40px; }
  pre { background: #f0f4f8; }
  code { font-size: 0.77em; }
  table { font-size: 0.72em; }
---

# Transakcje i współbieżność

**Wykład 06 · 17.01.2027**

C# · Entity Framework Core 10 · SQL Server 2022 CU26

<!-- NOTATKI: Otwarcie i powtórzenie poprzedniego spotkania. -->

---

# Czym jest transakcja?

ACID: atomowość, spójność, izolacja, trwałość.

<!--
NOTATKI PROWADZĄCEGO — slajd 2
Różnica między żądaniem HTTP a transakcją SQL.
-->

---

# SaveChanges i atomowość

Zmiany jednego SaveChanges w relacyjnej bazie zwykle są wykonywane atomowo.

<!--
NOTATKI PROWADZĄCEGO — slajd 3
Omów ograniczenia i zachowanie błędów.
-->

---

# Jawna transakcja

```csharp
await using var tx = await db.Database.BeginTransactionAsync();
// operacje
await db.SaveChangesAsync();
await tx.CommitAsync();
```

<!--
NOTATKI PROWADZĄCEGO — slajd 4
W praktyce konieczne są try/catch i decyzja rollback.
-->

---

# Poziomy izolacji

Read Committed, Snapshot, Serializable; izolacja a współbieżność.

<!--
NOTATKI PROWADZĄCEGO — slajd 5
W SQL Server ustawienia RCSI/SI zmieniają zachowanie.
-->

---

# Blokady i deadlock

Transakcje rywalizują o zasoby; czas transakcji ma znaczenie.

<!--
NOTATKI PROWADZĄCEGO — slajd 6
Deadlock victim musi bezpiecznie powtórzyć operację biznesową.
-->

---

# Lost update

Dwóch użytkowników zmienia to samo pole.

Który zapis zwycięży?

<!--
NOTATKI PROWADZĄCEGO — slajd 7
Scenariusz do dyskusji.
-->

---

# Optimistic concurrency

Token wersji do wykrywania konfliktów aktualizacji.

<!--
NOTATKI PROWADZĄCEGO — slajd 8
To nie blokowanie rekordu przed zmianą.
-->

---

# rowversion w SQL Server

```csharp
public byte[] RowVersion { get; set; } = [];
// Fluent API: Property(x => x.RowVersion).IsRowVersion();
```

<!--
NOTATKI PROWADZĄCEGO — slajd 9
rowversion to licznik binarny, nie data i godzina.
-->

---

# Jak wygląda UPDATE?

```sql
UPDATE dbo.Products SET Price = @price
WHERE Id = @id AND RowVersion = @originalVersion;
```

0 wierszy → możliwy konflikt współbieżności.

<!--
NOTATKI PROWADZĄCEGO — slajd 10
Pokaż ideę, nie obiecuj dosłownego SQL providera.
-->

---

# Obsługa konfliktu

DbUpdateConcurrencyException → reload / merge / odrzucenie zmian.

<!--
NOTATKI PROWADZĄCEGO — slajd 11
Wybór jest decyzją aplikacyjną.
-->

---

# Retry i idempotencja

Powtórzenie transakcji może mieć skutki uboczne.

Uważaj na wywołania zewnętrzne w trakcie retry.

<!--
NOTATKI PROWADZĄCEGO — slajd 12
Execution strategy powinna obejmować sensowną jednostkę pracy.
-->

---

# Podsumowanie

Transakcje zapewniają spójność, ale izolacja i czas życia mają koszt.

<!--
NOTATKI PROWADZĄCEGO — slajd 13
Zapowiedź wydajności.
-->
