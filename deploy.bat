@echo off
echo ============================================
echo  nlkart Database Deployment
echo ============================================
echo.

set SERVER=localhost
set DATABASE=nlkart_db

echo Creating database %DATABASE% on %SERVER%...
sqlcmd -S %SERVER% -E -Q "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '%DATABASE%') CREATE DATABASE [%DATABASE%]"

echo.
echo Deploying tables...
for %%f in (Tables\Roles.sql Tables\Users.sql Tables\Categories.sql Tables\Products.sql Tables\CartItems.sql Tables\Orders.sql Tables\OrderItems.sql Tables\ProductReviews.sql Tables\Transactions.sql Tables\Notifications.sql Tables\OfferRules.sql) do (
    echo   Deploying %%f...
    sqlcmd -S %SERVER% -E -d %DATABASE% -i "%%f"
)

echo.
echo Loading seed data...
sqlcmd -S %SERVER% -E -d %DATABASE% -i "PostDeploy\SeedData.sql"

echo.
echo ============================================
echo  Deployment complete!
echo ============================================
pause
