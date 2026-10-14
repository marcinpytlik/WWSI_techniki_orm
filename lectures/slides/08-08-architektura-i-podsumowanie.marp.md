---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 08 · termin do ustalenia'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 40px; }
  pre { background: #f0f4f8; }
  code { font-size: 0.77em; }
  table { font-size: 0.72em; }
---

# Architektura dostępu do danych i testowanie

**Wykład 08 · termin do ustalenia**

C# · Entity Framework Core 10 · SQL Server 2022 CU26

<!-- NOTATKI: Otwarcie i powtórzenie poprzedniego spotkania. -->

---

# Cała droga żądania

HTTP/API → serwis → DbContext → provider → SQL Server.

<!--
NOTATKI PROWADZĄCEGO — slajd 2
Warstwy powinny mieć czytelne odpowiedzialności.
-->

---

# Dependency Injection

```csharp
builder.Services.AddDbContext<AppDbContext>(o =>
 o.UseSqlServer(builder.Configuration.GetConnectionString("Sql")));
```

<!--
NOTATKI PROWADZĄCEGO — slajd 3
Krótkie życie DbContext; brak współdzielenia między wątkami.
-->

---

# Repository: tak czy nie?

DbContext już oferuje wiele cech Repository + Unit of Work.

Dodatkowa abstrakcja musi rozwiązywać realny problem.

<!--
NOTATKI PROWADZĄCEGO — slajd 4
Nie tworzyć generycznego repository automatycznie.
-->

---

# Domena vs persystencja

Gdzie umieścić walidację, zapytania i transakcje?

<!--
NOTATKI PROWADZĄCEGO — slajd 5
Unikaj logiki biznesowej w kontrolerach.
-->

---

# CQRS / mieszany dostęp

EF Core do zapisu; Dapper lub SQL-first do raportów i złożonych odczytów.

<!--
NOTATKI PROWADZĄCEGO — slajd 6
CQRS to decyzja architektoniczna, a nie obowiązek.
-->

---

# Migracje w CI/CD

Skrypt migracji do przeglądu, testy rollback/fail-forward, kompatybilność wdrożeń.

<!--
NOTATKI PROWADZĄCEGO — slajd 7
Nie uruchamiaj zmian schematu bez procesu.
-->

---

# Testy jednostkowe

Mockowanie abstrakcji pozwala badać logikę, ale nie translację LINQ.

<!--
NOTATKI PROWADZĄCEGO — slajd 8
Nie testujemy zachowania SQL Server, gdy nie ma SQL Server.
-->

---

# Testy integracyjne

SQL Server 2022 CU26 w kontenerze jako referencyjna baza testowa.

<!--
NOTATKI PROWADZĄCEGO — slajd 9
Sprawdzaj mapowanie, transakcje, constraints i wygenerowany SQL.
-->

---

# Pułapki InMemory / SQLite

Różne semantyki SQL, typy, transakcje, indeksy i funkcje.

<!--
NOTATKI PROWADZĄCEGO — slajd 10
Provider testowy nie gwarantuje zgodności produkcyjnej.
-->

---

# Obserwowalność

Korelacja żądań z zapytaniami; logowanie wrażliwych danych tylko bezpiecznie.

<!--
NOTATKI PROWADZĄCEGO — slajd 11
Zbieraj pomiary bez wycieku parametrów produkcyjnych.
-->

---

# Kryteria wyboru technologii

Model · SQL · wydajność · testy · operacje wdrożeniowe · kompetencje zespołu.

<!--
NOTATKI PROWADZĄCEGO — slajd 12
Dobór zależy od scenariusza, nie od popularności frameworka.
-->

---

# Podsumowanie kursu

Od historii mapowania po plan wykonania SQL.

**ORM jest narzędziem, a nie substytutem rozumienia danych.**

<!--
NOTATKI PROWADZĄCEGO — slajd 13
Zamknij cykl i wróć do przykładów pierwszego wykładu.
-->

---

# Architektura ORM Shop

```text
API → Application Service ─ EF Core (CRUD)
                        └ Dapper (raporty)
                                  ↓
                           SQL Server 2022
```

<!-- NOTATKI v2: Hybrydowe podejście nie jest obowiązkiem. -->

---

# Testcontainers

Uruchamiaj testy integracyjne na SQL Server 2022 CU26.

Provider InMemory **nie odtwarza** semantyki SQL Server.

<!-- NOTATKI v2: Sprawdź migracje, FK, rowversion i transakcje. -->

---

# CI/CD i monitoring

Przegląd skryptów migracji, deploy etapowy, logowanie SQL, Query Store.

Nie loguj wrażliwych parametrów.

<!-- NOTATKI v2: Związek pomiędzy wdrożeniem, stabilnością SQL i telemetrią. -->

---

# Wybór technologii

Wymagania → model → zapytania → koszty → testy → wybór EF Core/Dapper/SQL.

<!-- NOTATKI v2: Przypadek raportu: SQL-first. CRUD: pełny ORM. -->

---

# Decyzja ORM Shop

Które rozwiązanie wybierasz? Nazwij **ryzyko**, sposób pomiaru i wpływ na SQL Server.

<!-- NOTATKI: ćwiczenie do dyskusji; pominąć gdy kończy się czas. -->
