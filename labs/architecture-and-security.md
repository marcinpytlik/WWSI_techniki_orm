# Architektura i model uprawnień — ORM Shop

## Zasada podstawowa

**Aplikacja nie uruchamia migracji.** Każda zmiana schematu jest oddzielnym etapem deploymentu, wykonywanym na tożsamości **orm_shop_deploy** po przeglądzie wygenerowanego SQL. Konto **orm_shop_app** ma wyłącznie uprawnienia DML potrzebne do działania aplikacji. **sa** wykorzystujemy tylko do przygotowania izolowanej instancji laboratoryjnej i utworzenia ról/loginów — nigdy w connection stringu aplikacji.

```mermaid
flowchart TB
  Admin[DBA / administrator instancji] -->|jednorazowy bootstrap| DB[(OrmShop SQL Server 2022 CU26)]
  Pipeline[Proces migracji - przegląd i akceptacja] -->|orm_shop_deploy / DDL shop| DB
  API[ASP.NET Core ORM Shop] -->|orm_shop_app / DML shop| DB
  API -.->|ZABRONIONE: DDL lub Migrate at startup| DB
```

| Tożsamość | Przeznaczenie | Uprawnienia | Zakaz |
|---|---|---|---|
| sa (bootstrap) | tworzy DB, schema, loginy i role | administrator tylko podczas bootstrapu | użycie w aplikacji |
| orm_shop_deploy | kontrolowane migracje | CREATE TABLE i inne wybrane CREATE w bazie, ALTER i REFERENCES dla schematu shop, DML w shop | sysadmin, db_owner, domyślnie zmiany innych schematów |
| orm_shop_app | uruchomiona aplikacja | SELECT/INSERT/UPDATE/DELETE w schemacie shop | CREATE/ALTER/DROP, db_owner |
| student | przegląd kodu | Git read i lokalne środowisko | commitowanie sekretów |

*Model uprawnień jest laboratorium, nie gotowym szablonem produkcyjnym.* Uprawnienia deploymentu należy jeszcze bardziej zawężać zgodnie z konkretnym zatwierdzonym skryptem; CREATE TABLE jest uprawnieniem bazodanowym, a ALTER schematu pozwala modyfikować istniejące obiekty w tym schemacie. Dla nowej wersji migracji weryfikujemy każde DDL.

## Kolejność i separacja

1. DBA wykonuje `security/01-bootstrap.sql`.
2. DBA tworzy loginy i role za pomocą `security/02-create-logins.sql` (tryb SQLCMD; hasła inne dla obu kont).
3. DBA weryfikuje role poleceniami z `security/03-verify-permissions.sql`.
4. Prowadzący generuje migrację `dotnet ef migrations add ...` oraz skrypt `dotnet ef migrations script --idempotent -o ...`.
5. Skrypt jest sprawdzany pod kątem DROP, ALTER, blokad, utraty danych, transakcyjności i odtwarzania.
6. Zatwierdzoną migrację uruchamia **konto deploymentu**, nie aplikacja.
7. API korzysta z konta runtime i sprawdza, że nie może wykonać DDL.

## Sekrety

- `.env` Dockera tylko do bootstrapu (sa), ignorowany przez Git.
- Connection strings do EF Core przechowuj w **dotnet user-secrets** podczas developmentu lub w secret store w innych środowiskach; nigdy w kodzie, plikach version-controlled ani notatkach.
- Stosuj Encrypt=True. W izolowanym laboratorium z niezaufanym certyfikatem można użyć TrustServerCertificate=True; nie jest to docelowe ustawienie produkcyjne.
- Hasła nie mogą być udostępnione grupie ani powielane między studentami.

## Negatywne testy bezpieczeństwa

- Zaloguj się jako app → `SELECT` na istniejącym obiekcie `shop` działa.
- Zaloguj się jako app → próba `CREATE TABLE shop.Denied(...)` musi zakończyć się odmową.
- Jako app → `ALTER TABLE` musi zostać odmówione.
- Jako app → próba modyfikacji schematu `dbo` musi zostać odmówiona.
- Jako deploy → migracja działa po zatwierdzeniu; nie przyznajemy `db_owner` jako „szybkiej naprawy”.
- Brak `Database.Migrate()` i `MigrateAsync()` w uruchomieniu API.

Jeżeli skrypt migracji nie przechodzi z ograniczonym kontem, ustal **konkretną brakującą operację i uprawnienie**; nie poszerzaj konta na stałe. Bootstrap nie jest procesem odtwarzania produkcyjnego.

## Materiały odniesienia

- [EF Core: Applying Migrations](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/applying)
- [SQL Server: Permissions](https://learn.microsoft.com/en-us/sql/relational-databases/security/permissions-database-engine)
