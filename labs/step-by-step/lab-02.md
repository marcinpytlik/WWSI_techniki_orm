# Lab 02 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na 127.0.0.1,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Pierwsza migracja wykonywana kontem deploy

## Cel
Student generuje migrację czterech encji, przegląda idempotentny skrypt i wykonuje go wyłącznie jako orm_shop_deploy.

## Krok 1. Sprawdź model

Otwórz cztery osobne klasy: `src/OrmShop.Api/Entities/Customer.cs`, `Product.cs`, `Order.cs` oraz `OrderLine.cs`. Następnie otwórz `src/OrmShop.Api/Data/ShopDbContext.cs`. Każda encja ma osobny plik i przestrzeń nazw `OrmShop.Api.Entities`; kontekst i fabryka są w `OrmShop.Api.Data`. Wskaż klucze główne, `RowVersion` inicjalizowany jako `null`, `CreatedAt` typu `DateTimeOffset`, schemat `shop` i indeks `Sku`. W starterze model zawiera już także Order i OrderLine — pierwsza migracja utworzy wszystkie cztery tabele. Nie dopisuj tych klas drugi raz.

## Krok 2. Sprawdź konfigurację historii migracji

W `Program.cs` odnajdź `MigrationsHistoryTable("__EFMigrationsHistory", "shop")`. Dzięki temu historia znajdzie się w tym samym schemacie co encje. Skontroluj, czy **nie** ma `Database.Migrate()` ani `EnsureCreated()`. `Data/ShopDbContextFactory.cs` pozwala wygenerować migrację bez żywej bazy. Placeholder w fabryce nie jest hasłem runtime i nie jest czytany przez `Program.cs`.

## Krok 3. Wygeneruj migrację

~~~powershell
dotnet ef migrations add InitialShopSchema --project src/OrmShop.Api/OrmShop.Api.csproj --startup-project src/OrmShop.Api/OrmShop.Api.csproj
~~~
**Wynik:** katalog Migrations i plik migracji C#; polecenie **nie wdraża** DDL. Jeśli migracja już istnieje, NIE generuj duplikatu.

## Krok 4. Wygeneruj skrypt do przeglądu

~~~powershell
New-Item -ItemType Directory artifacts -Force | Out-Null
dotnet ef migrations script --idempotent --project src/OrmShop.Api/OrmShop.Api.csproj --startup-project src/OrmShop.Api/OrmShop.Api.csproj --output artifacts/OrmShop.Migrations.sql
~~~
Otwórz SQL w VS Code i znajdź `CREATE TABLE`, `CREATE INDEX`, `__EFMigrationsHistory`. Zapisz wnioski: jakie DDL i czy mogą utracić dane?

## Krok 5. Uruchom zatwierdzoną migrację

Otwórz nową sesję MSSQL w VS Code (ewentualnie SSMS) z loginem **orm_shop_deploy**, bazą **OrmShop**; otwórz `artifacts/OrmShop.Migrations.sql` i wykonaj zatwierdzony skrypt. Jeśli uprawnienie blokuje konkretne DDL, zapisz kod błędu i przeanalizuj z prowadzącym. **Nie dodawaj db_owner i nie przełączaj sesji na sa, żeby ominąć problem.**

## Krok 6. Zweryfikuj rezultat

~~~sql
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables AS t JOIN sys.schemas AS s ON s.schema_id=t.schema_id
WHERE s.name=N'shop';
SELECT * FROM shop.__EFMigrationsHistory;
~~~
Wykonaj pierwsze SELECT z runtime `orm_shop_app`. Sprawdź, że próbne CREATE TABLE wciąż jest niedozwolone.

## Oddanie etapu

Wymagane: zrzut schema, historia migracji, bezpieczny skrypt i dowód rozdzielenia kont.

## Diagnostyka

- Błąd 18456: sprawdź login/hasło/port i domyślną bazę.
- Błędy 229 / 262: sprawdź konto i wymagane uprawnienie; **nie nadaj db_owner jako obejścia**.
- Brak tabel: zweryfikuj wykonanie skryptu przez konto migracji i historię migracji.
- Brak połączenia: `docker compose ps`, `docker compose logs sqlserver`, port 14333.
- Błąd build: `dotnet restore`, `dotnet build`; sprawdź referencje pakietów.

## Kontrola bezpieczeństwa

- [ ] Brak sekretów w Git.
- [ ] Brak `Database.Migrate()` w procesie API.
- [ ] Konto runtime nie ma DDL.
- [ ] Skrypt migracji przejrzany i uruchomiony oddzielnie.
- [ ] Wyniki i błędy zostały zapisane bez ujawnienia haseł.

**Powiązane źródła:** [architektura bezpieczeństwa](../architecture-and-security.md), [projekt C#](../../src/README.md), [wspólny model](../../lectures/orm-shop-case-study.md).
