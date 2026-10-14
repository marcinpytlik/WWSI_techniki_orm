# Lab 01 — Środowisko, bootstrap i granice uprawnień

**Zjazd:** 25.10.2026  
**Zakres:** Sprawdzenie .NET, EF CLI, Docker i SQL Server; utworzenie OrmShop i kont separowanych.  
**Środowisko:** .NET 10, EF Core 10, SQL Server 2022 CU26, port 14333.  
**Czas:** 11:30–14:30 (180 min; planuj przerwy i czas samodzielny).

## Cel i warunki wstępne

Wykonaj kolejno wcześniejsze laboratoria. Punktem odniesienia jest [model ORM Shop](../lectures/orm-shop-case-study.md). **Nie wykorzystuj `sa` ani uprawnień DDL w aplikacji.** Zapoznaj się z [modelem bezpieczeństwa](architecture-and-security.md).

## Wykonanie krok po kroku

### Krok 1

Pracuj w głównym katalogu repozytorium. Skopiuj .env.example do .env, zmień hasło sa, uruchom docker compose up -d i sprawdź docker compose ps.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 2

W SSMS jako administrator wykonaj security/01-bootstrap.sql; potwierdź SELECT DB_NAME() i poziom zgodności 160.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 3

Uruchom security/02-create-logins.sql w SQLCMD Mode, zmieniając przykładowe hasła na różne silne wartości (tylko środowisko izolowane).

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 4

Wykonaj security/03-verify-permissions.sql, zaloguj się oddzielnie jako app/deploy, wypróbuj operacje dozwolone i zablokowane.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

### Krok 5

Utwórz rozwiązanie ORM Shop i ASP.NET Core Web API, skonfiguruj user-secrets i połączenie konta runtime; NIE wywołuj Database.Migrate na starcie.

**Sprawdzenie:** zapisz rezultat (fragment konsoli, wynik T-SQL lub test automatyczny). Zanotuj konto, którym wykonano operację.

## Rezultat wymagany

Poprawny SQL Server CU26; dwa konta z odrębnymi rolami; odmowa CREATE TABLE dla app; uruchamiający się szkielet API.

## Pytanie kontrolne

Dlaczego klucz migracyjny nie powinien znajdować się w konfiguracji API?

## Zadanie samodzielne

Udokumentuj w README projektu decyzję z tego zjazdu, wskaż wykonywany przez aplikację SQL (lub ograniczenie bazy) i opisz jedną możliwą awarię oraz sposób weryfikacji.

## Kryteria zaliczenia etapu

- Działa funkcja z tego laboratorium i weryfikacja jest powtarzalna.
- Konto runtime ma tylko DML do schematu shop, konto migracyjne używane jest oddzielnie.
- Nie ma połączeń z `sa`, tajnych haseł ani `Database.Migrate()` w kodzie aplikacji.
- Wytworzono kod, testy i krótki dowód wykonania (SQL/response/log).

> **Uwaga:** to instrukcja dydaktyczna z krokami i kryteriami odbioru. Kody klas, gotowa solucja, endpointy i automatyzacja wdrożenia stanowią osobny pakiet implementacyjny; obecny plik nie udaje przetestowanego projektu end-to-end.
