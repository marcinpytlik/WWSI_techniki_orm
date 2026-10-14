# Lab 04 — LINQ, projekcje i diagnostyka T-SQL

**Zjazd:** 06.12.2026  
**Zakres:** Budowanie zapytań odraczanych i porównanie ich z rzeczywistym SQL.  
**Środowisko:** .NET 10, EF Core 10, SQL Server 2022 CU26, port 14333.  
**Czas:** 11:30–14:30 (180 min; planuj przerwy i czas samodzielny).

## Cel i warunki wstępne

Wykonaj kolejno wcześniejsze laboratoria. Punktem odniesienia jest [model ORM Shop](../lectures/orm-shop-case-study.md). **Nie wykorzystuj `sa` ani uprawnień DDL w aplikacji.** Zapoznaj się z [modelem bezpieczeństwa](architecture-and-security.md).

## Wykonanie krok po kroku

### Krok 1

Wprowadź dane syntetyczne do klientów, zamówień i pozycji; seed uruchom w kontrolowanym procesie, bez migracji przy starcie API.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 2

Zaimplementuj GET /customers?city=... oraz GET /customers/{id}/orders z AsNoTracking i projekcjami DTO.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 3

Porównaj Include + Take(100) z Select do DTO, wypisz ToQueryString(), uwzględniając stabilne OrderBy.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 4

Przeanalizuj w SSMS wygenerowany T-SQL oraz plan wykonania; sprawdź liczby wierszy i kolumn.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 5

Pokaż parametryzację filtra i sprawdź zachowanie AsSplitQuery; odnotuj liczbę wywołań SQL.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

## Rezultat wymagany

Minimum trzy udokumentowane zapytania: C#, T-SQL, obserwacja liczby round-tripów.

## Pytanie kontrolne

Dlaczego podzapytanie w FROM może być potrzebne przy Include i Take?

## Zadanie samodzielne

Udokumentuj w README projektu decyzję z tego zjazdu, wskaż wykonywany przez aplikację SQL (lub ograniczenie bazy) i opisz jedną możliwą awarię oraz sposób weryfikacji.

## Kryteria zaliczenia etapu

- Działa funkcja z tego laboratorium i weryfikacja jest powtarzalna.
- Konto runtime ma tylko DML do schematu shop, konto migracyjne używane jest oddzielnie.
- Nie ma połączeń z `sa`, tajnych haseł ani `Database.Migrate()` w kodzie aplikacji.
- Wytworzono kod, testy i krótki dowód wykonania (SQL/response/log).

> **Uwaga:** to instrukcja dydaktyczna z krokami i kryteriami odbioru. Kody klas, gotowa solucja, endpointy i automatyzacja wdrożenia stanowią osobny pakiet implementacyjny; obecny plik nie udaje przetestowanego projektu end-to-end.
