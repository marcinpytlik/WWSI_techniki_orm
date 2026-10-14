# Projekt zaliczeniowy

## Temat

System obsługi zamówień (klienci, produkty, zamówienia, pozycje zamówień) w C#, EF Core i SQL Server. Pracujesz na starterze ORM Shop z tego repozytorium albo na własnym forku o tym samym modelu uprawnień.

## Minimalny zakres

- Co najmniej cztery encje i relacje 1:N.
- Konfiguracja DbContext; część mapowania przez Fluent API.
- Migracje inicjalne i co najmniej jedna migracja zmieniająca schemat, wdrażane kontem deploy po przeglądzie SQL. Proces API nie wywołuje `Database.Migrate()`.
- CRUD z walidacją wejścia i obsługą błędów 400, 404 i 409.
- Zapytania LINQ: filtrowanie, sortowanie, agregacja i projekcja.
- Analiza co najmniej dwóch zapytań wygenerowanych przez EF Core (SQL i wpływ na wydajność).
- Instrukcja uruchomienia.

## Rozszerzenia wliczone w punktację

- Optimistic concurrency: `rowversion` wraca do klienta i wraca w żądaniu aktualizacji.
- Transakcja obejmująca zamówienie i pozycje, z pokazanym rollbackiem.
- Demonstracja problemu N+1 i jego eliminacji, z pomiarem liczby poleceń albo logical reads.
- Test integracyjny na SQL Server, nie na providerze InMemory.

## Punktacja

| Kryterium | Punkty |
|---|---|
| Model, relacje i Fluent API zgodne ze schematem `shop` | 15 |
| Migracje przeglądane i wdrażane kontem deploy, bez migracji przy starcie API | 15 |
| CRUD, walidacja oraz kody 400, 404 i 409 | 15 |
| LINQ oraz dwa udokumentowane zapytania T-SQL | 15 |
| Transakcja zamówienia i `rowversion` z tokenem klienta | 15 |
| Pomiar N+1 i porównanie z projekcją albo Dapperem | 10 |
| Test integracyjny na SQL Server | 10 |
| Instrukcja uruchomienia i brak sekretów w oddanym repozytorium | 5 |
| **Razem** | **100** |

Zaliczenie projektu: co najmniej **60 punktów** oraz pokaz z Lab 08. Brak działającego połączenia kontem `orm_shop_app` obniża ocenę niezależnie od sumy punktów za opis.

## Oddanie

Praca indywidualna albo w parze. Para broni projekt razem, a obie osoby muszą umieć pokazać SQL, konflikt 409 i odmowę DDL.

Dzień przed zjazdem 8 prześlij prowadzącemu adres repozytorium Git albo archiwum zip. W oddaniu nie może być `.env`, `secrets.json`, haseł ani connection stringu z prawdziwym hasłem. Katalog `artifacts/` z lokalnym skryptem migracji dołącz tylko wtedy, gdy skrypt nie zawiera sekretów.

Data zjazdu 8 jest pusta do potwierdzenia przez dziekanat. Termin oddania przesuwa się razem z tą datą i zawsze wypada dzień wcześniej.
