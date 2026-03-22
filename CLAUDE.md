# nlkart-database — SQL Server DACPAC Project

## Overview
Database schema for the nlkart e-commerce platform. Uses legacy SSDT .sqlproj format with DACPAC deployment.

## Tech Stack
- SQL Server 2019 (CompatibilityMode 150)
- Legacy SSDT .sqlproj (BySchemaAndSchemaType folder structure)
- MERGE statements for idempotent seed data
- Visual Studio 2017+ with SSDT for build/publish

## Schema (11 Tables)
Roles, Users, Categories, Products, CartItems, Orders, OrderItems, ProductReviews, Transactions, Notifications, OfferRules

## File Structure
- Solution: `nlkart-database.sln`
- Project: `nlkart-database/nlkart-database.sqlproj`
- Tables: `nlkart-database/dbo/Tables/<TableName>.sql`
- Post-deploy seed: `nlkart-database/dbo/Scripts/Post-Deployment/SeedData/Script.<Table>SeedData.sql`
- Master post-deploy: `nlkart-database/dbo/Scripts/Post-Deployment/Script.PostDeployment.sql`
- Publish profile: `nlkart-database/local.publish.xml`

## Conventions
- All tables use `INT IDENTITY(1,1)` primary keys
- PK naming: `PK_<TableName>`, FK naming: `FK_<TableName>_<RefTable>`
- All tables have `CreatedAt DATETIME2 DEFAULT GETDATE()`
- Seed data uses MERGE statements (idempotent — safe to re-run)
- PostDeploy script uses SQLCMD `:r` includes in dependency order (Roles -> Users -> Categories -> Products -> Reviews -> OfferRules)

## Do's and Don'ts
- ALWAYS add new tables to .sqlproj via `<Build Include>` ItemGroup
- ALWAYS add new seed data via `<None Include>` ItemGroup and `:r` include in PostDeploy
- ALWAYS use MERGE for seed data (idempotent) — NEVER use plain INSERT
- NEVER modify the publish profile target — it uses Windows Auth to localhost

## Deployment (DACPAC)
- Build: Open `nlkart-database.sln` in Visual Studio -> Build (produces .dacpac)
- Publish: Right-click project -> Publish using `local.publish.xml`
- CLI: `MSBuild` + `SqlPackage /Action:Publish`
- DACPAC compares schema and generates incremental ALTER/CREATE scripts automatically

## Consumed By
- nlkart-api — reads/writes all tables via SQLAlchemy ORM + pyodbc
- nlkart-utils — reads/writes Products, ProductReviews, OfferRules, Notifications via pyodbc

## Related Repos
- nlkart-api (uses this schema via SQLAlchemy): `../nlkart-api`
- nlkart-utils (runs business logic scripts against this schema): `../nlkart-utils`
