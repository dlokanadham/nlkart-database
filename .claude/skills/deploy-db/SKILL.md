---
name: deploy-db
description: Build and publish the nlkart DACPAC to local SQL Server
user-invocable: true
allowed-tools: Bash, Read
---

# Deploy Database

Build the DACPAC and publish to local SQL Server.

## Steps

1. **Build** the DACPAC:
   ```
   MSBuild nlkart-database\nlkart-database.sqlproj /p:Configuration=Debug
   ```

2. **Publish** to local SQL Server:
   ```
   SqlPackage /Action:Publish /SourceFile:"nlkart-database\bin\Debug\nlkart-database.dacpac" /Profile:"nlkart-database\local.publish.xml"
   ```

3. **Verify** deployment by checking table count:
   ```
   sqlcmd -S localhost -E -Q "SELECT COUNT(*) AS TableCount FROM nlkart_db.sys.tables"
   ```

4. **Report** results — show which tables exist and row counts for key tables.

## Troubleshooting
- If MSBuild not found: Check Visual Studio installation or use Developer Command Prompt
- If SqlPackage not found: Install via `dotnet tool install -g microsoft.sqlpackage`
- If connection fails: Verify SQL Server is running and Windows Auth is enabled
