# Lab 02 — Model EF Core i kontrolowana migracja

**Zjazd:** 08.11.2026  
**Zakres:** Model Product i Customer, DbContext, Fluent API i pierwsza migracja wykonywana wyłącznie przez deploy.  
**Środowisko:** .NET 10, EF Core 10, SQL Server 2022 CU26, port 14333.  
**Czas:** 11:30–14:30 (180 min; planuj przerwy i czas samodzielny).

## Cel i warunki wstępne

Wykonaj kolejno wcześniejsze laboratoria. Punktem odniesienia jest [model ORM Shop](../lectures/orm-shop-case-study.md). **Nie wykorzystuj `sa` ani uprawnień DDL w aplikacji.** Zapoznaj się z [modelem bezpieczeństwa](architecture-and-security.md).

## Wykonanie krok po kroku

### Krok 1

Utwórz klasy Product { Id, Sku, Name, Price, RowVersion } i Customer { Id, Name, City }; skonfiguruj tabelę shop.Products i shop.Customers.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 2

W Fluent API ustaw długość SKU i Name, unique index SKU, decimal(18,2), RowVersion jako IsRowVersion oraz HasDefaultSchema("shop").

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 3

Skonfiguruj historię: options.UseSqlServer(..., sql => sql.MigrationsHistoryTable("__EFMigrationsHistory", "shop")) także dla narzędzi design-time.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 4

Uruchom dotnet ef migrations add InitialShopSchema (generowanie plików nie wymaga podwyższonych uprawnień SQL).

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 5

Wygeneruj dotnet ef migrations script --idempotent -o artifacts/initial.sql. Przejrzyj SQL i wykonaj go jako orm_shop_deploy w kontrolowanym oknie.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 6

Uruchom API na orm_shop_app, wykonaj SELECT, sprawdź, że ALTER TABLE i tworzenie indeksów są zabronione.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

## Rezultat wymagany

W repo: model, migracja, zatwierdzony skrypt SQL i wynik testu odmowy DDL na runtime.

## Pytanie kontrolne

Czy konto migracyjne musi być db_owner? Dlaczego nie?

## Zadanie samodzielne

Udokumentuj w README projektu decyzję z tego zjazdu, wskaż wykonywany przez aplikację SQL (lub ograniczenie bazy) i opisz jedną możliwą awarię oraz sposób weryfikacji.

## Kryteria zaliczenia etapu

- Działa funkcja z tego laboratorium i weryfikacja jest powtarzalna.
- Konto runtime ma tylko DML do schematu shop, konto migracyjne używane jest oddzielnie.
- Nie ma połączeń z `sa`, tajnych haseł ani `Database.Migrate()` w kodzie aplikacji.
- Wytworzono kod, testy i krótki dowód wykonania (SQL/response/log).

> **Uwaga:** to instrukcja dydaktyczna z krokami i kryteriami odbioru. Kody klas, gotowa solucja, endpointy i automatyzacja wdrożenia stanowią osobny pakiet implementacyjny; obecny plik nie udaje przetestowanego projektu end-to-end.
