# Lab 08 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Finał ORM Shop

## Cel
Po wykonaniu student potrafi odtworzyć czynności i wskazać dowody działania oraz granice uprawnień.

## Krok 1. Przed zjazdem

Zatwierdź repozytorium: README, instrukcja Docker, diagram ERD, kod API, migracje, testy, przykłady T-SQL, opis ról, wyniki wydajności. Finał trwa tylko 45 minut, więc student nie implementuje już nowych funkcji.

## Krok 2. Uruchom z czystego stanowiska

~~~powershell
git status
docker compose up -d
dotnet build src/OrmShop.Api/OrmShop.Api.csproj
dotnet run --project src/OrmShop.Api/OrmShop.Api.csproj
~~~
Weryfikuj właściwą wersję CU26 i istniejącą bazę; bez automatycznej migracji.

## Krok 3. Zaprezentuj zachowanie

Pokaż GET/POST/PUT, relacje, raport Dapper i demonstrację jednego zapytania LINQ z SQL Server. Przy większej grupie zrób demonstracje wybranych projektów, resztę oceniaj na podstawie repo i testów.

## Krok 4. Udowodnij bezpieczeństwo

Oddzielne połączenia w SSMS: app bez DDL, deploy tylko na kontrolowane zmiany; pokaż wyniki HAS_PERMS_BY_NAME i brak `sa` w kodzie aplikacji.

## Krok 5. Przedstaw analizę

Pokaż przypadek konfliktu rowversion, test rollback i raport porównawczy (liczba wywołań, logical reads, elapsed). Podaj uzasadnienie wyboru EF Core i Dapper.

## Krok 6. Zamknij projekt

Oddaj wersję kodu, checklistę przejścia i krótkie podsumowanie: jeden kompromis ORM, jeden aspekt bezpieczeństwa, jeden mierzalny wynik wydajności.

## Oddanie etapu

Ocena według wspólnych kryteriów i rzeczywistych dowodów działania, nie wyłącznie prezentacji slajdów.

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
