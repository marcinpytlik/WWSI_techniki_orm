#!/usr/bin/env bash
# Run from the repository root. Requires dotnet-ef 10.x.
# Windows equivalent: labs/scripts/prepare-first-migration.ps1
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root"

project="src/OrmShop.Api/OrmShop.Api.csproj"
dotnet ef migrations add InitialShopSchema --project "$project" --startup-project "$project"
mkdir -p artifacts
dotnet ef migrations script --idempotent --project "$project" --startup-project "$project" --output "artifacts/OrmShop.Migrations.sql"
echo "REVIEW artifacts/OrmShop.Migrations.sql. Never apply as orm_shop_app."
