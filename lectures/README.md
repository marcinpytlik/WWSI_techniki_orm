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

Opracowano szkice wykładów obejmujące tok, cele, zagadnienia i przykłady do omówienia. **Nie są to jeszcze finalne prezentacje ani pełne scenariusze minuta po minucie.**

### Uwaga dotycząca godzin

Przydział przedmiotu: 18 h wykładów i 27 h laboratoriów. W znanym planie siedem spotkań ma 45 minut wykładu, ósme 100 minut. To 415 minut zegarowych, czyli około 9,22 godziny dydaktycznej po 45 minut. Nie jest to zgodne z przydziałem 18 godzin wykładów — rozbieżność wymaga formalnego wyjaśnienia; nie deklarujemy, że osiem znanych slotów pokrywa 18 h.

## Zasady prowadzenia

- Teoria powinna pokazywać zarówno stronę obiektową, jak i konsekwencje relacyjne.
- Każde niebanalne zapytanie LINQ omawiamy w kontekście wygenerowanego SQL.
- Przykłady w plikach są fragmentami dydaktycznymi, a nie kompletnymi samodzielnie kompilowalnymi aplikacjami.
- Laboratoria opracujemy po zaakceptowaniu zakresu wykładów.

## Prezentacje

- [Wykład 01 — Skąd wziął się ORM? (17 slajdów Marp)](slides/01-historia-orm.marp.md)
- [Jak wyświetlić i wyeksportować prezentację](slides/README.md)

## Komplet slajdów wykładowych

Wszystkie prezentacje wykładów 01–08 znajdują się w [katalogu slides](slides/README.md). Łącznie 108 slajdów, w tym notatki prowadzącego. Wersja robocza do przeglądu merytorycznego.
