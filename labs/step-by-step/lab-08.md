# Lab 08 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Finał ORM Shop

## Cel
Student w 45 minut pokazuje projekt oddany przed zajęciami. Na sali nie dopisuje funkcji.

## Krok 1. Przed zjazdem

Zatwierdź repozytorium dzień wcześniej: README, instrukcja uruchomienia, diagram ERD, kod API, migracje, testy, przykłady T-SQL, opis ról i wyniki wydajności. Termin zjazdu ustala dziekanat; do tego czasu data w planie pozostaje pusta. Finał na sali trwa 45 minut i nie służy do dopisywania funkcji.

## Krok 2. Uruchom z czystego stanowiska

~~~powershell
git status
docker compose up -d
dotnet build OrmShop.sln
dotnet run --project src/OrmShop.Api/OrmShop.Api.csproj
~~~
API ma odpowiedzieć na http://localhost:5080/health. Zweryfikuj CU26 i istniejącą bazę. Migracja nie uruchamia się razem z procesem.

## Krok 3. Zaprezentuj zachowanie

Każdy pokaz trwa do 6 minut, w stałej kolejności: start API na http://localhost:5080, jeden LINQ razem z SQL, konflikt 409, odmowa DDL dla konta aplikacji. Siedem takich pokazów wypełnia 45 minut. Przy liczniejszej grupie na żywo wchodzą wybrane projekty, a pozostałe są oceniane z repozytorium oddanego przed zjazdem.

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

**Powiązane źródła:** [architektura bezpieczeństwa](../architecture-and-security.md), [projekt C#](../../src/README.md), [wspólny model](../../lectures/orm-shop-case-study.md).
