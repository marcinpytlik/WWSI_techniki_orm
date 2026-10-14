# Lab 04 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** LINQ i generowany SQL

## Cel
Student porównuje zapytanie LINQ z T-SQL widocznym w logu Development i w wyniku ToQueryString.

## Krok 1. Przygotuj bazę

Wprowadź kilka klientów i zamówień korzystając z runtime DML. Nie twórz danych migracją; zadbaj o przewidywalne rekordy i brak prawdziwych danych osobowych.

## Krok 2. Uruchom istniejące endpointy

~~~powershell
dotnet run --project src/OrmShop.Api/OrmShop.Api.csproj
~~~
Aplikacja słucha na http://localhost:5080. Wywołaj `/customers` i `/products`. Endpointy korzystają z projekcji i `AsNoTracking`. W Development konsola wypisuje tekst SQL (`LogLevel.Information` dla `Microsoft.EntityFrameworkCore.Database.Command`). `/products` zwraca także `RowVersion` jako Base64 — ten token przyda się w Lab 05.

## Krok 3. Dodaj filtrowanie miasta

W `Program.cs` **zamień** endpoint `/customers` (nie duplikuj tej samej ścieżki) na wersję z parametrem `string? city`:
~~~csharp
app.MapGet("/customers", async (string? city, ShopDbContext db, CancellationToken ct) =>
{
    var q = db.Customers.AsNoTracking();
    if (!string.IsNullOrWhiteSpace(city))
        q = q.Where(c => c.City == city);
    return await q.OrderBy(c => c.Id)
        .Select(c => new { c.Id, c.Name, c.City }).ToListAsync(ct);
});
~~~
Sprawdź `/customers?city=Warszawa`.

## Krok 4. Zaobserwuj SQL

Zapisz końcowe zapytanie, już po `Where`, `OrderBy` i `Select`, i wywołaj na nim `ToQueryString()` przed `ToListAsync`. Log konsoli pokazuje to samo polecenie przy wykonaniu. Nie włączaj `EnableSensitiveDataLogging`: parametry mają zostać placeholderami.

## Krok 5. Porównaj Include i projekcję

Porównaj dwie wersje `db.Customers.OrderBy(c=>c.Id).Take(100).Include(c=>c.Orders)` i projekcję `Select(c => new { c.Id, OrderCount=c.Orders.Count })`. Wygeneruj `ToQueryString()`, uruchom w SSMS i zapisz liczbę kolumn/wierszy.

## Krok 6. Split query i plan

Porównaj `AsSplitQuery()` i wersję bez podziału; licz zapytania i oceń konsekwencje. Zapisz actual execution plan oraz obserwacje o podzapytaniu wynikającym z `Take`. Nie twierdź, że każda wersja EF generuje identyczny SQL.

## Oddanie etapu

Oddaj 3 fragmenty LINQ, ich T-SQL, komentarz o liczbie zapytań i planach.

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
