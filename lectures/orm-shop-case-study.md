# ORM Shop — wspólne studium przypadku (wykłady 01–08)

## Kontekst
Sklep przyjmuje zamówienia klientów. System pokazuje katalog produktów, umożliwia zakup i udostępnia raporty sprzedaży. **To model dydaktyczny**, nie gotowy system produkcyjny.

## Model
```mermaid
erDiagram
  CUSTOMER ||--o{ ORDER : places
  ORDER ||--|{ ORDER_LINE : contains
  PRODUCT ||--o{ ORDER_LINE : appears_in
  CUSTOMER { int Id PK
    string Name
    string City }
  ORDER { int Id PK
    int CustomerId FK
    datetime CreatedAt
    decimal TotalAmount }
  ORDER_LINE { int OrderId PK,FK
    int ProductId PK,FK
    int Quantity
    decimal UnitPrice }
  PRODUCT { int Id PK
    string Sku
    string Name
    decimal Price
    binary RowVersion }
```

## Architektura
```mermaid
flowchart TB
 A[ASP.NET Core API] --> B[Application Services]
 B --> C[EF Core 10 DbContext]
 B --> D[Dapper - raporty SQL]
 C --> E[(SQL Server 2022 CU26)]
 D --> E
```

## Ślad studium przypadku
| Wykład | Rozwijany problem |
|---|---|
| 01 | Trzy sposoby uzyskania listy klientów: ADO.NET, Dapper, EF Core |
| 02 | Model, DbContext, mapowanie, migracja Price decimal(18,2), SKU UNIQUE |
| 03 | Customer–Order–OrderLine–Product i konsekwencje FK |
| 04 | Lista 100 klientów z zamówieniami, paginacja i generowany SQL |
| 05 | Zmiana ceny produktu: tracking vs aktualizacja odłączonego DTO |
| 06 | Dwóch użytkowników zmienia cenę; rowversion i transakcja zamówienia |
| 07 | Raport zamówień: N+1, projekcja, indeksy, pomiary IO i planu |
| 08 | Dobór EF Core/Dapper, test na SQL Server, strategia deploy |

## Reguły pracy
- Za każdym razem pokazuj kod C#, przewidywany kształt SQL oraz sposób **sprawdzenia rzeczywistego SQL**.
- Nie nazywaj przykładowego SQL dosłownym wynikiem providera, dopóki nie został uruchomiony na referencyjnej wersji EF Core.
- W testach integracyjnych używaj referencyjnego SQL Server zamiast zakładać zgodność z providerem InMemory.
- Dane testowe są syntetyczne. Żadnych prawdziwych danych klientów.
