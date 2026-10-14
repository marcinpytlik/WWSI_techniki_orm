param([string]$Project = "src/OrmShop.Api/OrmShop.Api.csproj")
$ErrorActionPreference = "Stop"
# Run from repository root; requires dotnet-ef 10.x
dotnet ef migrations add InitialShopSchema --project $Project --startup-project $Project
if ($LASTEXITCODE -ne 0) { throw "Migration generation failed." }
New-Item -ItemType Directory -Path "artifacts" -Force | Out-Null
dotnet ef migrations script --idempotent --project $Project --startup-project $Project --output "artifacts/OrmShop.Migrations.sql"
if ($LASTEXITCODE -ne 0) { throw "Migration SQL generation failed." }
Write-Host "REVIEW artifacts/OrmShop.Migrations.sql. Never apply as orm_shop_app."
