using Microsoft.EntityFrameworkCore;
using OrmShop.Api;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("ShopDb")
    ?? throw new InvalidOperationException(
        "Missing ConnectionStrings:ShopDb (set via dotnet user-secrets).");

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
        .Select(x => new { x.Id, x.Sku, x.Name, x.Price })
        .ToListAsync(ct));

app.MapGet("/customers", async (ShopDbContext db, CancellationToken ct) =>
    await db.Customers.AsNoTracking()
        .OrderBy(x => x.Id)
        .Select(x => new { x.Id, x.Name, x.City })
        .ToListAsync(ct));

app.Run();
