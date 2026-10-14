using Microsoft.EntityFrameworkCore;
using OrmShop.Api.Data;

var builder = WebApplication.CreateBuilder(args);

// Development ustawia Properties/launchSettings.json. User-secrets są czytane
// tylko w tym środowisku, a log SQL jest tym, co oglądają laboratoria.
if (builder.Environment.IsDevelopment())
{
    builder.Logging.AddFilter(
        "Microsoft.EntityFrameworkCore.Database.Command",
        LogLevel.Information);
}

var connectionString = builder.Configuration.GetConnectionString("ShopDb")
    ?? throw new InvalidOperationException(
        "Missing ConnectionStrings:ShopDb. Run in Development and set the value with dotnet user-secrets.");

builder.Services.AddDbContext<ShopDbContext>(options =>
    options.UseSqlServer(connectionString, sql =>
        sql.MigrationsHistoryTable("__EFMigrationsHistory", "shop")));

var app = builder.Build();

// SECURITY POLICY: DO NOT call Database.Migrate() or EnsureCreated() here.
// Apply reviewed scripts separately as orm_shop_deploy.
app.MapGet("/health", () => Results.Ok(new { status = "running" }));

app.MapGet("/products", async (ShopDbContext db, CancellationToken ct) =>
    await db.Products.AsNoTracking()
        .OrderBy(x => x.Id)
        .Select(x => new { x.Id, x.Sku, x.Name, x.Price, x.RowVersion })
        .ToListAsync(ct));

app.MapGet("/customers", async (ShopDbContext db, CancellationToken ct) =>
    await db.Customers.AsNoTracking()
        .OrderBy(x => x.Id)
        .Select(x => new { x.Id, x.Name, x.City })
        .ToListAsync(ct));

app.Run();
