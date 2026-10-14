---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 02 · 08.11.2026'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 40px; }
  pre { background: #f0f4f8; }
  code { font-size: 0.77em; }
  table { font-size: 0.72em; }
---

# Encje, DbContext i migracje

**Wykład 02 · 08.11.2026**

C# · Entity Framework Core 10 · SQL Server 2022 CU26

<!-- NOTATKI: Otwarcie i powtórzenie poprzedniego spotkania. -->

---

# Od tabeli do encji

Tabela opisuje strukturę danych; encja reprezentuje obiekt w modelu aplikacji.

<!--
NOTATKI PROWADZĄCEGO — slajd 2
Model C# to niekoniecznie wierna kopia tabeli.
-->

---

# Podstawowa encja

```csharp
public sealed class Product {
 public int Id { get; set; }
 public string Name { get; set; } = "";
 public decimal Price { get; set; }
}
```

<!--
NOTATKI PROWADZĄCEGO — slajd 3
Omów PK, nullability i typ decimal.
-->

---

# Rola DbContext

DbContext: konfiguracja mapowania, zapytania, Change Tracker, zapis zmian.

<!--
NOTATKI PROWADZĄCEGO — slajd 4
W aplikacji webowej zwykle kontekst o krótkim czasie życia.
-->

---

# DbSet i model

```csharp
public sealed class ShopDb : DbContext {
 public ShopDb(DbContextOptions<ShopDb> o) : base(o) { }
 public DbSet<Product> Products => Set<Product>();
}
```

<!--
NOTATKI PROWADZĄCEGO — slajd 5
DbSet nie jest kopią tabeli trzymaną w pamięci.
-->

---

# Konwencje EF Core

Id/ProductId → klucz; klasy encji; opcjonalność; relacje rozpoznawane przez konwencje.

<!--
NOTATKI PROWADZĄCEGO — slajd 6
Konwencje przyspieszają pracę, ale trzeba znać wynik modelowania.
-->

---

# Fluent API

```csharp
modelBuilder.Entity<Product>(e => {
 e.ToTable("Products", "dbo");
 e.HasKey(p => p.Id);
 e.Property(p => p.Name).HasMaxLength(120).IsRequired();
 e.Property(p => p.Price).HasPrecision(18, 2);
});
```

<!--
NOTATKI PROWADZĄCEGO — slajd 7
MaxLength i precyzja to istotne decyzje projektowe.
-->

---

# Code First i Database First

Code First: model aplikacji → migracje.

Database First: istniejąca baza → scaffolding modelu.

<!--
NOTATKI PROWADZĄCEGO — slajd 8
Dobór podejścia zależy od tego, kto zarządza schematem.
-->

---

# Anatomia migracji

Model snapshot · Up() · Down() · historia migracji.

<!--
NOTATKI PROWADZĄCEGO — slajd 9
Migracja powinna być kontrolowaną zmianą struktury.
-->

---

# Workflow migracji

```powershell
dotnet ef migrations add InitialCreate
dotnet ef migrations script -o migration.sql
dotnet ef database update
```

<!--
NOTATKI PROWADZĄCEGO — slajd 10
Przed produkcją przeanalizuj wygenerowany skrypt, blokady i utratę danych.
-->

---

# Kiedy migracja jest ryzykowna?

DROP COLUMN, zmiana typu, duża tabela, indeks online/offline, deployment aplikacji.

<!--
NOTATKI PROWADZĄCEGO — slajd 11
W praktyce produkcyjnej preferuj kompatybilne zmiany etapowe.
-->

---

# Pytanie do sali

Czy zmiana nazwy pola w C# zawsze bezpiecznie zmieni nazwę kolumny SQL?

<!--
NOTATKI PROWADZĄCEGO — slajd 12
Migracja może rozpoznać rename jako drop/add — wymagany przegląd.
-->

---

# Podsumowanie

Encje i DbContext są modelem; migracje zmieniają rzeczywistą bazę.

**Żadna migracja nie powinna trafić na produkcję bez przeglądu SQL.**

<!--
NOTATKI PROWADZĄCEGO — slajd 13
Zapowiedź relacji i kluczy obcych.
-->
