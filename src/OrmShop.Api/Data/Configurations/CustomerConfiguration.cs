using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using OrmShop.Api.Entities;

namespace OrmShop.Api.Data.Configurations;

public sealed class CustomerConfiguration : IEntityTypeConfiguration<Customer>
{
    public void Configure(EntityTypeBuilder<Customer> e)
    {
        e.ToTable("Customers");
        e.HasKey(x => x.Id);
        e.Property(x => x.Name).HasMaxLength(120).IsRequired();
        e.Property(x => x.City).HasMaxLength(120);
    }
}
