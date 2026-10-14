# Lab 05 — CRUD, Unit of Work i aktualizacje kontrolowane

**Zjazd:** 20.12.2026  
**Czas:** 11:30–14:30 (180 min)  
**Procedura:** [instrukcja krok po kroku](step-by-step/lab-05.md). Polecenia są tylko tam.  
**Wymaga:** ukończonego Lab 04.

## Cel

Student dopisuje `POST /products` i `PUT /products/{id}`. PUT przyjmuje `RowVersion` z wcześniejszego GET i zwraca 409, gdy token jest nieaktualny.

## Rezultat

- DTO zamiast encji w kontrakcie HTTP.
- Kody 400, 404 i 409 bez connection stringu w odpowiedzi.
- Zapis stanu `Added` / `Modified` / `Unchanged` oraz odpowiadający SQL.

## Pytanie kontrolne

Dlaczego `SaveChanges` nie wymaga uprawnień DDL?

## Zadanie samodzielne

Pokaż różnicę SQL między PUT, który podstawia `OriginalValue` tokenem klienta, a PUT, który po `FindAsync` tylko zmienia cenę.

## Kryteria zaliczenia

- API nadal łączy się jako `orm_shop_app`.
- Powtórzony PUT ze starym `RowVersion` kończy się 409.
- Duplikat SKU jest obsłużony jako konflikt, nie jako nieobsłużony 500.
