# Lab 01 — Środowisko, bootstrap i granice uprawnień

**Zjazd:** 25.10.2026  
**Czas:** 11:30–14:30 (180 min)  
**Procedura:** [instrukcja krok po kroku](step-by-step/lab-01.md). Polecenia są tylko tam.

## Cel

Student uruchamia SQL Server 2022 CU26, rozdziela konta `sa`, `orm_shop_deploy` i `orm_shop_app` oraz startuje gotowy starter API na http://localhost:5080.

## Co już jest w repozytorium

Starter `src/OrmShop.Api` jest częścią materiałów. Na tym zjeździe nie tworzysz nowego projektu Web API.

## Rezultat

- Build `16.0.4265.3`, CU26, kontener healthy po `SELECT 1`.
- Konto aplikacji nie tworzy tabel. Konto deploy nie tworzy tabeli w schemacie `dbo`.
- `GET http://localhost:5080/health` zwraca status running.
- W repozytorium nie ma haseł ani `Database.Migrate()`.

## Pytanie kontrolne

Dlaczego login migracyjny nie powinien trafić do konfiguracji API?

## Zadanie samodzielne

Zapisz numer builda, wynik `HAS_PERMS_BY_NAME` dla aplikacji i kod błędu odmowy `CREATE TABLE dbo.ShouldFail` dla konta deploy. W notatce nie umieszczaj haseł.

## Kryteria zaliczenia

- Skrypt `02-create-logins.sql` można uruchomić drugi raz bez błędu członkostwa w roli.
- API startuje w środowisku Development i czyta user-secrets.
- Odmowa DDL jest pokazana dla konta aplikacji i dla schematu `dbo` na koncie deploy.
