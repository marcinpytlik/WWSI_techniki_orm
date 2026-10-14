# Lab 03 — instrukcja wykonania krok po kroku


> Środowisko: PowerShell 7/5.1, .NET 10, SQL Server 2022 CU26 na 127.0.0.1,14333. Polecenia wykonuj z katalogu repozytorium, chyba że wskazano inaczej. **Nigdy nie uruchamiaj migracji na koncie aplikacji.**

**Temat:** Relacje, klucze obce i spójność

## Cel
Student sprawdza klucze obce i reguły usuwania oraz odróżnia indeks założony przez konwencję EF od indeksu, który naprawdę trzeba dodać.

## Krok 1. Narysuj model

W diagramie zaznacz: Customer 1:N Order; Order 1:N OrderLine; Product 1:N OrderLine. OrderLine ma klucz złożony `(OrderId,ProductId)`. Zastanów się, czy domena dopuszcza ten sam produkt wielokrotnie w jednym zamówieniu.

## Krok 2. Znajdź mapowanie

W `src/OrmShop.Api/Data/ShopDbContext.cs` znajdź `ApplyConfigurationsFromAssembly()`, a następnie w `src/OrmShop.Api/Data/Configurations/OrderConfiguration.cs` i `OrderLineConfiguration.cs` wskaż `HasOne/WithMany/HasForeignKey`, `OnDelete(DeleteBehavior.NoAction)` dla Customer i Product oraz `Cascade` dla OrderLine po Order. Wyjaśnij, dlaczego historii nie kasujemy automatycznie razem z Customer.

## Krok 3. Weryfikacja FK w SQL

W SSMS po migracji:
~~~sql
USE OrmShop;
SELECT fk.name, OBJECT_SCHEMA_NAME(fk.parent_object_id) AS S,
       OBJECT_NAME(fk.parent_object_id) AS ChildTable,
       OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
       fk.delete_referential_action_desc
FROM sys.foreign_keys AS fk
WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id)=N'shop';
~~~
Wynik: trzy odpowiednie relacje.

## Krok 4. Wprowadź kontrolowane dane testowe

Jako `orm_shop_app`:
~~~sql
INSERT shop.Customers (Name,City) VALUES (N'Anna Test',N'Warszawa');
INSERT shop.Products (Sku,Name,Price) VALUES (N'LAB03-01',N'Klawiatura',120.00);
~~~
Sprawdź wygenerowane Id. **Nie zakładaj wartości IDENTITY=1**: użyj `OUTPUT INSERTED.Id` albo odczytaj dokładne Id przed tworzeniem zamówienia.

## Krok 5. Sprawdź ograniczenia na transakcji

Utwórz Order i OrderLine używając rzeczywistych identyfikatorów, a potem wykonaj w transakcji próbę usunięcia Customer, do którego należy Order. Oczekiwany błąd FK. Zrób `ROLLBACK` i potwierdź, że dane pozostają. Nie dezaktywuj ograniczeń.

## Krok 6. Praca samodzielna

Odczytaj indeksy z `sys.indexes` dla tabel `shop`. Konwencja EF Core zakłada indeks na kluczu obcym, więc `Orders.CustomerId` najpewniej już go ma. Nie dodawaj drugiego indeksu na tę samą kolumnę. Jeśli filtr z Lab 04 (`Customers.City`) nie ma indeksu, zaprojektuj właśnie ten: nowa migracja, skrypt do przeglądu, wdrożenie kontem deploy.

## Oddanie etapu

Dostarcz diagram, wynik inspekcji FK, ślad testu negatywnego i ewentualną migrację indeksu.

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
