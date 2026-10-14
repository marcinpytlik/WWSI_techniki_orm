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

## 2. SQL Server 2022 CU26 — Docker

**Wersja obowiązująca dla kursu:** SQL Server 2022 Developer CU26 (KB5093420), build `16.0.4265.3`, Ubuntu 22.04, tag `2022-CU26-ubuntu-22.04`. Nie używaj `2022-latest`, ponieważ jego zawartość może się zmieniać.

Przed uruchomieniem kontenera pobierz dokładnie określony obraz:

~~~powershell
docker pull mcr.microsoft.com/mssql/server:2022-CU26-ubuntu-22.04
~~~

Użyj lokalnego kontenera do ćwiczeń (nie do produkcji). Hasło podaj interaktywnie i nie zapisuj go w repozytorium.

~~~powershell
docker volume create orm_sql_data
$SqlPassword = Read-Host 'Podaj silne haslo sa'
docker run -d --name orm-sql2022 `
  -e 'ACCEPT_EULA=Y' `
  -e "MSSQL_SA_PASSWORD=$SqlPassword" `
  -p 127.0.0.1:14333:1433 `
  -v orm_sql_data:/var/opt/mssql `
  mcr.microsoft.com/mssql/server:2022-CU26-ubuntu-22.04
docker ps
docker logs --tail 50 orm-sql2022
~~~

Hasło sa musi spełniać wymagania złożoności SQL Server. Docker musi mieć odpowiednią ilość pamięci. Dane pozostają w wolumenie Docker.

Połącz się w SSMS: **localhost,14333**, SQL Server Authentication, login **sa**, hasło podane podczas uruchamiania. W lokalnym laboratorium, jeśli certyfikat nie jest zaufany, można zaznaczyć **Trust server certificate**; nie przenoś tego ustawienia bez analizy do produkcji.

Sprawdź połączenie:

~~~sql
SELECT @@VERSION AS SqlServerVersion;
SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel,
       SERVERPROPERTY('Edition') AS Edition;
SELECT DB_NAME() AS CurrentDatabase;

-- Oczekiwany build: 16.0.4265.3, CU26
-- Zgodność bazy ćwiczeniowej (po jej utworzeniu):
SELECT name, compatibility_level FROM sys.databases;
~~~

Uruchamianie i zatrzymywanie:

~~~powershell
docker stop orm-sql2022
docker start orm-sql2022
docker logs --tail 100 orm-sql2022
~~~

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

- [ ] .NET 10 SDK działa (dotnet --version)
- [ ] VS Code uruchamia się i rozpoznaje kod C#
- [ ] Git działa
- [ ] SQL Server jest osiągalny z SSMS albo VS Code
- [ ] SELECT @@VERSION działa
- [ ] dotnet ef --version działa
- [ ] Projekt testowy dotnet run kończy się bez błędu
- [ ] Mam dostęp do repozytorium albo zgłosiłem problem prowadzącemu

## 6. Typowe problemy

- Docker się nie uruchamia: sprawdź WSL 2, wirtualizację, przydzieloną pamięć, docker logs.
- Port 14333 jest zajęty: zmień port hosta i odpowiednio adres połączenia.
- Nie można pobrać pakietów: sprawdź połączenie z https://api.nuget.org/v3/index.json.
- Brak uprawnień administratora: skorzystaj z instancji SQL Server udostępnionej przez uczelnię.

**Przynieś laptop z działającym środowiskiem na 25 października.**