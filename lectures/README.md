# Wykłady — Narzędzia i techniki ORM

Materiały prowadzącego na 8 niedzielnych spotkań. Technologia bazowa: **C#, EF Core 10 i SQL Server 2022 CU26**.

| Nr | Data | Materiał |
|---|---|---|
| 01 | 25.10.2026 | [Wprowadzenie do ORM i architektury EF Core](01-wprowadzenie-do-orm.md) |
| 02 | 08.11.2026 | [Encje, DbContext, mapowanie i migracje](02-model-encji-i-migracje.md) |
| 03 | 22.11.2026 | [Relacje i integralność danych](03-relacje-i-integralnosc.md) |
| 04 | 06.12.2026 | [LINQ i translacja do SQL](04-linq-i-translacja.md) |
| 05 | 20.12.2026 | [Change Tracker i CRUD](05-sledzenie-zmian-i-crud.md) |
| 06 | 17.01.2027 | [Transakcje i współbieżność](06-transakcje-i-wspolbieznosc.md) |
| 07 | 24.01.2027 | [Wydajność EF Core](07-wydajnosc-ef-core.md) |
| 08 | do ustalenia | [Architektura i testowanie](08-architektura-i-podsumowanie.md) |

## Status przygotowania

Scenariusze wykładów 01–08 i prezentacje Marp są materiałem do prowadzenia. Laboratoria są w `labs/`, kompilowalny model ORM Shop jest w `src/OrmShop.Api`. Przykłady w scenariuszach pozostają fragmentami do omówienia.

### Uwaga dotycząca godzin

Przydział przedmiotu to 18 h wykładów i 27 h laboratoriów. Znane sloty dają 415 minut wykładu, czyli 9,22 godziny dydaktycznej, oraz 1305 minut laboratorium, czyli 29 godzin dydaktycznych. Pełne rozliczenie jest w [README repozytorium](../README.md). Osiem znanych slotów nie pokrywa 18 godzin wykładu.

## Zasady prowadzenia

- Teoria powinna pokazywać zarówno stronę obiektową, jak i konsekwencje relacyjne.
- Każde niebanalne zapytanie LINQ omawiamy w kontekście wygenerowanego SQL.
- Przykłady w plikach są fragmentami dydaktycznymi. Działający model jest w starterze API.
- Przykład z wykładu ma używać pól, które są w `Models.cs`. Suma pozycji zamówienia jest liczona z `OrderLine`, a nie ze składowanej kwoty.

## Prezentacje

- [Wykład 01 — Skąd wziął się ORM? (17 slajdów Marp)](slides/01-historia-orm.marp.md)
- [Jak wyświetlić i wyeksportować prezentację](slides/README.md)

## Komplet slajdów wykładowych

Wszystkie prezentacje wykładów 01–08 znajdują się w [katalogu slides](slides/README.md). Łącznie 108 slajdów, w tym notatki prowadzącego. Przykłady na slajdach trzymaj zgodne z `src/OrmShop.Api`.

## Wersja 2.0 — rozszerzenie dydaktyczne

- [Wspólny przykład ORM Shop z diagramami](orm-shop-case-study.md)
- [Notatki prowadzącego, pytania i studia przypadków](notatki-prowadzacego-v2.md)
- [Plan uzupełnień i zasady doboru materiałów](wersja-2-plan-dydaktyczny.md)
- [Zaktualizowane prezentacje](slides/README.md)

Slajdy rozszerzające są opcjonalne; prezentacje nie stanowią samodzielnie uruchamialnego laboratorium.
