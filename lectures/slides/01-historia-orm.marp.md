---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 01 · 25.10.2026'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 42px; }
  h2 { color: #133c69; }
  code { font-size: 0.70em; }
  pre { background: #f0f4f8; }
  table { font-size: 0.71em; }
  section::after { color: #65768a; }
---

# Skąd wziął się ORM?

Historia, wzorce i współczesne rozwiązania

Narzędzia i techniki ORM · WWSI · 25.10.2026

<!--
NOTATKI PROWADZĄCEGO — 1 min
Zacznij od pytania, czy ORM zastępuje SQL. Na końcu wrócimy do tego pytania.
-->

---

# Problem: proste SELECT, dużo kodu

SQL → połączenie → reader → konwersja typów → obiekty → zamknięcie zasobów

**Ile kodu to logika biznesowa?**

<!--
NOTATKI PROWADZĄCEGO — 3 min
Przykład: lista klientów. W samym SQL proste zapytanie, w języku obiektowym dużo infrastruktury.
-->

---

# Lata 70. i 80.: fundament relacyjny

Model relacyjny · SQL · deklaratywne operacje na zbiorach

**Baza opisuje dane i relacje, a nie graf obiektów.**

<!--
NOTATKI PROWADZĄCEGO — 3 min
Wspomnij Codd i przesunięcie od nawigacyjnego dostępu do deklaratywnych zapytań. Nie sugeruj, że SQL zniknął.
-->

---

# Lata 90.: świat obiektów spotyka SQL

C++ / Java / aplikacje wielowarstwowe

ODBC · JDBC · biblioteki dostępu do danych

Ręczne przenoszenie danych pomiędzy wierszami a obiektami

<!--
NOTATKI PROWADZĄCEGO — 3 min
Wyjaśnij, że ADO.NET pojawił się później, w ekosystemie .NET. JDBC i ODBC nie są ORM.
-->

---

# Koniec lat 90. i lata 2000: ORM

Automatyzacja mapowania encji i relacji

TopLink · Hibernate · NHibernate · Active Record · Entity Framework

**ORM automatyzuje część pracy, nie usuwa bazy danych.**

<!--
NOTATKI PROWADZĄCEGO — 3 min
Nie przedstawiaj technologii jako jednej liniowej sukcesji; współistnieją. Wspomnij o wzorcach opisanych przez Martina Fowlera.
-->

---

# Object–relational impedance mismatch

**Obiekty:** tożsamość, referencje, dziedziczenie, kolekcje

**Relacje:** klucze, FK, wiersze, tabele, JOIN, NULL

**Niedopasowanie nie znika po zainstalowaniu biblioteki.**

<!--
NOTATKI PROWADZĄCEGO — 4 min
Przykład Customer.Orders ↔ Orders.CustomerId. Porównaj identity oraz NULL.
-->

---

# Mapa: obiekt ↔ relacyjna baza

```text
Customer (C#)                Customers (SQL)
 Id ──────────────────────── CustomerId PK
 Name ────────────────────── Name
 Orders[] ─── FK ─────────── Orders.CustomerId
```

Nawigacja w pamięci ≠ darmowy JOIN

<!--
NOTATKI PROWADZĄCEGO — 2 min
Zwróć uwagę, że relację implementuje FK, nie pole będące listą zamówień.
-->

---

# Wzorce persystencji

**Active Record** — dane i zapis w jednym modelu

**Data Mapper** — odrębna warstwa odwzorowania

**Identity Map** — śledzona tożsamość encji

**Unit of Work** — zbieranie zmian do zapisu

<!--
NOTATKI PROWADZĄCEGO — 4 min
Pokaż, dlaczego DbContext przypomina Unit of Work, ale nie należy utożsamiać wzorca z jedną klasą.
-->

---

# Nie wszystko jest ORM

**ADO.NET / JDBC** — podstawowy dostęp do danych

**Dapper** — micro-ORM, SQL piszemy sami

**jOOQ** — typowany SQL DSL

**EF Core / Hibernate / NHibernate** — pełniejsze ORM

<!--
NOTATKI PROWADZĄCEGO — 3 min
Różne poziomy abstrakcji. Krótki kod aplikacji nie gwarantuje krótkiego czasu wykonywania zapytania.
-->

---

# Ekosystemy ORM

| .NET | Java | Python | Ruby | JS/TS |
|---|---|---|---|---|
| EF Core | Hibernate | SQLAlchemy | Rails Active Record | Prisma |
| NHibernate | jOOQ* | Django ORM | | |
| Dapper* | | | | |

*alternatywa SQL-first / micro-ORM, nie pełny ORM

<!--
NOTATKI PROWADZĄCEGO — 3 min
Naświetl przykłady poza .NET, ale bez wejścia w szczegóły instalacyjne.
-->

---

# To samo zapytanie: ADO.NET

```csharp
await using var cn = new SqlConnection(cs);
await cn.OpenAsync();
await using var cmd = new SqlCommand(
  "SELECT CustomerId, Name FROM dbo.Customers WHERE City=@city", cn);
cmd.Parameters.Add("@city", SqlDbType.NVarChar, 100).Value = "Warszawa";
await using var reader = await cmd.ExecuteReaderAsync();
while (await reader.ReadAsync()) { /* mapowanie pól */ }
```

**Pełna kontrola SQL; mapowanie ręczne.**

<!--
NOTATKI PROWADZĄCEGO — 3 min
Pokaż parametryzację, koszty boilerplate i jawność SQL. Fragment koncepcyjny.
-->

---

# To samo zapytanie: Dapper

```csharp
await using var cn = new SqlConnection(cs);
var customers = await cn.QueryAsync<CustomerDto>(
  "SELECT CustomerId, Name FROM dbo.Customers WHERE City=@City",
  new { City = "Warszawa" });
```

**SQL w rękach programisty, mapowanie uproszczone.**

<!--
NOTATKI PROWADZĄCEGO — 2 min
Dapper mapuje kolumny do właściwości. Nie jest automatycznym generatorem LINQ jak EF Core.
-->

---

# To samo zapytanie: EF Core

```csharp
var customers = await db.Customers
  .AsNoTracking()
  .Where(x => x.City == "Warszawa")
  .Select(x => new CustomerDto {
      CustomerId = x.CustomerId, Name = x.Name })
  .ToListAsync();
```

**LINQ → provider → T-SQL.**

<!--
NOTATKI PROWADZĄCEGO — 2 min
DbContext wcześniej skonfigurowany. Wyjaśnij projekcję i no tracking. Zaproponuj sprawdzenie ToQueryString na laboratorium.
-->

---

# Co ORM faktycznie robi?

```text
C# / LINQ → EF Core → provider SQL Server
                       ↓
                parametryzowany T-SQL
                       ↓
              optymalizator i wykonanie
                       ↓
           obiekty + opcjonalny tracking
```

**Plan wykonania tworzy SQL Server.**

<!--
NOTATKI PROWADZĄCEGO — 3 min
Istotne jest pytanie: ile round-tripów, jakie JOIN, ile wierszy i danych.
-->

---

# Korzyści i koszty

| Korzyści | Ryzyka |
|---|---|
| Mniej powtarzalnego kodu | N+1 i niejawne round-tripy |
| Mapowanie relacji | Nadmiar kolumn i JOIN |
| Tracking i migracje | Koszt śledzenia i migracji |
| Spójny model | Fałszywe poczucie niezależności od DB |

**Mierzymy SQL, IO, czas i plany.**

<!--
NOTATKI PROWADZĄCEGO — 3 min
Podkreśl, że porównanie wydajności wymaga identycznych danych i scenariusza.
-->

---

# Jak dobrać narzędzie?

**EF Core:** CRUD, model domenowy, migracje

**Dapper / SQL-first:** jawne i specjalizowane odczyty

**ADO.NET:** niskopoziomowa kontrola

**Hybryda:** właściwe narzędzie do konkretnej operacji

<!--
NOTATKI PROWADZĄCEGO — 2 min
Nie wydawaj absolutnych sądów o szybkości. Zależność od projektu i profilu obciążenia.
-->

---

# Pytania do sali i podsumowanie

1. Dlaczego kolekcja obiektów nie jest kolumną relacyjną?
2. Czym Dapper różni się od EF Core?
3. Czy ORM zwalnia z czytania T-SQL?

**ORM upraszcza mapowanie, lecz nie zastępuje rozumienia bazy.**

<!--
NOTATKI PROWADZĄCEGO — 1 min
Zamknij pytaniem otwierającym. Na następnym zjeździe przejdziemy do encji, DbContext i migracji.
-->

---

# Oś czasu — skąd ORM?

```text
1970: model relacyjny → SQL
1980–90: ODBC/JDBC i ręczne mapowanie
1990–2000: TopLink / Hibernate
2000+: NHibernate, EF, Rails Active Record
2010+: Dapper, EF Core, Prisma
```

**Każda z tych dróg nadal ma zastosowanie.**

<!-- NOTATKI v2: Oś celowo przybliżona. Historia nie oznacza zastępowania SQL przez ORM. -->

---

# Active Record vs Data Mapper

```text
Active Record:  Model + Save()/Load()
Data Mapper:   Model ←→ Mapper ←→ SQL
                         ↑
                    DbContext EF Core
```

**Pytanie:** gdzie umieszczamy logikę utrwalania?

<!-- NOTATKI v2: Zaznacz, że DbContext nie jest dosłownie wyłącznie Data Mapper. -->

---

# ORM Shop — decyzja po wykładzie

Zapisz **jeden wybór techniczny**, jedno ryzyko oraz sposób sprawdzenia SQL Server.

**Case study:** [lectures/orm-shop-case-study.md](../orm-shop-case-study.md)

<!-- NOTATKI: Rozwiązanie zapisz w notatkach studenta. Ten slajd można pominąć przy braku czasu. -->
