# Lab 07 — N+1, Query Store, Dapper i testy integracyjne

**Zjazd:** 24.01.2027  
**Zakres:** Pomiar zachowania ORM Shop i przygotowanie projektu do odbioru.  
**Środowisko:** .NET 10, EF Core 10, SQL Server 2022 CU26, port 14333.  
**Czas:** 11:30–14:30 (180 min; planuj przerwy i czas samodzielny).

## Cel i warunki wstępne

Wykonaj kolejno wcześniejsze laboratoria. Punktem odniesienia jest [model ORM Shop](../lectures/orm-shop-case-study.md). **Nie wykorzystuj `sa` ani uprawnień DDL w aplikacji.** Zapoznaj się z [modelem bezpieczeństwa](architecture-and-security.md).

## Wykonanie krok po kroku

### Krok 1

Przygotuj scenariusz N+1 (jawna pętla z osobnymi odczytami) i porównaj liczbę SQL calls z projekcją DTO.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 2

Zademonstruj Include wielu kolekcji i możliwą Cartesian Explosion, porównaj AsSplitQuery.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 3

Włącz Query Store w bazie testowej jako administrator; użyj SET STATISTICS IO/TIME i Actual Plan.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 4

Dodaj raport odczytowy przez Dapper z parametrami SQL (konto runtime) i porównaj zapytanie z EF Core, nie obiecując przewagi wydajności.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 5

Uruchom testy integracyjne na SQL Server 2022 CU26 — nie zastępuj providera testowego InMemory w testach SQL.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 6

Zamknij backlog projektu i wykonaj próbę finałową przed zjazdem 8.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

## Rezultat wymagany

Raport przed/po, działający Dapper, testy integracyjne i repo gotowe do pokazu.

## Pytanie kontrolne

Które dane pomiarowe dowodzą realnej poprawy wydajności?

## Zadanie samodzielne

Udokumentuj w README projektu decyzję z tego zjazdu, wskaż wykonywany przez aplikację SQL (lub ograniczenie bazy) i opisz jedną możliwą awarię oraz sposób weryfikacji.

## Kryteria zaliczenia etapu

- Działa funkcja z tego laboratorium i weryfikacja jest powtarzalna.
- Konto runtime ma tylko DML do schematu shop, konto migracyjne używane jest oddzielnie.
- Nie ma połączeń z `sa`, tajnych haseł ani `Database.Migrate()` w kodzie aplikacji.
- Wytworzono kod, testy i krótki dowód wykonania (SQL/response/log).

> **Uwaga:** to instrukcja dydaktyczna z krokami i kryteriami odbioru. Kody klas, gotowa solucja, endpointy i automatyzacja wdrożenia stanowią osobny pakiet implementacyjny; obecny plik nie udaje przetestowanego projektu end-to-end.
