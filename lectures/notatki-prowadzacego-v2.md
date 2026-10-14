# Notatki prowadzącego — wykłady ORM v2.0

Wspólne źródło kontekstu: [ORM Shop](orm-shop-case-study.md). Prezentacje zawierają slajdy rozszerzające **opcjonalne**, aby nie przeciążać 45-minutowych spotkań. Przed zajęciami uruchom przykład na SQL Server CU26 i sprawdź wygenerowany SQL.

## Wykład 01 — Historia i wzorce

**Pytanie otwierające:** Czy rezygnacja z ręcznego SQL oznacza, że silnik wykonuje mniej pracy?

**Odpowiedź i wyjaśnienie:** Nie. W obu przypadkach SQL Server otrzymuje zapytanie; różna jest warstwa generowania i mapowania.

**Krótka demonstracja / studium przypadku:** Lista klientów: ADO.NET vs Dapper vs EF Core; sprawdź parametryzację.

**Najważniejsza teza:** Active Record i Data Mapper różnią się rozdziałem modelu od persystencji.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Wykład 02 — Modelowanie i migracje

**Pytanie otwierające:** Czy zmiana nazwy pola Name na ProductName jest bezpieczną migracją?

**Odpowiedź i wyjaśnienie:** Nie zakładaj. Przeanalizuj czy powstało RenameColumn czy Drop/Add. Zaplanuj ciągłość dostępu.

**Krótka demonstracja / studium przypadku:** SKU UNIQUE, Price decimal(18,2): pokaż różnicę między walidacją C# a SQL constraints.

**Najważniejsza teza:** Owned/complex/value converter/TPH/TPT/TPC dobiera się do wymagań, nie domyślnie.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Wykład 03 — Relacje

**Pytanie otwierające:** Czy skasowanie klienta powinno usunąć zamówienia?

**Odpowiedź i wyjaśnienie:** Zwykle nie przy wymaganiach audytowych; wybierz odpowiednie zachowanie FK i cykl życia encji.

**Krótka demonstracja / studium przypadku:** Zaprojektuj Orders, OrderLines i Products, wskaż FK i indeksy.

**Najważniejsza teza:** Klucz obcy dba o spójność, nawigacja EF nie jest gwarancją ładowania.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Wykład 04 — LINQ i SQL

**Pytanie otwierające:** Dlaczego Take(100) z Include daje często podzapytanie?

**Odpowiedź i wyjaśnienie:** Limit dotyczy 100 encji nadrzędnych, a nie 100 wierszy złączonego wyniku.

**Krótka demonstracja / studium przypadku:** ToQueryString(), log zapytań, Actual Plan dla klientów z zamówieniami.

**Najważniejsza teza:** LINQ jest opisem, a nie planem. Materializacja wywołuje wykonanie.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Wykład 05 — Change Tracker

**Pytanie otwierające:** Czy Update(entity) ze zwróconego DTO jest bezpieczne?

**Odpowiedź i wyjaśnienie:** Może nadpisać pola, których klient nie miał prawa edytować, i nieoczekiwanie aktualizować graf.

**Krótka demonstracja / studium przypadku:** Zmiana ceny przez śledzoną encję vs ExecuteUpdate i stale entity w trackerze.

**Najważniejsza teza:** Wymagane świadome zarządzanie czasem życia DbContext.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Wykład 06 — Transakcje

**Pytanie otwierające:** Czy RCSI usuwa konieczność rowversion?

**Odpowiedź i wyjaśnienie:** Nie; RCSI zmienia sposób odczytów, a rowversion może wykrywać konflikty zapisu.

**Krótka demonstracja / studium przypadku:** Symuluj lost update dwóch klientów; pokaż DbUpdateConcurrencyException.

**Najważniejsza teza:** Transaction retry wymaga idempotencji; Outbox rozwiązuje problem granicy DB/broker.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Wykład 07 — Wydajność

**Pytanie otwierające:** Co będzie szybsze: Include czy Select do DTO?

**Odpowiedź i wyjaśnienie:** Zależy od rozmiaru danych i planu — zmierz logical reads, SQL calls, time i alokacje.

**Krótka demonstracja / studium przypadku:** N+1 101 zapytań, cartesian explosion, Query Store i Actual Plan.

**Najważniejsza teza:** Nie optymalizuj kodu C# bez pomiaru SQL i liczby round-tripów.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Wykład 08 — Architektura i testy

**Pytanie otwierające:** Czy test na EF InMemory potwierdza poprawność dla SQL Server?

**Odpowiedź i wyjaśnienie:** Nie. Brak odpowiedniej semantyki FK, transakcji i translacji SQL.

**Krótka demonstracja / studium przypadku:** Testcontainers SQL Server, migracja CI/CD, scenariusz EF Core + Dapper.

**Najważniejsza teza:** Dodatkowe repository tylko przy realnym uzasadnieniu; observability od początku.

**Kontrola zrozumienia A:** Co w tym przykładzie realizuje biblioteka ORM, a co pozostaje odpowiedzialnością SQL Server?

**Kontrola zrozumienia B:** Jaki problem zaobserwujemy w logach, planie lub danych i jak go zweryfikujemy?

**Zadanie refleksyjne:** Uzasadnij wybór mechanizmu, jego zaletę i ryzyko produkcyjne.

## Ściąga prowadzącego: analiza ORM

1. Pokaż C# i przewidź T-SQL.
2. Użyj ToQueryString lub diagnostyki (dla DML logi/Extended Events) zamiast zgadywania rzeczywistej treści.
3. Sprawdź liczbę wywołań i wynik planu SQL Server.
4. Porównaj koszt pamięci i tracking w .NET.
5. Omów granice transakcji, migracji i zgodność z produkcją.

## Dalsze materiały

- [EF Core](https://learn.microsoft.com/ef/core/)
- [SQL Server](https://learn.microsoft.com/sql/sql-server/)
- [Martin Fowler: Patterns of Enterprise Application Architecture](https://martinfowler.com/books/eaa.html)

Uwaga: scenariusze to pomoc dydaktyczna, nie dowód empirycznej wydajności. Nie udawaj, że przykładowy pseudokod SQL jest dosłownym wynikiem konkretnej wersji EF Core.
