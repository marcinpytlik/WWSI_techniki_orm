using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using OrmShop.Api.Entities;

namespace OrmShop.Api.Data.Configurations;

public sealed class OrderLineConfiguration : IEntityTypeConfiguration<OrderLine>
{
    public void Configure(EntityTypeBuilder<OrderLine> e)
    {
        e.ToTable("OrderLines");
        e.HasKey(x => new { x.OrderId, x.ProductId });
        e.Property(x => x.UnitPrice).HasPrecision(18, 2);
        e.HasOne(x => x.Order).WithMany(x => x.Lines)
            .HasForeignKey(x => x.OrderId).OnDelete(DeleteBehavior.Cascade);
        e.HasOne(x => x.Product).WithMany(x => x.OrderLines)
            .HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.NoAction);
    }
}
