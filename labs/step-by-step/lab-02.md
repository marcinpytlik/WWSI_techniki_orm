# Lab 02 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Pierwsza migracja wykonywana kontem deploy

## Cel
Po wykonaniu student potrafi odtworzyć czynności i wskazać dowody działania oraz granice uprawnień.

## Krok 1. Sprawdź model

Otwórz `src/OrmShop.Api/Models.cs` i `ShopDbContext.cs`. Wskaż klucze główne, `RowVersion`, schemat `shop`, indeks `Sku`. W starterze model zawiera już także Order i OrderLine — pierwsza migracja utworzy wszystkie cztery tabele.

## Krok 2. Sprawdź konfigurację historii migracji

W `Program.cs` odnajdź `MigrationsHistoryTable("__EFMigrationsHistory", "shop")`. Dzięki temu historia znajdzie się w tym samym schemacie co encje. Skontroluj, czy **nie** ma `Database.Migrate()` ani `EnsureCreated()`.

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

Otwórz nową sesję SSMS z loginem **orm_shop_deploy**, bazą **OrmShop**; otwórz `artifacts/OrmShop.Migrations.sql` i wykonaj zatwierdzony skrypt. Jeśli uprawnienie blokuje konkretne DDL, zapisz kod błędu i przeanalizuj z prowadzącym. **Nie dodawaj db_owner i nie przełączaj sesji na sa, żeby ominąć problem.**

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

**Powiązane źródła:** [architektura bezpieczeństwa](architecture-and-security.md), [projekt C#](../src/README.md), [wspólny model](../lectures/orm-shop-case-study.md).

> Status: instrukcja prowadząca przez etap. W laboratoriach 05–07 część implementacji jest zadaniem studenta; test uruchomieniowy całego kursu nie został jeszcze wykonany na żywym kontenerze.
