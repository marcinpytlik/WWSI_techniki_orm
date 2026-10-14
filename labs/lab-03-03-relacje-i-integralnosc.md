# Lab 03 — Orders, OrderLines, FK i reguły usuwania

**Zjazd:** 22.11.2026  
**Czas:** 11:30–14:30 (180 min)  
**Procedura:** [instrukcja krok po kroku](step-by-step/lab-03.md). Polecenia są tylko tam.  
**Wymaga:** ukończonego Lab 02.

## Cel

Student czyta relacje już obecne w `ShopDbContext`, sprawdza je w `sys.foreign_keys` i pokazuje, że usunięcie klienta z zamówieniem jest odrzucone przez SQL Server.

## Co już jest w repozytorium

`Order`, `OrderLine`, klucz złożony i `DeleteBehavior` są w starterze od pierwszej migracji. Ten zjazd ich nie dopisuje. Nowa migracja pojawia się tylko wtedy, gdy inspekcja `sys.indexes` wykaże brak indeksu, którego zapytanie naprawdę potrzebuje.

## Rezultat

- Diagram trzech relacji zgodny z modelem.
- Wynik inspekcji FK i test negatywny usunięcia klienta.
- Decyzja o indeksie poparta `sys.indexes`, bez duplikatu indeksu na `Orders.CustomerId`.

## Pytanie kontrolne

Czy nawigacja `Orders` automatycznie odczytuje całą kolekcję?

## Zadanie samodzielne

Wyjaśnij, czemu usunięcie zamówienia kasuje pozycje, a usunięcie produktu użytego na pozycji jest zabronione.

## Kryteria zaliczenia

- Test negatywny FK jest wykonany kontem `orm_shop_app` i kończy się `ROLLBACK`.
- Ewentualna migracja indeksu przechodzi przez przegląd SQL i konto deploy.
