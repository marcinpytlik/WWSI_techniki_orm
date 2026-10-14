# Narzędzia i techniki ORM — WWSI

Materiały dydaktyczne do przedmiotu **Narzędzia i techniki ORM** (rok akademicki 2026/2027).

## Technologie

- C# i platforma .NET
- Entity Framework Core
- Microsoft SQL Server
- SQL Server Management Studio / Visual Studio Code
- Docker (opcjonalny sposób uruchomienia bazy)

## Organizacja

Zadeklarowany wymiar: **18 godzin dydaktycznych wykładu i 27 godzin dydaktycznych laboratorium**.

| Spotkanie | Niedziela | Wykład | Laboratorium |
|---|---|---|---|
| 1 | 25.10.2026 | 10:35–11:20 | 11:30–14:30 |
| 2 | 08.11.2026 | 10:35–11:20 | 11:30–14:30 |
| 3 | 22.11.2026 | 10:35–11:20 | 11:30–14:30 |
| 4 | 06.12.2026 | 10:35–11:20 | 11:30–14:30 |
| 5 | 20.12.2026 | 10:35–11:20 | 11:30–14:30 |
| 6 | 17.01.2027 | 10:35–11:20 | 11:30–14:30 |
| 7 | 24.01.2027 | 10:35–11:20 | 11:30–14:30 |
| 8 | termin do ustalenia | 10:35–12:15 | 12:50–13:35 |

> **Uwaga organizacyjna:** przedziały zegarowe nie sumują się wprost do zadeklarowanych 18 h wykładu i 27 h laboratorium. Rozliczenie godzin i ostateczną kolejność zajęć należy potwierdzić z planem uczelni.

## Plan merytoryczny (propozycja)

1. Wprowadzenie do ORM, EF Core, SQL Server i konfiguracja środowiska
2. Encje, DbContext, mapowanie właściwości i migracje
3. Relacje, klucze, Fluent API i integralność danych
4. LINQ, translacja do SQL, projekcje i ładowanie danych
5. Change Tracker, cykl życia encji i operacje CRUD
6. Transakcje, współbieżność optymistyczna i obsługa konfliktów
7. Wydajność ORM: N+1, Include, AsNoTracking, Query Store i plany zapytań
8. Architektura warstwy dostępu do danych, testy i podsumowanie projektu

## Struktura

- [Program przedmiotu](docs/program-przedmiotu.md)
- [Zasady pracy laboratoryjnej](labs/README.md)
- [Projekt zaliczeniowy](project/README.md)

## Zasada kursu

**Każde zapytanie LINQ warto rozumieć także jako SQL.** Analizujemy nie tylko kod C#, ale i zapytania generowane przez ORM, ich plany wykonania oraz konsekwencje dla bazy danych.

## Status

Repozytorium w fazie przygotowania. Harmonogram merytoryczny ma charakter roboczy; szczegółowe instrukcje laboratoryjne będą rozwijane osobno.
