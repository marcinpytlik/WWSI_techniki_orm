# Wykład 01 — Skąd wziął się ORM i jak działa?

**Przedmiot:** Narzędzia i techniki ORM · **Data:** 25.10.2026 · **Wykład:** 10:35–11:20 (45 minut)  
**Środowisko demonstracyjne kursu:** C# / .NET 10, EF Core 10, SQL Server 2022 CU26.

> **Myśl przewodnia:** ORM nie jest alternatywą dla modelu relacyjnego. Jest sposobem na połączenie modelu obiektowego z relacyjnym i przenosi część odpowiedzialności za kod dostępu do danych na bibliotekę — lecz nie usuwa kosztów zapytań SQL.

## Efekty kształcenia

Po wykładzie student:
1. Wyjaśnia historyczne przyczyny powstania ORM.
2. Rozpoznaje niedopasowanie obiektowo-relacyjne (object–relational impedance mismatch).
3. Odróżnia ADO.NET, micro-ORM i pełny ORM.
4. Rozpoznaje podstawowe wzorce Active Record, Data Mapper, Unit of Work i Identity Map.
5. Porównuje EF Core z Hibernate, NHibernate, Dapper, SQLAlchemy i Active Record.
6. Opisuje, jakie operacje wykonuje ORM oraz dlaczego analiza generowanego SQL pozostaje niezbędna.

## Scenariusz wykładu (45 minut)

| Czas | Blok | Kluczowe przesłanie |
|---|---|---|
| 0–4 min | Pytanie otwierające i problem | Co trzeba zrobić, aby przenieść wynik SELECT do obiektu? |
| 4–13 min | Historia dostępu do danych | ORM wyrósł z powtarzalnego kodu mapowania |
| 13–22 min | Niedopasowanie modeli i wzorce | Obiekt i tabela nie są tym samym |
| 22–33 min | Krajobraz technologii | EF Core to jedno z wielu rozwiązań |
| 33–41 min | Porównanie ADO.NET / Dapper / EF Core | Mniej kodu ≠ darmowe wykonanie |
| 41–45 min | Dyskusja i podsumowanie | Dobieraj narzędzie do problemu |

---

## 1. Otwarcie: prosty problem, dużo kodu

Wyobraźmy sobie tabelę SQL Server:

```sql
CREATE TABLE dbo.Customers
(
    CustomerId int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    City nvarchar(100) NULL
);
```

Chcemy uzyskać listę klientów z Warszawy. SQL jest krótki:

```sql
SELECT CustomerId, Name, City
FROM dbo.Customers
WHERE City = N'Warszawa';
```

W aplikacji obiektowej trzeba jednak: otworzyć połączenie, wykonać zapytanie, odebrać wynik, sprawdzić wartości NULL, skonwertować typy, utworzyć obiekty, obsłużyć błędy i zwolnić zasoby. A potem powtarzać podobne operacje dla produktów, zamówień i faktur.

**Pytanie do sali:** czy to wszystko jest logiką biznesową? Nie — znaczna część to infrastruktura mapowania.

## 2. Rys historyczny: jak dochodziliśmy do ORM?

Nie jest to historia „od starego i złego SQL do nowego i dobrego ORM”. Wszystkie poniższe podejścia nadal mają zastosowanie.

### Lata 70. i 80. — relacyjne bazy i SQL

Rozwój relacyjnego modelu danych oraz SQL wprowadził deklaratywne przetwarzanie zbiorów. Aplikacje odwoływały się do danych za pomocą poleceń SQL, interfejsów dostępu i mechanizmów językowych. Bazy przechowywały relacje, a aplikacje zarządzały logiką biznesową.

### Lata 90. — aplikacje obiektowe i coraz więcej warstwy dostępu do danych

Popularność C++, Javy i programowania obiektowego zwiększyła rozdźwięk między klasami a tabelami. Programiści pisali ręczne mapowanie i warstwy DAO / gateway, a narzędzia dostępowe (np. ODBC, JDBC, później ADO.NET) odpowiadały za połączenia, polecenia i odczyt wyników. **ADO.NET nie jest ORM** — daje niższopoziomowy dostęp do źródeł danych.

### Koniec lat 90. i lata 2000 — automatyzacja mapowania

