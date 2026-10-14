# Lab 07 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Wydajność i testy

## Cel
Po wykonaniu student potrafi odtworzyć czynności i wskazać dowody działania oraz granice uprawnień.

## Krok 1. Przygotuj reprezentatywne dane

Zasil lokalną bazę kontrolowanymi danymi testowymi, np. 100 klientów, po kilka zamówień. Zanotuj wielkość danych. Nie porównuj wydajności pojedynczego pustego SELECT.

## Krok 2. Zademonstruj N+1

W wersji demonstracyjnej pobierz listę klientów, następnie w pętli `foreach` wykonuj oddzielne `db.Orders.Where(o=>o.CustomerId==c.Id).ToListAsync()`. Policz wykonane polecenia. Porównaj z projekcją i kolekcją pobraną w sposób kontrolowany. Nie przypisuj tego zjawiska domyślnie włączonemu lazy loading.

## Krok 3. Pomierz SQL

W SSMS wykonaj zapytania testowe z:
~~~sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
-- wstaw SQL uzyskany z ToQueryString(); ustaw parametry
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
~~~
Zbierz logical reads, CPU, elapsed, actual execution plan.

## Krok 4. Query Store

Administrator labowy (nie konto runtime) może włączyć Query Store:
~~~sql
ALTER DATABASE OrmShop SET QUERY_STORE = ON;
~~~
Następnie przejrzyj identyfikację zapytań i planów; w systemie wspólnym wymagana zgoda administratora.

## Krok 5. Porównaj SQL-first

Zainstaluj `dotnet add src/OrmShop.Api/OrmShop.Api.csproj package Dapper` i `Microsoft.Data.SqlClient`. Zaimplementuj oddzielny odczyt raportowy `SELECT...` z parametrem do `QueryAsync<T>`, używając **orm_shop_app**, nie loginu deploy. Wyniki porównaj z LINQ o tej samej semantyce. Pakietu Dapper nie ma jeszcze w starterze.

## Krok 6. Dodaj test integracyjny

Utwórz projekt testowy xUnit i skonfiguruj połączenie z oddzielną bazą testową SQL Server. Sprawdź CRUD, FK, migrację, rowversion i transakcję. Nie zastępuj SQL Server providerem InMemory, gdy test dotyczy semantyki SQL.

## Krok 7. Przygotuj odbiór

Zapisz w raporcie: funkcje aplikacji, role, skrócone wyniki testów i porównanie IO/CPU. Utwórz tag/przygotuj commit wersji przed finałem. Usuń sekrety i dane osobowe.

## Oddanie etapu

Dostarcz pomiary przed/po, działający odczyt przez Dapper i test integracyjny SQL Server.

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
