namespace OrmShop.Api.Entities;

public sealed class Order
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public Customer Customer { get; set; } = null!;

    // datetimeoffset zachowuje offset UTC po odczycie. DateTime wróciłby jako Unspecified.
    public DateTimeOffset CreatedAt { get; set; }

    public List<OrderLine> Lines { get; set; } = [];
}