Frameworki takie jak TopLink, Hibernate czy później NHibernate zaczęły automatyzować mapowanie encji, relacji i stanu obiektów. W ekosystemach pojawiły się również rozwiązania oparte na Active Record. W 2002 roku Martin Fowler opisał i uporządkował wzorce architektury aplikacji biznesowych, w tym Data Mapper, Active Record i Unit of Work. **Nie oznacza to, że dopiero wtedy wynaleziono ORM**.

### Od późnych lat 2000 — narzędzia dla .NET i alternatywa micro-ORM

Entity Framework pojawił się w ekosystemie .NET jako rozbudowany ORM. Jednocześnie utrzymało się zapotrzebowanie na prostsze podejścia: ręczne SQL, biblioteki mapujące wiersze na obiekty i micro-ORM, np. Dapper. W 2016 pojawił się EF Core, rozwijany osobno od klasycznego Entity Framework.

### Dziś — wiele rozwiązań, nie jeden zwycięzca

Aplikacja może korzystać z EF Core do zapisu modelu domenowego, a z Dappera albo ADO.NET do precyzyjnie kontrolowanych odczytów. Istotne są rzeczywiste wymagania, a nie sama moda technologiczna.

**Notatka prowadzącego:** nie przedstawiaj dat jako jednej prostej sekwencji „zamiany” technologii. JDBC/ADO.NET, ORM i micro-ORM współistnieją.

## 3. Dlaczego obiekty i relacje do siebie nie pasują?

| Świat obiektowy | Świat relacyjny | Problem |
|---|---|---|
| Obiekt z tożsamością i zachowaniem | Wiersz identyfikowany kluczem | Identyczność obiektu vs klucz rekordu |
| Referencje i kolekcje | FK i tabele powiązań | Mapowanie relacji 1:N oraz N:M |
| Dziedziczenie | Tabele, kolumny, ograniczenia | TPH, TPT, TPC i koszt odpytywania |
| `null` i nullable types | SQL NULL i logika trójwartościowa | Odmienna semantyka warunków |
| Nawigowanie po grafie obiektów | JOIN / osobne SELECT | N+1 oraz wielkość pobieranych danych |
| Jedna operacja na obiekcie | Transakcja i DML w bazie | Granice spójności i współbieżności |

To zjawisko nazywamy **object–relational impedance mismatch**. ORM nie usuwa tych różnic — oferuje reguły odwzorowania i mechanizmy radzenia sobie z nimi.

### Przykład konceptualny

```text
C#                         SQL Server
Customer                    dbo.Customers
  Id ---------------------> CustomerId (PK)
  Name -------------------> Name
  Orders: List<Order>       dbo.Orders.CustomerId (FK)
       |                       |
       +------ relacja --------+
```

Obiekt `Customer` może zawierać kolekcję `Orders`, ale w SQL Server nie ma kolumny przechowującej „listę zamówień” — relację odwzorowuje klucz obcy.

## 4. Wzorce, które warto poznać przed frameworkiem

**Table Data Gateway / Row Data Gateway:** obiekty pośredniczą w odczycie i zapisie tabel lub pojedynczych rekordów; nadal często widzimy jawny SQL.

**Active Record:** obiekt reprezentuje wiersz i ma również operacje zapisu/odczytu; podejście częste w frameworkach webowych. Dobre przy prostym modelu, ale mocniej łączy model z persystencją.

**Data Mapper:** oddzielna warstwa tłumaczy między obiektami a bazą; model domenowy nie musi znać mechanizmów zapisu.

**Identity Map:** w obrębie danego kontekstu pracy dana tożsamość bazy może odpowiadać jednej śledzonej instancji obiektu.

**Unit of Work:** zbiera zmiany w jednostce pracy i koordynuje ich zapis. `DbContext` w EF Core realizuje mechanizmy zbliżone do Data Mapper i Unit of Work, a change tracker utrzymuje m.in. tożsamość śledzonych encji.

**Pytanie:** kiedy model danych jest prostą tabelą CRUD, a kiedy zaczyna mieć rozbudowane reguły domenowe? To wpływa na wybór wzorca.

## 5. Rodziny rozwiązań — nie tylko Entity Framework

