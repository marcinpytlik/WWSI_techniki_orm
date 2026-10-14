using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace OrmShop.Api;

// Pozwala wykonać `dotnet ef migrations add` i `migrations script` bez żywej bazy.
// Gdy user-secrets zawierają ConnectionStrings:ShopDb, używana jest ta wartość.
// Placeholder nie jest hasłem i nie jest czytany przez Program.cs.
public sealed class ShopDbContextFactory : IDesignTimeDbContextFactory<ShopDbContext>
{
    public const string DesignTimeConnectionString =
        "Server=localhost,14333;Database=OrmShop;User ID=orm_shop_deploy;Password=DesignTimePlaceholder-NotASecret;Encrypt=True;TrustServerCertificate=True";

    public ShopDbContext CreateDbContext(string[] args)
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: true)
            .AddUserSecrets<ShopDbContextFactory>(optional: true)
            .AddEnvironmentVariables()
            .Build();

        var connectionString = configuration.GetConnectionString("ShopDb")
            ?? DesignTimeConnectionString;

        var options = new DbContextOptionsBuilder<ShopDbContext>()
            .UseSqlServer(connectionString, sql =>
                sql.MigrationsHistoryTable("__EFMigrationsHistory", "shop"))
            .Options;

        return new ShopDbContext(options);
    }
}
