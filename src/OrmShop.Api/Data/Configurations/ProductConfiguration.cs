using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using OrmShop.Api.Entities;

namespace OrmShop.Api.Data.Configurations;

public sealed class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> e)
    {
        e.ToTable("Products");
        e.HasKey(x => x.Id);
        e.Property(x => x.Sku).HasMaxLength(40).IsRequired();
        e.HasIndex(x => x.Sku).IsUnique();
        e.Property(x => x.Name).HasMaxLength(120).IsRequired();
        e.Property(x => x.Price).HasPrecision(18, 2);
        e.Property(x => x.RowVersion).IsRowVersion();
    }
}
