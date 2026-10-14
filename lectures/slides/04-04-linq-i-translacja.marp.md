---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 04 · 06.12.2026'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 40px; }
  pre { background: #f0f4f8; }
  code { font-size: 0.77em; }
  table { font-size: 0.72em; }
---

# LINQ i translacja do SQL

**Wykład 04 · 06.12.2026**

C# · Entity Framework Core 10 · SQL Server 2022 CU26

<!-- NOTATKI: Otwarcie i powtórzenie poprzedniego spotkania. -->

---

# LINQ nie jest SQL

LINQ to język zapytań w C#; provider EF Core decyduje o translacji.

<!--
NOTATKI PROWADZĄCEGO — slajd 2
To samo wyrażenie nie musi działać identycznie u każdego providera.
-->

---

# IQueryable i IEnumerable

IQueryable buduje zapytanie dostawcy; IEnumerable operuje na sekwencji .NET.

<!--
NOTATKI PROWADZĄCEGO — slajd 3
Wyjaśnij granicę wykonywania po stronie klienta.
-->

---

# Deferred execution

```csharp
var query = db.Products.Where(p => p.Price > 100);
// SQL jeszcze nie został wykonany
var list = await query.ToListAsync();
```

<!--
NOTATKI PROWADZĄCEGO — slajd 4
Metoda terminalna rozpoczyna wykonanie.
-->

---

# Where i parametry

```csharp
var minPrice = 100m;
var q = db.Products.Where(p => p.Price >= minPrice);
Console.WriteLine(q.ToQueryString());
```

<!--
NOTATKI PROWADZĄCEGO — slajd 5
SQL Server otrzyma parametryzowane zapytanie; sprawdź typ.
-->

---

# Select i projekcja

```csharp
var q = db.Products.Select(p => new { p.Id, p.Name });
```

<!--
NOTATKI PROWADZĄCEGO — slajd 6
Projekcja ogranicza ilość pobieranych danych.
-->

---

# Sortowanie i Take

```csharp
var q = db.Products.OrderBy(p => p.Id).Take(20);
```

<!--
NOTATKI PROWADZĄCEGO — slajd 7
Bez stabilnego ORDER BY paginacja bywa niedeterministyczna.
-->

---

# OFFSET vs keyset

Skip/Take → OFFSET/FETCH.

Keyset: Where(Id > lastId).OrderBy(Id).Take(n).

<!--
NOTATKI PROWADZĄCEGO — slajd 8
Pokaż ograniczenia offset dla głębokich stron.
-->

---

# Include i JOIN

```csharp
var q = db.Customers.Include(c => c.Orders);
```

<!--
NOTATKI PROWADZĄCEGO — slajd 9
Eager loading może rozszerzyć wynik i powielić dane klienta.
-->

---

# Include z Take

```csharp
var q = db.Customers
 .OrderBy(c => c.Id).Take(100)
 .Include(c => c.Orders);
```

<!--
NOTATKI PROWADZĄCEGO — slajd 10
Dlaczego provider często opakowuje ograniczenie rodziców w podzapytanie?
-->

---

# Single i split query

AsSingleQuery() versus AsSplitQuery().

Mniej round-tripów ≠ zawsze mniej pracy.

<!--
NOTATKI PROWADZĄCEGO — slajd 11
Dyskusja o cartesian explosion i spójności pomiędzy zapytaniami.
-->

---

# Gdzie kończy się translacja?

Nie wszystkie funkcje C# można zamienić na T-SQL.

Weryfikuj wyjątki translacji i granicę client evaluation.

<!--
NOTATKI PROWADZĄCEGO — slajd 12
Nie wyciągaj wszystkich wierszy do pamięci bez uzasadnienia.
-->

---

# Podsumowanie

**Kod LINQ jest specyfikacją zapytania, a nie jego planem wykonania.**

<!--
NOTATKI PROWADZĄCEGO — slajd 13
Poproś studentów o przewidzenie wygenerowanego SQL.
-->
