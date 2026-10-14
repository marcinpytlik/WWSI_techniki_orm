# Program przedmiotu — wersja robocza

## Cel
Student tworzy aplikacje wykorzystujące ORM i świadomie ocenia konsekwencje odwzorowania obiektowo-relacyjnego dla SQL Server.

## Efekty uczenia się
Po zakończeniu zajęć student potrafi:
1. Wyjaśnić problem niedopasowania obiektowo-relacyjnego i rolę ORM.
2. Skonfigurować DbContext i odwzorować encje oraz relacje.
3. Tworzyć i stosować migracje schematu.
4. Pisać zapytania LINQ i interpretować generowany T-SQL.
5. Rozpoznawać problemy N+1, nadmiernego pobierania danych i kosztów śledzenia zmian.
6. Stosować transakcje i kontrolę współbieżności.
7. Diagnozować proste problemy wydajności za pomocą logowania SQL i planów zapytań.

## Spotkania — roboczy rozkład tematów

| Nr | Wykład | Laboratorium |
|---|---|---|
| 1 | ORM i EF Core: model, architektura, ograniczenia | Środowisko, pierwsza aplikacja i baza SQL Server |
| 2 | Mapowanie i migracje | Encje, DbContext, migracje Code First |
| 3 | Relacje i Fluent API | Relacje 1:N i N:M, klucze, ograniczenia |
| 4 | LINQ i wykonanie zapytań | Filtrowanie, sortowanie, projekcja, Include i SQL |
| 5 | Change Tracking | CRUD, stany encji i SaveChanges |
| 6 | Transakcje i współbieżność | Transakcje, optimistic concurrency, konflikty |
| 7 | Optymalizacja ORM | N+1, no-tracking, indeksy, plany wykonania |
| 8 | Architektura i testowanie | Przegląd i obrona projektu, podsumowanie |

## Zaliczenie — propozycja
Projekt indywidualny lub w parach: aplikacja CRUD z EF Core, bazą SQL Server, relacjami, migracjami i analizą minimum dwóch wygenerowanych zapytań SQL. Kryteria i punktacja do uzgodnienia z prowadzącym.

## Organizacja
18 h wykładów i 27 h laboratoriów według przydziału. Terminy i godziny: README repozytorium. Nierozliczoną różnicę między wymiarem dydaktycznym i godzinami zegarowymi należy wyjaśnić przed zatwierdzeniem sylabusa.
