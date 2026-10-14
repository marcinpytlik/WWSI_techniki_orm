namespace OrmShop.Api.Entities;

public sealed class Customer
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? City { get; set; }
    public List<Order> Orders { get; set; } = [];
}
