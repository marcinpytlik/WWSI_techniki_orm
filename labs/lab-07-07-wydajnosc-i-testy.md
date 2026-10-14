# Lab 07 — N+1, Query Store, Dapper i testy integracyjne

**Zjazd:** 24.01.2027  
**Czas:** 11:30–14:30 (180 min)  
**Procedura:** [instrukcja krok po kroku](step-by-step/lab-07.md). Polecenia są tylko tam.  
**Wymaga:** ukończonego Lab 06.

## Cel

Student mierzy N+1 na danych większych niż jeden wiersz, porównuje projekcję EF z parametrowanym odczytem Dappera i dodaje test integracyjny na SQL Server.

## Rezultat

- Raport liczby poleceń oraz logical reads przed zmianą kształtu zapytania i po niej.
- Odczyt Dappera na koncie `orm_shop_app`.
- Projekt testowy xUnit wskazujący osobną bazę SQL Server. Provider InMemory nie zastępuje tego testu.
- Repozytorium bez sekretów, gotowe do oddania przed zjazdem 8.

## Pytanie kontrolne

Które dane pomiarowe dowodzą realnej poprawy wydajności?

## Zadanie samodzielne

Włącz Query Store kontem administratora laboratorium i wskaż w nim jedno zapytanie z pomiaru. Konto runtime nie wykonuje `ALTER DATABASE`.

## Kryteria zaliczenia

- Porównanie dotyczy tego samego pytania biznesowego, nie dwóch różnych raportów.
- Test integracyjny wykonuje CRUD, naruszenie FK albo konflikt `rowversion` na SQL Server 2022.
