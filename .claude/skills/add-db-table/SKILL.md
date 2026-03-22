---
name: add-db-table
description: Add a new table to the nlkart database with proper conventions
argument-hint: <table-name>
user-invocable: true
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Add Database Table

Create a new table called `$ARGUMENTS` in the nlkart database following project conventions.

## Steps

1. **Ask** for table name (if not provided), columns with data types, and foreign key relationships.

2. **Create Table Script** — `nlkart-database/dbo/Tables/$0.sql`
   - Use `INT IDENTITY(1,1)` for primary key
   - PK constraint: `PK_$0`
   - FK constraints: `FK_$0_<RefTable>`
   - Add `CreatedAt DATETIME2 DEFAULT GETDATE()`
   - Add appropriate indexes

3. **Update .sqlproj** — `nlkart-database/nlkart-database.sqlproj`
   - Add `<Build Include="dbo\Tables\$0.sql" />` in the Build ItemGroup

4. **Create Seed Data** — `nlkart-database/dbo/Scripts/Post-Deployment/SeedData/Script.$0SeedData.sql`
   - Use MERGE statement (idempotent — safe to re-run)
   - Include realistic sample data (3-5 rows)

5. **Update .sqlproj for Seed Data**
   - Add `<None Include="dbo\Scripts\Post-Deployment\SeedData\Script.$0SeedData.sql" />` in the None ItemGroup

6. **Update PostDeploy Script** — `nlkart-database/dbo/Scripts/Post-Deployment/Script.PostDeployment.sql`
   - Add `:r .\SeedData\Script.$0SeedData.sql` in the correct dependency order

7. **Verify** — Review the generated SQL for correctness.
