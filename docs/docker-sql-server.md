# SQL Server 2022 CU26 — Docker Compose

Instrukcja do laboratoriów **Narzędzia i techniki ORM**.

## Wymagania

Docker Desktop z uruchomionym silnikiem kontenerów Linux, dostępna pamięć RAM (co najmniej 2 GB dla samego SQL Server; zalecany zapas) i PowerShell.

## Uruchomienie

W głównym katalogu repozytorium:

```powershell
Copy-Item .env.example .env
notepad .env
docker compose config
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail 60 sqlserver
```

**Zmień hasło w pliku .env przed uruchomieniem.** Nie używaj hasła przykładowego. Plik .env jest ignorowany przez Git.

## Konfiguracja

- Edycja: SQL Server 2022 Developer
- CU: **CU26**, oczekiwany build `16.0.4265.3`
- Obraz: `mcr.microsoft.com/mssql/server:2022-CU26-ubuntu-22.04`
- Host: `localhost`, port: `14333` (dostępny tylko lokalnie)
- Użytkownik: `sa`
- Hasło: własne, zapisane w `.env`
- Dane: trwały wolumen Dockera `orm_sql_data`

Healthcheck sprawdza otwarty port TCP wewnątrz kontenera. Status healthy **nie zastępuje** testu logowania i wykonania zapytania SQL.

## Połączenie

W SSMS podaj `localhost,14333`, uwierzytelnianie SQL Server, login `sa` i hasło z `.env`. W laboratorium z certyfikatem samopodpisanym zaznacz `Trust server certificate` (nie należy tego bezrefleksyjnie stosować produkcyjnie).

Sprawdź w edytorze zapytań:

```sql
SELECT
  SERVERPROPERTY('ProductVersion') AS ProductVersion,
  SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel,
  SERVERPROPERTY('Edition') AS Edition;
```

Oczekiwany ProductVersion: `16.0.4265.3`, ProductUpdateLevel: `CU26`.

## Obsługa

```powershell
docker compose stop
docker compose start
docker compose logs -f sqlserver
docker compose down
```

`docker compose down` usuwa kontener i sieć, **nie** usuwa trwałego wolumenu. **Nie używaj `docker compose down -v`, jeśli chcesz zachować dane.**

## Rozwiązywanie problemów

- Port 14333 zajęty: wyłącz inny serwer korzystający z portu albo zmień mapowanie hosta.
- Brak uruchomienia: sprawdź `docker compose logs sqlserver`, pamięć Dockera i wymagania dotyczące hasła.
- Brak uwierzytelnienia po zmianie hasła w `.env`: SQL Server przechowuje dane instancji w wolumenie; zmiana zmiennej środowiskowej nie resetuje hasła `sa` istniejącej instancji.
- Na maszynach ARM64 obraz SQL Server może nie działać natywnie; użyj kompatybilnego komputera x86-64 lub serwera uczelni.
