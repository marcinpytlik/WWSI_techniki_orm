# Lab 02 — Model EF Core i kontrolowana migracja

**Zjazd:** 08.11.2026  
**Czas:** 11:30–14:30 (180 min)  
**Procedura:** [instrukcja krok po kroku](step-by-step/lab-02.md). Polecenia są tylko tam.  
**Wymaga:** ukończonego Lab 01.

## Cel

Student generuje jedną migrację istniejącego modelu (Customer, Product, Order, OrderLine), przegląda `artifacts/OrmShop.Migrations.sql` i wykonuje go jako `orm_shop_deploy`.

## Co już jest w repozytorium

Klasy encji, Fluent API, schemat `shop` i `ShopDbContextFactory` są w starterze. Nie zakładaj modeli od zera i nie ograniczaj pierwszej migracji do Product i Customer.

## Rezultat

- Katalog `Migrations` z migracją `InitialShopSchema`.
- Przejrzany plik `artifacts/OrmShop.Migrations.sql` wykonany kontem deploy.
- Cztery tabele w schemacie `shop` i wiersz w `shop.__EFMigrationsHistory`.
- `GET http://localhost:5080/products` zwraca pustą listę na koncie `orm_shop_app`.

## Pytanie kontrolne

Czy konto migracyjne musi być db_owner? Dlaczego nie?

## Zadanie samodzielne

Wskaż w wygenerowanym SQL jedną operację, która utraciłaby dane, gdyby ktoś uruchomił ją na wypełnionej bazie bez przeglądu. Opisz, jak to poznajesz po samym skrypcie.

## Kryteria zaliczenia

- Historia migracji leży w schemacie `shop`, nie w `dbo`.
- Aplikacja nadal nie wywołuje `Database.Migrate()`.
- Próba `ALTER TABLE` kontem aplikacji kończy się odmową.
