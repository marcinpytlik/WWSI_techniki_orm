# Przygotowanie środowiska — pierwszy zjazd ORM

**Data:** 25.10.2026 (niedziela). **System referencyjny:** Windows 11, PowerShell.

## Wymagane narzędzia

| Narzędzie | Cel |
|---|---|
| [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0) | C#, kompilacja i uruchamianie aplikacji |
| [VS Code](https://code.visualstudio.com/) + rozszerzenie C# | Edycja kodu (C# Dev Kit opcjonalnie, zgodnie z licencją) |
| [Git](https://git-scm.com/download/win) | Pobranie materiałów |
| [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) + WSL 2 | Zalecana lokalna instancja SQL Server; sprawdź wymagania sprzętowe i licencję |
| [SSMS](https://learn.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms) lub [MSSQL extension](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql) | Połączenie z bazą i analiza T-SQL |
| dotnet-ef | Migracje Entity Framework Core |

**Alternatywa dla Dockera:** działająca instancja SQL Server 2022 udostępniona przez uczelnię lub zainstalowana lokalnie. Nie trzeba instalować obu wariantów.

## 1. Test po instalacji

Uruchom PowerShell:

~~~powershell
dotnet --info
dotnet --list-sdks
code --version
git --version
wsl --status
docker --version
docker info
~~~

Dwa ostatnie polecenia i WSL dotyczą wariantu kontenerowego. Docker Desktop powinien działać w trybie kontenerów Linux.

## 2. SQL Server 2022 CU26 — Docker Compose

**Obowiązująca metoda uruchomienia:** [Instrukcja Docker Compose](docker-sql-server.md). W katalogu głównym repozytorium:

~~~powershell
Copy-Item .env.example .env
notepad .env  # ustaw własne silne hasło sa
docker compose pull
docker compose up -d
docker compose ps
~~~

Połącz się z `localhost,14333` jako `sa`. Wykonaj w SSMS:

~~~sql
SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel;
~~~

Oczekiwane wartości: `16.0.4265.3` i `CU26`. Dokładny obraz: `mcr.microsoft.com/mssql/server:2022-CU26-ubuntu-22.04`.

## 3. Entity Framework Core — instalacja i test

~~~powershell
dotnet tool install --global dotnet-ef --version '10.*'
dotnet ef --version
mkdir ORM-Check
cd ORM-Check
dotnet new console --framework net10.0
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version '10.*'
dotnet add package Microsoft.EntityFrameworkCore.Design --version '10.*'
dotnet restore
dotnet run
~~~

Stosuj zgodną wersję główną narzędzia dotnet-ef i pakietów Microsoft.EntityFrameworkCore.*. Powyższy projekt tylko testuje instalację; DbContext zbudujemy na laboratorium.

Jeśli polecenie dotnet ef nie działa, uruchom nowy terminal i sprawdź PATH dla katalogu narzędzi globalnych .NET (zwykle %USERPROFILE%\.dotnet\tools).

## 4. Materiały kursu

~~~powershell
git clone https://github.com/marcinpytlik/WWSI_techniki_orm.git
cd WWSI_techniki_orm
git status
~~~

Repozytorium jest prywatne — prowadzący musi nadać dostęp studentom.

## 5. Checklista przed pierwszym zjazdem

- [ ] .NET 10 SDK działa (`dotnet --version`; `global.json` wymaga SDK 10 i rolki do nowszego wydania 10.x)
- [ ] VS Code uruchamia się i rozpoznaje kod C#
- [ ] Git działa
- [ ] SQL Server jest osiągalny z SSMS albo VS Code
- [ ] SELECT @@VERSION działa
- [ ] dotnet ef --version działa
- [ ] Projekt testowy dotnet run kończy się bez błędu
- [ ] Mam dostęp do repozytorium albo zgłosiłem problem prowadzącemu
- [ ] `dotnet build OrmShop.sln` w sklonowanym repozytorium kończy się powodzeniem

## 6. Typowe problemy

- Docker się nie uruchamia: sprawdź WSL 2, wirtualizację, przydzieloną pamięć, docker logs.
- Port 14333 jest zajęty: zmień port hosta i odpowiednio adres połączenia.
- Nie można pobrać pakietów: sprawdź połączenie z https://api.nuget.org/v3/index.json.
- Brak uprawnień administratora: skorzystaj z instancji SQL Server udostępnionej przez uczelnię.

**Przynieś laptop z działającym środowiskiem na 25 października.**