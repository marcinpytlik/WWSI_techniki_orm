namespace OrmShop.Api;

public sealed class Customer
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? City { get; set; }
    public List<Order> Orders { get; set; } = [];
}

public sealed class Product
{
    public int Id { get; set; }
    public string Sku { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public decimal Price { get; set; }

    // null, nie pusta tablica: pusta tablica jest wartością i EF próbowałby
    // zapisać ją do kolumny rowversion.
    public byte[] RowVersion { get; set; } = null!;

    public List<OrderLine> OrderLines { get; set; } = [];
}

public sealed class Order
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public Customer Customer { get; set; } = null!;

    // datetimeoffset zachowuje offset UTC po odczycie. DateTime wróciłby jako Unspecified.
    public DateTimeOffset CreatedAt { get; set; }

    public List<OrderLine> Lines { get; set; } = [];
}

public sealed class OrderLine
{
    public int OrderId { get; set; }
    public Order Order { get; set; } = null!;
    public int ProductId { get; set; }
    public Product Product { get; set; } = null!;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
}
