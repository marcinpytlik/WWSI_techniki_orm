# ORM Shop — starter .NET 10 + EF Core 10

Pierwszy etap kodu wykorzystywany przez laboratoria. **To starter**, nie gotowe rozwiązanie końcowe.

## Start

W katalogu głównym repo:

```powershell
dotnet restore src/OrmShop.Api/OrmShop.Api.csproj
cd src/OrmShop.Api
dotnet user-secrets set "ConnectionStrings:ShopDb" "Server=localhost,14333;Database=OrmShop;User ID=orm_shop_app;Password=<WŁASNE_HASŁO_APP>;Encrypt=True;TrustServerCertificate=True"
dotnet run
```

Podmień `<WŁASNE_HASŁO_APP>` na lokalne hasło. **Nie zapisuj rzeczywistego connection stringu w Git.** Uwaga: historyczne polecenia shell mogą ujawniać sekrety; rozważ interaktywne wprowadzenie danych i czyszczenie historii.

Po wykonaniu migracji `/products` zwróci listę (na początku pustą). `/health` odpowiada bez połączenia z bazą.

## Migracje — oddzielone od runtime

Z katalogu głównego repo:

```powershell
.\labs\scripts\prepare-first-migration.ps1
```

Wygenerowany plik `artifacts/OrmShop.Migrations.sql` musi zostać przejrzany przed wykonaniem przez użytkownika **orm_shop_deploy**. Konto aplikacji nie ma DDL.

Ważne: komenda `dotnet ef migrations add` w design-time używa konfiguracji aplikacji (zwykle user-secrets). Nie wykonuje DDL. **W żadnym miejscu nie wykonuj** `dotnet ef database update` na połączeniu runtime.

## Następne etapy

Lab 03–07 rozbudowują endpointy, operacje biznesowe, testy i pomiary. W tym starterze celowo nie ma automatycznych migracji, Dapper ani warstwy serwisowej.
