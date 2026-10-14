# Lab 04 — LINQ, projekcje i diagnostyka T-SQL

**Zjazd:** 06.12.2026  
**Czas:** 11:30–14:30 (180 min)  
**Procedura:** [instrukcja krok po kroku](step-by-step/lab-04.md). Polecenia są tylko tam.  
**Wymaga:** ukończonego Lab 03.

## Cel

Student porównuje kształt LINQ z rzeczywistym T-SQL: log Development na http://localhost:5080 oraz `ToQueryString()` wywołane na zapytaniu po `Select`.

## Rezultat

Co najmniej trzy pary: fragment LINQ, wygenerowany T-SQL i obserwacja liczby round-tripów. W zestawie ma być filtr miasta, projekcja z liczbą zamówień oraz `Include` z `Take`.

## Pytanie kontrolne

Dlaczego podzapytanie w `FROM` może być potrzebne przy `Include` i `Take`?

## Zadanie samodzielne

Uruchom w SSMS SQL z `ToQueryString()` i zapisz logical reads dla projekcji oraz dla `Include`. Nie porównuj czasu samego pustego `SELECT`.

## Kryteria zaliczenia

- Endpoint `/customers` z parametrem `city` zastępuje poprzedni, a nie dubluje trasy.
- W notatkach nie ma wartości parametrów z `EnableSensitiveDataLogging`.
