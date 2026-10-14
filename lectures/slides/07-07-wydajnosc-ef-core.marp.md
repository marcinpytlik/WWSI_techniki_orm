---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 07 · 24.01.2027'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 40px; }
  pre { background: #f0f4f8; }
  code { font-size: 0.77em; }
  table { font-size: 0.72em; }
---

# Wydajność ORM i analiza SQL

**Wykład 07 · 24.01.2027**

C# · Entity Framework Core 10 · SQL Server 2022 CU26

<!-- NOTATKI: Otwarcie i powtórzenie poprzedniego spotkania. -->

---

# Czy ORM jest wolny?

Nie ma jednej odpowiedzi.

Koszt = SQL + sieć + materializacja + tracking.

<!--
NOTATKI PROWADZĄCEGO — slajd 2
Porównuj przy tym samym obciążeniu i danych.
-->

---

# N+1

Lista N klientów i osobny SELECT zamówień dla każdego → N+1 zapytań.

<!--
NOTATKI PROWADZĄCEGO — slajd 3
Wspomnij lazy loading i niezamierzone zapytania.
-->

---

# Eager loading

Include łączy lub ładuje związane dane.

Unikaj pobierania całych grafów bez potrzeby.

<!--
NOTATKI PROWADZĄCEGO — slajd 4
Nie każdy Include generuje jeden SELECT.
-->

---

# Cartesian explosion

Dwie kolekcje rodzeństwa w jednym zapytaniu mogą mnożyć wiersze.

<!--
NOTATKI PROWADZĄCEGO — slajd 5
Pomóż wizualnie policzyć 10×10 zamówień i recenzji.
-->

---

# AsSplitQuery

Oddzielne zapytania zmniejszają eksplozję wierszy, ale dodają round-tripy.

<!--
NOTATKI PROWADZĄCEGO — slajd 6
Zwróć uwagę na spójność i koszt sieci.
-->

---

# Projekcje

```csharp
var rows = await db.Orders.AsNoTracking()
 .Select(x => new { x.Id, Customer = x.Customer.Name })
 .ToListAsync();
```

<!--
NOTATKI PROWADZĄCEGO — slajd 7
Nie pobieraj dużych pól, których nie używasz.
-->

---

# Tracking kontra no-tracking

Odczyty bez zmian często nie wymagają trackingu.

<!--
NOTATKI PROWADZĄCEGO — slajd 8
Mierz zależnie od kształtu danych i identity resolution.
-->

---

# Indeksy

Zapytanie LINQ musi być wspierane odpowiednimi indeksami po stronie SQL Server.

<!--
NOTATKI PROWADZĄCEGO — slajd 9
Plan zapytania i statystyki są kluczowe.
-->

---

# Co mierzymy?

Liczba SELECT; liczba round-tripów; elapsed; CPU; logical reads; alokacje .NET.

<!--
NOTATKI PROWADZĄCEGO — slajd 10
Mierz przy rozgrzanym środowisku i powtarzaj testy.
-->

---

# Narzędzia

EF logging, ToQueryString(), Extended Events, SET STATISTICS IO/TIME, actual execution plan, Query Store.

<!--
NOTATKI PROWADZĄCEGO — slajd 11
Różnica między estymacją a rzeczywistym planem.
-->

---

# Optymalizacja bez dowodów

Compiled queries, bulk API, ExecuteUpdate — tylko gdy mamy konkretny problem i pomiar.

<!--
NOTATKI PROWADZĄCEGO — slajd 12
Nie rób micro-optimization przed znalezieniem bottlenecku.
-->

---

# Podsumowanie

**Efektywność ORM to umiejętność czytania generowanego SQL i jego planu.**

<!--
NOTATKI PROWADZĄCEGO — slajd 13
Zapowiedz testowanie i architekturę.
-->
