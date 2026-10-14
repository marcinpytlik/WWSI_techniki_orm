# Laboratoria ORM Shop — kurs z kontrolowanymi uprawnieniami

**Technologie:** .NET 10, EF Core 10, SQL Server 2022 CU26.  
**Projekt:** jedna aplikacja rozwijana od zjazdu 1 do 8.

## Laboratoria

| Lab | Data | Temat | Materiał |
|---|---|---|---|
| 01 | 25.10.2026 | Środowisko i bezpieczeństwo | [Lab 01](lab-01-01-srodowisko-i-bezpieczenstwo.md) |
| 02 | 08.11.2026 | Model i migracje | [Lab 02](lab-02-02-encje-i-migracje.md) |
| 03 | 22.11.2026 | Relacje i FK | [Lab 03](lab-03-03-relacje-i-integralnosc.md) |
| 04 | 06.12.2026 | LINQ i T-SQL | [Lab 04](lab-04-04-linq-i-generowany-sql.md) |
| 05 | 20.12.2026 | CRUD i tracking | [Lab 05](lab-05-05-crud-i-change-tracker.md) |
| 06 | 17.01.2027 | Transakcje, rowversion | [Lab 06](lab-06-06-transakcje-i-wspolbieznosc.md) |
| 07 | 24.01.2027 | Wydajność, Dapper i testy | [Lab 07](lab-07-07-wydajnosc-i-testy.md) |
| 08 | nieustalona | Finał aplikacji | [Lab 08](lab-08-08-final-orm-shop.md) |

## Materiały wspólne

- [Model bezpieczeństwa i proces wdrożenia](architecture-and-security.md)
- [Skrypty SQL: bootstrap, loginy i weryfikacja](security/)
- [Szkielet API .NET](../src/README.md)
- [Automatyzacja generowania migracji](scripts/prepare-first-migration.ps1)
- [Instrukcja środowiska](../docs/przygotowanie-srodowiska.md)
- [Docker Compose SQL Server](../docs/docker-sql-server.md)

## Dwie granice bezpieczeństwa

**1. Runtime:** `orm_shop_app` — tylko odczyt/zapis danych schematu shop. Bez db_owner i bez DDL.

**2. Deployment:** `orm_shop_deploy` — odrębna tożsamość dla zatwierdzonego skryptu migracji. Nie trafia do API.

Administrator instancji `sa` działa wyłącznie podczas lokalnego bootstrapu.

## Proces ćwiczeń

Każde zajęcia kończą się testami pozytywnymi i negatywnymi, zmianą kodu oraz opisem wygenerowanego SQL. Projekt zaliczeniowy jest kumulacyjny: Lab 08 **nie dodaje nowej funkcjonalności**, tylko prezentację i odbiór.

## Stan implementacji

Utworzono osiem instrukcji etapowych, skrypty SQL do kont i uprawnień, model bezpieczeństwa oraz działający strukturalnie starter C#/EF. **Pełna implementacja endpointów CRUD, Dappera, testów i automatyczny test end-to-end nie są jeszcze dostarczone.** To istotne przed przekazaniem materiałów studentom.

Rozliczenie wymiaru godzin nadal wymaga wyjaśnienia z uczelnią.