| Rozwiązanie | Ekosystem | Styl | Kiedy warto rozważyć |
|---|---|---|---|
| **ADO.NET** | .NET | Bezpośrednie polecenia, reader, parametry | Pełna kontrola i świadomy SQL |
| **Dapper** | .NET | Micro-ORM, SQL pisany ręcznie + mapowanie | Złożone odczyty, kontrola zapytań |
| **EF Core** | .NET | Pełny ORM, LINQ, tracking, migracje | Bogatszy model i szybki rozwój aplikacji |
| **NHibernate** | .NET | Pełny ORM, dojrzałe mapowanie i sesje | Projekty korzystające z jego rozbudowanych mechanizmów |
| **Hibernate ORM** | Java | ORM oparty na JPA/Jakarta Persistence | Aplikacje Java i model domenowy |
| **jOOQ** | Java | Type-safe SQL DSL; nie klasyczny ORM | Gdy SQL jest główną abstrakcją |
| **SQLAlchemy** | Python | Toolkit SQL i ORM | Elastyczna kontrola zapytań i modelu |
| **Django ORM** | Python | ORM zintegrowany z Django | Aplikacje webowe Django |
| **Active Record (Rails)** | Ruby | Active Record | Produktywne aplikacje Rails |
| **Prisma** | TypeScript/JavaScript | Schemat, klient typowany, migracje | Aplikacje Node.js/TypeScript |

**Ważne rozróżnienie:** biblioteki typu jOOQ i Dapper nie oferują dokładnie tych samych mechanizmów co EF Core. Wszystko to są technologie dostępu do danych, ale nie wszystkie są „pełnymi ORM”.

### Nie ma jednego uniwersalnego rankingu

- **Pełny ORM** oferuje więcej automatyzacji, lecz może wprowadzać narzut i ukrywać koszty zapytań.
- **Micro-ORM** pozostawia SQL programiście i ogranicza kod mapowania, ale wymaga ręcznej obsługi wielu aspektów modelu i zapisu.
- **ADO.NET / JDBC** są elastyczne, ale duża część logiki obsługi danych pozostaje w kodzie aplikacji.
- **SQL-first / DSL** zachowują składnię i możliwości SQL jako centralny element projektu.

## 6. Jedno zadanie na trzy sposoby w .NET

Model wyniku:

```csharp
public sealed class CustomerDto
{
    public int CustomerId { get; set; }
    public string Name { get; set; } = "";
}
```

### A. ADO.NET — jawne mapowanie

```csharp
using Microsoft.Data.SqlClient;

var customers = new List<CustomerDto>();

await using var connection = new SqlConnection(connectionString);
await connection.OpenAsync();

await using var command = new SqlCommand(
    "SELECT CustomerId, Name FROM dbo.Customers WHERE City = @city",
    connection);
command.Parameters.AddWithValue("@city", "Warszawa");

await using var reader = await command.ExecuteReaderAsync();
while (await reader.ReadAsync())
{
    customers.Add(new CustomerDto
    {
        CustomerId = reader.GetInt32(0),
        Name = reader.GetString(1)
    });
}
```

**Prowadzący:** SQL jest jawny, mapowanie ręczne, a parametry chronią przed wstrzyknięciem danych jako fragmentów SQL. W kodzie produkcyjnym preferuj jawne typy i długości parametrów zamiast bezrefleksyjnego `AddWithValue`.

### B. Dapper — SQL pozostaje jawny, mapowanie uproszczone

```csharp
using Dapper;
using Microsoft.Data.SqlClient;

await using var connection = new SqlConnection(connectionString);
var customers = (await connection.QueryAsync<CustomerDto>(
    "SELECT CustomerId, Name FROM dbo.Customers WHERE City = @City",
    new { City = "Warszawa" })).ToList();
```

**Prowadzący:** brak ręcznej pętli readera; autor nadal decyduje o treści SQL.

### C. EF Core — zapytanie LINQ

```csharp
var customers = await db.Customers
    .AsNoTracking()
    .Where(c => c.City == "Warszawa")
    .Select(c => new CustomerDto
    {
        CustomerId = c.CustomerId,
        Name = c.Name
    })
    .ToListAsync();
```

**Prowadzący:** EF Core tłumaczy obsługiwane fragmenty LINQ na SQL i materializuje DTO. `db` oznacza wcześniej skonfigurowany `DbContext` z `DbSet<Customer>`; szczegółową konfigurację wykonamy na kolejnych zajęciach.

