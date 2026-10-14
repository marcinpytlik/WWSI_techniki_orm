# ORM Shop — starter .NET 10 + EF Core 10

Pierwszy etap kodu wykorzystywany przez laboratoria. **To starter**, nie gotowe rozwiązanie końcowe. Zapis, Dapper i testy integracyjne dopisują studenci od Lab 05.

## Start

W katalogu głównym repo:

```powershell
dotnet build OrmShop.sln
cd src/OrmShop.Api
dotnet user-secrets set "ConnectionStrings:ShopDb" "Server=127.0.0.1,14333;Database=OrmShop;User ID=orm_shop_app;Password=<WŁASNE_HASŁO_APP>;Encrypt=True;TrustServerCertificate=True"
dotnet run
```

`Properties/launchSettings.json` ustawia środowisko Development i adres http://localhost:5080. User-secrets są czytane tylko w Development. W tym środowisku konsola wypisuje tekst SQL wygenerowany przez EF Core, bez wartości parametrów.

Podmień `<WŁASNE_HASŁO_APP>` na lokalne hasło. **Nie zapisuj rzeczywistego connection stringu w Git.** Uwaga: historyczne polecenia shell mogą ujawniać sekrety; rozważ interaktywne wprowadzenie danych i czyszczenie historii.

Po wykonaniu migracji `GET /products` zwróci listę (na początku pustą) razem z `RowVersion` zakodowanym jako Base64. `GET /health` odpowiada bez połączenia z bazą.

## Organizacja kodu

```text
src/OrmShop.Api/
├── Entities/
│   ├── Customer.cs
│   ├── Product.cs
│   ├── Order.cs
│   └── OrderLine.cs
├── Data/
│   ├── ShopDbContext.cs
│   ├── ShopDbContextFactory.cs
│   └── Configurations/
│       ├── CustomerConfiguration.cs
│       ├── ProductConfiguration.cs
│       ├── OrderConfiguration.cs
│       └── OrderLineConfiguration.cs
├── Program.cs
└── OrmShop.Api.csproj
```

Każda encja ma własny plik i przestrzeń nazw `OrmShop.Api.Entities`. Klasy odpowiedzialne za konfigurację dostępu do danych należą do `OrmShop.Api.Data`. Każda encja ma własną klasę `IEntityTypeConfiguration<T>` w `Data/Configurations`, a `ShopDbContext.OnModelCreating` ładuje je przez `ApplyConfigurationsFromAssembly`. Ten refaktoring nie zmienia istniejącej migracji `InitialShopSchema`. Nie twórz ponownie `Models.cs`; ten plik usunięto podczas porządkowania struktury.

## Model

Cztery encje są w starterze od pierwszej migracji: Customer, Product, Order, OrderLine. `Product.RowVersion` startuje od `null`, bo pusta tablica zostałaby potraktowana jako wartość do zapisu w kolumnie `rowversion`. `Order.CreatedAt` jest typu `DateTimeOffset`, a domyślna wartość SQL to `SYSUTCDATETIME()`.

## Migracje — oddzielone od runtime

Z katalogu głównego repo, PowerShell albo bash:

```powershell
.\labs\scripts\prepare-first-migration.ps1
```

```bash
./labs/scripts/prepare-first-migration.sh
```

`ShopDbContextFactory` pozwala wygenerować migrację bez żywej bazy. Jeśli user-secrets zawierają `ConnectionStrings:ShopDb`, fabryka użyje tego connection stringu. Placeholder w kodzie fabryki nie jest hasłem i nie jest czytany przez `Program.cs`.

Wygenerowany plik `artifacts/OrmShop.Migrations.sql` musi zostać przejrzany przed wykonaniem przez użytkownika **orm_shop_deploy**. Konto aplikacji nie ma DDL.

Ważne: komenda `dotnet ef migrations add` w design-time nie wykonuje DDL. **W żadnym miejscu nie wykonuj** `dotnet ef database update` na połączeniu runtime.

## Następne etapy

Lab 03–07 rozbudowują endpointy, operacje biznesowe, testy i pomiary. W tym starterze celowo nie ma automatycznych migracji, Dappera ani warstwy serwisowej.
