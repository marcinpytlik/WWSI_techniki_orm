# Lab 06 — Transakcje, rowversion i odporność na błędy

**Zjazd:** 17.01.2027  
**Czas:** 11:30–14:30 (180 min)  
**Procedura:** [instrukcja krok po kroku](step-by-step/lab-06.md). Polecenia są tylko tam.  
**Wymaga:** ukończonego Lab 05.

## Cel

Student zapisuje zamówienie z pozycjami w jednej jednostce pracy i pokazuje konflikt `rowversion` na dwa sposoby: dwa `DbContext` oraz nieaktualny token w PUT z Lab 05.

## Co już jest w repozytorium

Kolumna `RowVersion` powstaje w migracji z Lab 02. Na tym zjeździe nie dodajesz jej do modelu drugi raz.

## Rezultat

- Test atomowości: błąd pozycji nie zostawia osieroconego zamówienia.
- `DbUpdateConcurrencyException` z dwóch kontekstów.
- HTTP 409 ze starego `RowVersion`.
- Krótka tabela: RCSI, SNAPSHOT i `rowversion` opisane osobno.

## Pytanie kontrolne

Czy RCSI zastępuje `rowversion`?

## Zadanie samodzielne

Policz wiersze `shop.Orders` i `shop.OrderLines` przed wymuszonym błędem i po `ROLLBACK`. Oba liczniki mają wrócić do stanu początkowego.

## Kryteria zaliczenia

- Rollback jest pokazany liczbami, nie tylko opisem.
- Konflikt HTTP używa tokenu klienta, a nie tokenu świeżo wczytanego przez `FindAsync`.