**Wspólna cecha trzech przykładów:** SQL Server nadal otrzymuje zapytanie, optymalizator przygotowuje plan, a serwer wykonuje operacje na tabelach i indeksach.

**Uwaga o jakości porównania:** nie oceniaj szybkości na podstawie długości kodu. Weryfikuj rzeczywiste SQL, parametry, plan, IO, czas, liczbę żądań i koszty materializacji.

## 7. Co dzieje się między LINQ a bazą?

```text
Kod C# i zapytanie LINQ
           |
           v
Model EF Core + expression tree
           |
           v
Provider Microsoft.EntityFrameworkCore.SqlServer
           |
           v
Parametryzowany T-SQL
           |
           v
SQL Server: parser / optymalizator / plan / wykonanie
           |
           v
Wynik -> materializacja obiektów -> opcjonalny Change Tracker
```

Zmiana `Include`, `Select`, `Take` czy `AsSplitQuery` może zmienić liczbę zapytań, liczbę kolumn, JOIN i ilość pobranych danych. `ToQueryString()` umożliwia podejrzenie zapytania (przydatne diagnostycznie); dokładne wykonanie obserwujemy również przez logowanie i narzędzia SQL Server.

## 8. Zalety ORM i pułapki

**Korzyści:** mniej powtarzalnego mapowania, spójniejszy model encji, integracja z językiem programowania, śledzenie zmian, migracje, wsparcie transakcji i testowalności.

**Pułapki:** problem N+1, niepotrzebne kolumny i encje, koszt śledzenia, trudne zapytania generowane automatycznie, niezauważone round-tripy, niebezpieczne migracje, pozorna niezależność od silnika bazy i brak wiedzy o SQL.

ORM może być bardzo dobrym wyborem do transakcyjnego CRUD, a zarazem nie być najlepszą warstwą do każdego raportu czy zadania masowego. W jednym systemie różne podejścia mogą współistnieć.

## 9. Pytania końcowe

1. Dlaczego programista C# nie może po prostu zapisać kolekcji `List<Order>` w relacyjnej kolumnie?
2. Czy Dapper tworzy SQL z LINQ tak jak EF Core?
3. Czym Active Record różni się od Data Mapper?
4. Co jest ważniejsze przy analizie wydajności: długość kodu C# czy praca wykonana przez SQL Server?
5. Kiedy użyłbyś EF Core, a kiedy ręcznie pisanego T-SQL?

### Jednominutowe podsumowanie prowadzącego

ORM powstał, bo ręczne tłumaczenie wierszy, kluczy i relacji na obiekty bywało żmudne i podatne na błędy. Nie zmieniło się jednak to, że model relacyjny i obiektowy rozwiązują inne problemy. EF Core jest naszym głównym narzędziem dydaktycznym, ale świadomy programista zna też ADO.NET, Dapper i alternatywy z innych ekosystemów. **W tym kursie zawsze pytamy: jaki SQL rzeczywiście wykona baza?**

## Materiał dodatkowy dla studentów

- [Martin Fowler — Patterns of Enterprise Application Architecture](https://martinfowler.com/books/eaa.html)
- [Martin Fowler — Data Mapper](https://martinfowler.com/eaaCatalog/dataMapper.html)
- [Martin Fowler — Active Record](https://martinfowler.com/eaaCatalog/activeRecord.html)
- [Microsoft — Overview of EF Core](https://learn.microsoft.com/ef/core/)
- [Microsoft — EF Core vs micro-ORM w aplikacjach ASP.NET Core](https://learn.microsoft.com/dotnet/architecture/modern-web-apps-azure/work-with-data-in-asp-net-core-apps)
- [Dapper — repozytorium](https://github.com/DapperLib/Dapper)
- [Hibernate ORM](https://hibernate.org/orm/)
- [NHibernate](https://nhibernate.info/)
- [SQLAlchemy](https://www.sqlalchemy.org/)
- [jOOQ](https://www.jooq.org/)
- [Prisma ORM](https://www.prisma.io/orm)

## Uwagi redakcyjne

To pełny scenariusz do przeprowadzenia wykładu, nie gotowa prezentacja slajdowa. Przykłady zakładają istniejący model i konfigurację połączenia — celem wykładu 01 jest porównanie podejść, nie kompilowalny projekt. Następny etap: slajdy i notatki prowadzącego powiązane z poszczególnymi sekcjami.
