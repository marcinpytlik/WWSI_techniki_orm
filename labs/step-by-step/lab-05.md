# Lab 05 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na localhost,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** CRUD i Change Tracker

## Cel
Student dodaje zapis produktu przez DTO. Aktualizacja wysyła RowVersion pobrany wcześniej przez GET, więc nieaktualny klient dostaje HTTP 409.

## Krok 1. Utwórz kontrakty DTO

W `src/OrmShop.Api` dodaj `ProductContracts.cs`:
~~~csharp
namespace OrmShop.Api;
public sealed record CreateProduct(string Sku, string Name, decimal Price);
public sealed record UpdateProduct(string Name, decimal Price, byte[] RowVersion);
~~~
Nie przyjmuj encji EF jako bezpośredniego kontraktu HTTP. `RowVersion` pochodzi z `GET /products` (JSON koduje `byte[]` jako Base64).

## Krok 2. Dodaj POST

W `Program.cs` dodaj:
~~~csharp
app.MapPost("/products", async (CreateProduct input, ShopDbContext db, CancellationToken ct) =>
{
    if (string.IsNullOrWhiteSpace(input.Sku) || input.Price < 0)
        return Results.BadRequest();
    var p = new Product { Sku=input.Sku, Name=input.Name, Price=input.Price };
    db.Products.Add(p);
    await db.SaveChangesAsync(ct);
    return Results.Created($"/products/{p.Id}", new { p.Id });
});
~~~
Dodatkowo waliduj długości Sku (40) i Name (120) zgodnie z modelem.

## Krok 3. Dodaj PUT z tokenem klienta

`FindAsync` wczytuje aktualny `RowVersion`. Samo przypisanie `Name` i `Price` po takim odczycie prawie nigdy nie zgłosi konfliktu, bo klauzula `WHERE` dostałaby token świeżo pobrany z bazy. Podmień oryginalną wartość na token przysłany przez klienta:

~~~csharp
app.MapPut("/products/{id:int}", async (int id, UpdateProduct input, ShopDbContext db, CancellationToken ct) =>
{
    var product = await db.Products.FindAsync([id], ct);
    if (product is null) return Results.NotFound();
    if (string.IsNullOrWhiteSpace(input.Name) || input.Name.Length > 120 || input.Price < 0)
        return Results.BadRequest();

    db.Entry(product).Property(x => x.RowVersion).OriginalValue = input.RowVersion;
    product.Name = input.Name;
    product.Price = input.Price;
    try
    {
        await db.SaveChangesAsync(ct);
    }
    catch (DbUpdateConcurrencyException)
    {
        return Results.Conflict(new { error = "Product changed. Reload RowVersion and retry." });
    }
    return Results.NoContent();
});
~~~
Uzupełnij wyjątek unikalności SKU. Prezentowany kod jest etapem ćwiczenia: nie zwracaj connection stringu ani stack trace.

## Krok 4. Sprawdź HTTP

W PowerShell użyj `Invoke-RestMethod` i adresu http://localhost:5080. Utwórz produkt, odczytaj `RowVersion` z GET i wyślij go w PUT. Wywołaj błędne dane, oczekuj 400, nieistniejący Id → 404. Drugi PUT ze starym `RowVersion` ma zwrócić 409.

## Krok 5. Śledzenie zmian

Przed `SaveChangesAsync` odczytaj `db.Entry(p).State` i `db.ChangeTracker.DebugView.ShortView`; porównaj stany Added/Modified/Unchanged i SQL INSERT/UPDATE. Pokaż, dlaczego `db.Update()` na niezweryfikowanym grafie jest niebezpieczne.

## Krok 6. Obsługa konfliktów

Wstaw produkt z istniejącym Sku i przeanalizuj wyjątek unikalności. Uzupełnij obsługę `DbUpdateException` z rozpoznaniem błędów SQL Server 2601/2627 (nie zwracaj treści connection stringu ani stack trace). Celem jest HTTP 409, a nie 500.

## Oddanie etapu

Przygotuj testy poprawnych i błędnych danych oraz dowody, że API nadal działa wyłącznie na orm_shop_app.

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
