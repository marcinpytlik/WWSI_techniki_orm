---
marp: true
theme: default
paginate: true
size: 16:9
header: 'WWSI · Narzędzia i techniki ORM'
footer: 'Wykład 05 · 20.12.2026'
style: |
  section { font-family: 'Aptos', 'Arial', sans-serif; font-size: 27px; color: #17243a; padding: 58px 66px; }
  h1 { color: #133c69; font-size: 40px; }
  pre { background: #f0f4f8; }
  code { font-size: 0.77em; }
  table { font-size: 0.72em; }
---

# Change Tracker i CRUD

**Wykład 05 · 20.12.2026**

C# · Entity Framework Core 10 · SQL Server 2022 CU26

<!-- NOTATKI: Otwarcie i powtórzenie poprzedniego spotkania. -->

---

# Co oznacza śledzenie zmian?

Kontekst zapamiętuje stan encji i wykrywa zmodyfikowane właściwości.

<!--
NOTATKI PROWADZĄCEGO — slajd 2
Rozróżnij śledzenie w kontekście a trwałość w SQL Server.
-->

---

# Stany encji

Detached · Unchanged · Added · Modified · Deleted.

<!--
NOTATKI PROWADZĄCEGO — slajd 3
Narysuj prosty diagram przejść stanów.
-->

---

# INSERT przez EF Core

```csharp
db.Products.Add(new Product { Name = "Rower", Price = 1000 });
await db.SaveChangesAsync();
```

<!--
NOTATKI PROWADZĄCEGO — slajd 4
SaveChanges tworzy odpowiednie polecenia DML.
-->

---

# UPDATE w śledzonym kontekście

```csharp
var p = await db.Products.FindAsync(id);
if (p is not null) {
 p.Price = 1100;
 await db.SaveChangesAsync();
}
```

<!--
NOTATKI PROWADZĄCEGO — slajd 5
Omów wykrywanie zmian.
-->

---

# DELETE i ograniczenia

```csharp
db.Products.Remove(product);
await db.SaveChangesAsync();
```

<!--
NOTATKI PROWADZĄCEGO — slajd 6
Baza może odrzucić usunięcie z powodu FK.
-->

---

# Find vs FirstOrDefault

Find najpierw sprawdza śledzone encje; FirstOrDefault buduje zapytanie.

<!--
NOTATKI PROWADZĄCEGO — slajd 7
Nie zakładaj, że każde wywołanie = round-trip.
-->

---

# AsNoTracking

```csharp
var items = await db.Products.AsNoTracking().ToListAsync();
```

<!--
NOTATKI PROWADZĄCEGO — slajd 8
Dobry punkt wyjścia dla read-only; nie zawsze szybszy przy identycznych referencjach.
-->

---

# Identity resolution

W śledzonym kontekście ta sama encja klucza ma jedną instancję.

<!--
NOTATKI PROWADZĄCEGO — slajd 9
Przy no-tracking rozważ AsNoTrackingWithIdentityResolution.
-->

---

# Odłączone encje i API

Obiekt przysłany w żądaniu HTTP nie jest automatycznie śledzony.

<!--
NOTATKI PROWADZĄCEGO — slajd 10
Update(entity) może zaznaczyć wiele właściwości jako zmienione.
-->

---

# Transakcja SaveChanges

Pojedyncze SaveChanges zwykle jest transakcyjne u relacyjnego providera.

<!--
NOTATKI PROWADZĄCEGO — slajd 11
Nie myl z całą transakcją biznesową wielu usług.
-->

---

# Walidacja vs constraints

Walidacja wejścia aplikacji ≠ unikalność, NOT NULL, FK w bazie.

<!--
NOTATKI PROWADZĄCEGO — slajd 12
Baza jest ostatecznym strażnikiem integralności.
-->

---

# Podsumowanie

Change Tracker daje wygodę, ale ma koszt i określony czas życia.

<!--
NOTATKI PROWADZĄCEGO — slajd 13
Przejście do współbieżności.
-->
