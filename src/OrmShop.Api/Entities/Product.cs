namespace OrmShop.Api.Entities;

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
