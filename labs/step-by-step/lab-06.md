# Lab 06 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Transakcje i współbieżność

## Cel
Po wykonaniu student potrafi odtworzyć czynności i wskazać dowody działania oraz granice uprawnień.

## Krok 1. Sprawdź rowversion

W `ShopDbContext.cs` potwierdź `Property(p=>p.RowVersion).IsRowVersion()`. W SQL Server:
~~~sql
SELECT c.name, TYPE_NAME(c.user_type_id) AS TypeName
FROM sys.columns c WHERE c.object_id=OBJECT_ID(N'shop.Products');
~~~
Oczekuj kolumny RowVersion typu timestamp/rowversion.

## Krok 2. Symuluj konkurencyjne zapisy

W tym samym procesie otwórz **dwa różne DbContext** (np. przez `IDbContextFactory` w wydzielonym testowym projekcie albo dwa osobne scope DI). Oba pobierają Product o tym samym Id; pierwszy zmienia Price i SaveChanges, drugi próbuje zapisać swoją zmianę. Oczekuj `DbUpdateConcurrencyException` dla drugiego.

## Krok 3. Obsłuż konflikt w aplikacji

Złap `DbUpdateConcurrencyException` w obsłudze aktualizacji, zwróć HTTP 409 i poinformuj klienta o potrzebie ponownego pobrania danych. Nie powtarzaj zapisu bez decyzji o rozstrzygnięciu konfliktu.

## Krok 4. Atomowe utworzenie zamówienia

Dopisz use-case tworzenia Order + OrderLine. Zapisz komplet obiektów w jednej jednostce pracy i `SaveChangesAsync`. Pokaż drugi wariant z `BeginTransactionAsync`, gdy proces obejmuje wiele zapisów; w `try/catch` zatwierdzaj lub wycofuj transakcję.

## Krok 5. Udowodnij rollback

W wymuszonej awarii (np. niepoprawny ProductId) sprawdź, że nie ma osieroconego Order. Rejestruj ilość rekordów przed i po, test uruchom na danych ćwiczeniowych.

## Krok 6. Rozróżnij mechanizmy

Przygotuj tabelę z RCSI, SNAPSHOT i rowversion. Które dotyczą izolacji odczytu, a które wykrywania zmian? Omów idempotencję retry i Outbox jako materiał rozszerzający.

## Oddanie etapu

Oddaj test dwóch kontekstów, obsługę 409 i dowód rollback.

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
