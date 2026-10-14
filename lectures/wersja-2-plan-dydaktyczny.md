# Rozszerzenie wykładów ORM — wersja 2.0

## Cel
Przejście od opisu funkcji EF Core do uczenia decyzji architektonicznych i rozumienia SQL Server.

## Stały schemat dydaktyczny
1. Problem z ORM Shop.
2. Mechanizm i mapa relacyjna / diagram przepływu.
3. Fragment C# oraz przewidywany SQL (oznaczony jako schemat).
4. Jak zweryfikować zachowanie SQL Server.
5. Dwie krótkie kontrole zrozumienia i decyzja architektoniczna.

## Zakres
| Nr | Rozszerzenie | Pytania kluczowe |
|---|---|---|
| 01 | Oś historii i Data Mapper vs Active Record | Dlaczego nie wszystkie biblioteki dostępu do danych są ORM? |
| 02 | Owned/complex types, value converter, shadow properties, TPH/TPT/TPC, migracje bez utraty danych | Czy każdą zmianę C# można bezpiecznie migrować? |
| 03 | ERD, encja OrderLine, DeleteBehavior, indeksy FK | Jak model zabezpiecza integralność? |
| 04 | Expression Tree, ToQueryString, parametryzacja, SQL raw, paginacja | Kiedy LINQ jest wykonywany i jak wygląda T-SQL? |
| 05 | Identity Map, DetectChanges, detached graph, ExecuteUpdate | Skąd EF Core zna zmienione kolumny? |
| 06 | RCSI, SNAPSHOT, rowversion, deadlock, retry, outbox | Jak chronić spójność przy wielu użytkownikach? |
| 07 | N+1, cartesian explosion, Query Store, actual plan, parametry | Co jest wąskim gardłem: SQL, sieć, tracking czy mapowanie? |
| 08 | CQRS, Repository, Testcontainers, CI/CD, obserwowalność | Jak zbudować testowalną i operacyjnie bezpieczną warstwę danych? |

## Limity czasu
Zjazdy 1–7: 45 minut wykładu; ósmy: 100 minut wg znanego planu. Przedziały nie sumują się do przydziału 18 godzin dydaktycznych wykładu. Slajdy uzupełniające i ćwiczenia są materiałem opcjonalnym; nie trzeba pokazywać wszystkiego podczas pojedynczego slotu.

## Kryteria recenzji
- Sformułowania historyczne i techniczne nie mogą sugerować fałszywej chronologii lub gwarantowanej wydajności.
- Każdy fragment kodu opisany jako skrót lub kompletny przykład.
- SQL emitowany przez EF Core weryfikowany przed pokazem na żywo.
- Rozdzielone: prezentacja / notatki / kod demonstracyjny / instrukcja laboratorium.
