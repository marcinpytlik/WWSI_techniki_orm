# Lab 05 — CRUD, Unit of Work i aktualizacje kontrolowane

**Zjazd:** 20.12.2026  
**Zakres:** Zrozumienie stanów encji i bezpieczne przyjmowanie danych z API.  
**Środowisko:** .NET 10, EF Core 10, SQL Server 2022 CU26, port 14333.  
**Czas:** 11:30–14:30 (180 min; planuj przerwy i czas samodzielny).

## Cel i warunki wstępne

Wykonaj kolejno wcześniejsze laboratoria. Punktem odniesienia jest [model ORM Shop](../lectures/orm-shop-case-study.md). **Nie wykorzystuj `sa` ani uprawnień DDL w aplikacji.** Zapoznaj się z [modelem bezpieczeństwa](architecture-and-security.md).

## Wykonanie krok po kroku

### Krok 1

Zaimplementuj POST /products, PUT /products/{id} oraz GET /products z walidacją żądań i DTO.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 2

Przy aktualizacji pobierz istniejącą encję i jawnie zmień dozwolone pola; nie używaj ślepego DbContext.Update na pełnym DTO.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 3

Porównaj Entry.State przed i po SaveChanges; sprawdź wygenerowany INSERT/UPDATE.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 4

Zaimplementuj konflikt SKU unique i pokaż obsługę błędu bez ujawniania danych połączenia.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 5

Wykonaj ExecuteUpdateAsync dla kontrolowanego scenariusza, a następnie wyjaśnij brak automatycznej synchronizacji Change Trackera.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

## Rezultat wymagany

CRUD działający tylko na koncie app, walidacja, prawidłowe błędy 400/404/409 i demonstracja states.

## Pytanie kontrolne

Dlaczego SaveChanges nie wymaga uprawnień do DDL?

## Zadanie samodzielne

Udokumentuj w README projektu decyzję z tego zjazdu, wskaż wykonywany przez aplikację SQL (lub ograniczenie bazy) i opisz jedną możliwą awarię oraz sposób weryfikacji.

## Kryteria zaliczenia etapu

- Działa funkcja z tego laboratorium i weryfikacja jest powtarzalna.
- Konto runtime ma tylko DML do schematu shop, konto migracyjne używane jest oddzielnie.
- Nie ma połączeń z `sa`, tajnych haseł ani `Database.Migrate()` w kodzie aplikacji.
- Wytworzono kod, testy i krótki dowód wykonania (SQL/response/log).

> **Uwaga:** to instrukcja dydaktyczna z krokami i kryteriami odbioru. Kody klas, gotowa solucja, endpointy i automatyzacja wdrożenia stanowią osobny pakiet implementacyjny; obecny plik nie udaje przetestowanego projektu end-to-end.
