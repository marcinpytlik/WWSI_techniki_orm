# Lab 01 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Przygotowanie środowiska i separacja tożsamości

## Cel
Po wykonaniu student potrafi odtworzyć czynności i wskazać dowody działania oraz granice uprawnień.

## Krok 1. Zweryfikuj narzędzia

~~~powershell
dotnet --list-sdks
dotnet ef --version
git status
docker compose version
docker info
~~~
**Wynik:** dostępny .NET SDK 10, EF CLI 10, Docker Linux; brak błędów.

## Krok 2. Uruchom bazę

~~~powershell
Copy-Item .env.example .env  # tylko jeśli .env nie istnieje
notepad .env                  # ustaw indywidualne silne hasło sa
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail 50 sqlserver
~~~
**Wynik:** kontener orm-sql2022 uruchomiony. Healthcheck sprawdza port, nie poprawność logowania.

## Krok 3. Sprawdź wersję w SSMS

Połącz `localhost,14333` jako `sa` (tylko bootstrap). Wykonaj:
~~~sql
SELECT SERVERPROPERTY('ProductVersion') AS Build,
       SERVERPROPERTY('ProductUpdateLevel') AS CU,
       SERVERPROPERTY('Edition') AS Edition;
~~~
Oczekiwany build **16.0.4265.3**, CU26.

## Krok 4. Załóż bazę i schema

W połączeniu administratora otwórz i uruchom [01-bootstrap.sql](security/01-bootstrap.sql). Potwierdź:
~~~sql
SELECT name, compatibility_level FROM sys.databases WHERE name=N'OrmShop';
SELECT name FROM OrmShop.sys.schemas WHERE name=N'shop';
~~~
**Wynik:** baza OrmShop, CL160, schemat shop.

## Krok 5. Załóż osobne konta

W SSMS włącz **Query → SQLCMD Mode**, otwórz [02-create-logins.sql](security/02-create-logins.sql), zastąp dwa hasła różnymi silnymi losowymi hasłami, nie zapisuj w repo i wykonaj **na izolowanym lokalnym SQL Server**. Unikaj zapisu pliku z hasłami. Dla wieloosobowej instancji uczelni konta i sekrety nadaje administrator, nie student.

## Krok 6. Zweryfikuj granice

Wykonaj [03-verify-permissions.sql](security/03-verify-permissions.sql) jako administrator. Utwórz **oddzielne** połączenie w SSMS jako `orm_shop_app` do bazy OrmShop, wykonaj:
~~~sql
SELECT USER_NAME() AS DbUser, ORIGINAL_LOGIN() AS LoginName;
SELECT HAS_PERMS_BY_NAME(N'shop',N'SCHEMA',N'ALTER') AS CanAlterShop;
SELECT HAS_PERMS_BY_NAME(N'OrmShop',N'DATABASE',N'CREATE TABLE') AS CanCreateTable;
~~~
Wynik testów uprawnień: oba **0**. Dla deploy sprawdź, że może ALTER schematu shop, ale nie jest członkiem db_owner.

## Krok 7. Uruchom starter C#

~~~powershell
dotnet restore src/OrmShop.Api/OrmShop.Api.csproj
dotnet build src/OrmShop.Api/OrmShop.Api.csproj
cd src/OrmShop.Api
dotnet user-secrets init
dotnet user-secrets set "ConnectionStrings:ShopDb" "Server=localhost,14333;Database=OrmShop;User ID=orm_shop_app;Password=WPISZ_WLASNE_HASLO;Encrypt=True;TrustServerCertificate=True"
dotnet run
~~~
Zamiast wklejać sekret do powłoki z historią, użyj interaktywnej konfiguracji lub sekretów środowiska; powyższy tekst jest szablonem. Endpoint `/health` działa; `/products` nie będzie działać do czasu pierwszej migracji w Lab 02.

## Oddanie etapu

Zapisz numer builda, zrzut ról oraz wynik odmowy DDL. W ramach Lab 01 nie twórz tabel kontem app.

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
