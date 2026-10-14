# Lab 03 — Orders, OrderLines, FK i reguły usuwania

**Zjazd:** 22.11.2026  
**Zakres:** Zaprojektowanie modelu transakcyjnego bez przypadkowych kaskad usuwania.  
**Środowisko:** .NET 10, EF Core 10, SQL Server 2022 CU26, port 14333.  
**Czas:** 11:30–14:30 (180 min; planuj przerwy i czas samodzielny).

## Cel i warunki wstępne

Wykonaj kolejno wcześniejsze laboratoria. Punktem odniesienia jest [model ORM Shop](../lectures/orm-shop-case-study.md). **Nie wykorzystuj `sa` ani uprawnień DDL w aplikacji.** Zapoznaj się z [modelem bezpieczeństwa](architecture-and-security.md).

## Wykonanie krok po kroku

### Krok 1

Dodaj Order (Id, CustomerId, CreatedAt) i OrderLine (OrderId, ProductId, Quantity, UnitPrice).

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 2

Skonfiguruj relacje Customer→Orders, Order→OrderLines, Product→OrderLines. Rozważ composite key (OrderId, ProductId) i jego ograniczenia.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 3

Ustaw Restrict/NoAction dla usuwania Customer z historią zamówień oraz Product użytego na zamówieniu.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 4

Wygeneruj migrację; oceń indeksy i klucze obce oraz jej wpływ na dane. Wdróż ją oddzielnym kontem deploy.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 5

Wykonaj test integracyjny: wstaw dane, spróbuj usunąć klienta z zamówieniem; sprawdź wyjątek i FK SQL Server.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

## Rezultat wymagany

ERD, poprawne FK, jawne DeleteBehavior oraz migracja zatwierdzona i zastosowana przez deploy.

## Pytanie kontrolne

Czy nawigacja Orders automatycznie odczytuje całą kolekcję?

## Zadanie samodzielne

Udokumentuj w README projektu decyzję z tego zjazdu, wskaż wykonywany przez aplikację SQL (lub ograniczenie bazy) i opisz jedną możliwą awarię oraz sposób weryfikacji.

## Kryteria zaliczenia etapu

- Działa funkcja z tego laboratorium i weryfikacja jest powtarzalna.
- Konto runtime ma tylko DML do schematu shop, konto migracyjne używane jest oddzielnie.
- Nie ma połączeń z `sa`, tajnych haseł ani `Database.Migrate()` w kodzie aplikacji.
- Wytworzono kod, testy i krótki dowód wykonania (SQL/response/log).

> **Uwaga:** to instrukcja dydaktyczna z krokami i kryteriami odbioru. Kody klas, gotowa solucja, endpointy i automatyzacja wdrożenia stanowią osobny pakiet implementacyjny; obecny plik nie udaje przetestowanego projektu end-to-end.
