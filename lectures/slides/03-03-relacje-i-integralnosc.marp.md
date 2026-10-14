---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 03 · 22.11.2026'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 40px; }
  pre { background: #f0f4f8; }
  code { font-size: 0.77em; }
  table { font-size: 0.72em; }
---

# Relacje, klucze i integralność

**Wykład 03 · 22.11.2026**

C# · Entity Framework Core 10 · SQL Server 2022 CU26

<!-- NOTATKI: Otwarcie i powtórzenie poprzedniego spotkania. -->

---

# Relacje w modelu obiektowym

Referencja do obiektu ≠ fizyczny klucz obcy.

Relacje 1:1, 1:N, N:M.

<!--
NOTATKI PROWADZĄCEGO — slajd 2
Przypomnij mapowanie z wykładu 01.
-->

---

# Relacja jeden do wielu

Customer 1 ── * Order.

FK znajduje się zwykle w tabeli zależnej.

<!--
NOTATKI PROWADZĄCEGO — slajd 3
Zwróć uwagę na nawigacje i spójność.
-->

---

# Model C#

```csharp
public class Customer {
 public int Id { get; set; }
 public List<Order> Orders { get; set; } = [];
}
public class Order {
 public int Id { get; set; }
 public int CustomerId { get; set; }
 public Customer Customer { get; set; } = null!;
}
```

<!--
NOTATKI PROWADZĄCEGO — slajd 4
Nie każda nawigacja musi być pobrana z bazy.
-->

---

# Fluent API 1:N

```csharp
modelBuilder.Entity<Order>()
 .HasOne(o => o.Customer)
 .WithMany(c => c.Orders)
 .HasForeignKey(o => o.CustomerId);
```

<!--
NOTATKI PROWADZĄCEGO — slajd 5
Wyjaśnij principal i dependent.
-->

---

# Optional i required

Nullable FK → relacja opcjonalna.

NOT NULL FK → relacja wymagana.

<!--
NOTATKI PROWADZĄCEGO — slajd 6
Sprawdź nullable reference types i konwencje EF Core.
-->

---

# Relacja jeden do jednego

User ↔ UserProfile.

Unikalny klucz obcy; nie każda relacja 1:1 musi oznaczać jeden rekord fizycznie.

<!--
NOTATKI PROWADZĄCEGO — slajd 7
Jak zapewnić unikalność na poziomie bazy?
-->

---

# Wiele do wielu

Student ↔ Course poprzez Enrollment.

Encja łącząca pozwala dodać datę zapisu i ocenę.

<!--
NOTATKI PROWADZĄCEGO — slajd 8
Warto zademonstrować jawny join entity.
-->

---

# Cascade delete

Cascade / Restrict / NoAction / SetNull — konsekwencje usunięcia rekordu.

<!--
NOTATKI PROWADZĄCEGO — slajd 9
Decyzja domenowa, nie tylko techniczna.
-->

---

# Klucze i indeksy

PK zabezpiecza tożsamość, FK spójność; indeks FK bywa przydatny dla JOIN i blokad.

<!--
NOTATKI PROWADZĄCEGO — slajd 10
Nie utożsamiaj FK z automatycznie istniejącym indeksem w SQL Server.
-->

---

# Problem nadmiernego ładowania

Kolekcja nawigacyjna nie znaczy: wszystkie rekordy od razu.

Include lub jawny odczyt zmienia wykonanie.

<!--
NOTATKI PROWADZĄCEGO — slajd 11
Łącz z przyszłym tematem N+1.
-->

---

# Zadanie na tablicy

Zamodeluj uczelnia → studenci → przedmioty → zapisy.

Które kolumny będą FK?

<!--
NOTATKI PROWADZĄCEGO — slajd 12
Poproś o uzasadnienie ON DELETE.
-->

---

# Podsumowanie

Model obiektowy opisuje relacje nawigacyjne; SQL Server wymusza integralność ograniczeniami.

<!--
NOTATKI PROWADZĄCEGO — slajd 13
Zapowiedz LINQ i generowane JOIN.
-->

---

# ERD: zamówienia

```text
Customers 1 ── N Orders
Orders    1 ── N OrderLines
Products  1 ── N OrderLines
```

OrderLines łączy Orders i Products.

<!-- NOTATKI v2: Rozważ PK (OrderId, ProductId) albo oddzielny OrderLineId. -->

---

# Usuwanie w modelu relacyjnym

Usunięcie klienta z historią zamówień: Cascade, Restrict czy NoAction?

**Reguła usuwania to decyzja biznesowa.**

<!-- NOTATKI v2: Zachowanie historii sprzedaży może wykluczyć cascade. -->

---

# Indeksy przy relacjach

FK nie jest automatycznie indeksem w SQL Server.

Projektuj indeksy zgodnie z JOIN i filtrami.

<!-- NOTATKI v2: Weryfikuj plan, nie dodawaj indeksu do każdej kolumny bez analizy. -->

---

# Decyzja ORM Shop

Które rozwiązanie wybierasz? Nazwij **ryzyko**, sposób pomiaru i wpływ na SQL Server.

<!-- NOTATKI: ćwiczenie do dyskusji; pominąć gdy kończy się czas. -->
