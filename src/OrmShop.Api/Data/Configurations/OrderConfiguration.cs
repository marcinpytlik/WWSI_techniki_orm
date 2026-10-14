using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using OrmShop.Api.Entities;

namespace OrmShop.Api.Data.Configurations;

public sealed class OrderConfiguration : IEntityTypeConfiguration<Order>
{
    public void Configure(EntityTypeBuilder<Order> e)
    {
        e.ToTable("Orders");
        e.HasKey(x => x.Id);
        // SQL Server konwertuje SYSUTCDATETIME() na datetimeoffset (+00:00).
        e.Property(x => x.CreatedAt)
            .HasDefaultValueSql("SYSUTCDATETIME()")
            .ValueGeneratedOnAdd();
        e.HasOne(x => x.Customer).WithMany(x => x.Orders)
            .HasForeignKey(x => x.CustomerId).OnDelete(DeleteBehavior.NoAction);
    }
}
