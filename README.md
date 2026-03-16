# nlkart-database - SQL Server DACPAC Project

A SQL Server Database project (SSDT/DACPAC) that manages the complete schema and seed data for the nlkart e-commerce platform. Uses the legacy `.sqlproj` format targeting SQL Server 2019 (CompatibilityMode 150).

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| SQL Server 2019+ | Database engine |
| SSDT (SQL Server Data Tools) | Schema management & deployment |
| DACPAC | Compiled database package for incremental deployment |
| SQLCMD | Script execution with `:r` includes |
| MERGE Statements | Idempotent seed data insertion |

## Features

- **11 Tables** with proper constraints, foreign keys, and nonclustered indexes
- **6 Seed Data Scripts** using MERGE statements for idempotent deployment
- **DACPAC Deployment** — Schema comparison with incremental ALTER/CREATE scripts
- **Publish Profile** — Pre-configured for localhost with Windows Authentication
- **PostDeployment Script** — Orchestrates seed data in dependency order
- **BlockOnPossibleDataLoss** — Safety flag prevents accidental data destruction

## Project Structure

```
nlkart-database/
├── nlkart-database.sln                              # VS Solution file
├── .gitignore                                        # Excludes bin/, obj/, .vs/, *.dacpac
│
└── nlkart-database/                                  # Project folder
    ├── nlkart-database.sqlproj                      # Legacy SSDT project (Sql150 provider)
    ├── local.publish.xml                            # Publish profile → localhost\nlkart_db
    │
    ├── bin/Debug/
    │   └── nlkart-database.dacpac                   # Built DACPAC (compiled schema package)
    │
    └── dbo/
        ├── Tables/                                   # 11 table definitions
        │   ├── Roles.sql
        │   ├── Users.sql
        │   ├── Categories.sql
        │   ├── Products.sql
        │   ├── CartItems.sql
        │   ├── Orders.sql
        │   ├── OrderItems.sql
        │   ├── ProductReviews.sql
        │   ├── Transactions.sql
        │   ├── Notifications.sql
        │   └── OfferRules.sql
        │
        └── Scripts/Post-Deployment/
            ├── Script.PostDeployment.sql             # Master script (SQLCMD :r includes)
            └── SeedData/                             # 6 seed data scripts (MERGE statements)
                ├── Script.RolesSeedData.sql          # 5 roles
                ├── Script.UsersSeedData.sql          # 9 users
                ├── Script.CategoriesSeedData.sql     # 5 categories
                ├── Script.ProductsSeedData.sql       # 20 products
                ├── Script.ReviewsSeedData.sql        # 13 reviews
                └── Script.OfferRulesSeedData.sql     # 5 offer rules
```

## Database Schema

### Entity Relationship Diagram

```
┌─────────────┐     ┌──────────────────────┐     ┌───────────────┐
│   Roles     │     │       Users          │     │  Categories   │
├─────────────┤     ├──────────────────────┤     ├───────────────┤
│ RoleId (PK) │◄────│ RoleId (FK)          │     │CategoryId(PK) │
│ RoleName    │  1:N│ UserId (PK)          │     │ Name          │
│ Description │     │ Email, Username      │     │ Description   │
└─────────────┘     │ PasswordHash         │     │ ImageUrl      │
                    │ WalletBalance        │     │ IsActive      │
                    └──┬───┬───┬───┬───────┘     └──────┬────────┘
                       │   │   │   │                    │
          ┌────────────┘   │   │   └──────────┐        │
          │                │   │              │        │
          ▼ 1:N            │   │              │        │
   ┌──────────────┐        │   │              │        │
   │  CartItems   │        │   │              ▼ 1:N    ▼ 1:N
   ├──────────────┤        │   │     ┌────────────────────────────┐
   │CartItemId(PK)│        │   │     │         Products           │
   │ UserId (FK)  │        │   │     ├────────────────────────────┤
   │ProductId(FK) │        │   │     │ ProductId (PK)             │
   │ Quantity     │        │   │     │ DealerId (FK) → Users      │
   │ AddedAt      │        │   │     │ CategoryId (FK)→Categories │
   └──────────────┘        │   │     │ Name, Description, Price   │
                           │   │     │ OriginalPrice, ImageUrl    │
          ┌────────────────┘   │     │ Stock, ApprovalStatus      │
          │                    │     │ ReviewedBy (FK) → Users     │
          ▼ 1:N                │     │ AverageRating,DiscountPct  │
   ┌──────────────┐            │     └──┬──────┬──────┬───────────┘
   │Notifications │            │        │      │      │
   ├──────────────┤            │        │      │      │
   │NotifId (PK)  │            │        │      │      ▼ 1:N
   │ UserId (FK)  │            │        │      │  ┌────────────────┐
   │ Title        │            │        │      │  │ProductReviews  │
   │ Message      │            │        │      │  ├────────────────┤
   │ IsRead       │            │        │      │  │ ReviewId (PK)  │
   └──────────────┘            │        │      │  │ProductId (FK)  │
                               │        │      │  │ UserId (FK)    │
          ┌────────────────────┘        │      │  │ Rating (1-5)   │
          │                             │      │  │ Comment        │
          ▼ 1:N                         │      │  └────────────────┘
   ┌──────────────┐                     │      │
   │   Orders     │                     │      ▼ 1:N
   ├──────────────┤                     │  ┌───────────────┐
   │ OrderId (PK) │                     │  │  OfferRules   │
   │ UserId (FK)  │                     │  ├───────────────┤
   │ TotalAmount  │                     │  │ OfferId (PK)  │
   │DiscountAmt   │                     │  │CategoryId(FK) │
   │ OrderStatus  │                     │  │DiscountPct    │
   │ShippingAddr  │                     │  │ SeasonTag     │
   └──────┬───────┘                     │  │Min/MaxPrice   │
          │                             │  │Start/EndDate  │
          │ 1:N                         │  └───────────────┘
          ▼                             │
   ┌──────────────┐                     │
   │ OrderItems   │                     │
   ├──────────────┤              ┌──────┴───────────┐
   │OrderItemId   │              │  Transactions    │
   │ OrderId (FK) │              ├──────────────────┤
   │ProductId(FK) │              │TransactionId(PK) │
   │ Quantity     │              │ UserId (FK)      │
   │ UnitPrice    │              │ OrderId (FK)     │
   └──────────────┘              │ Amount, Type     │
                                 │ BalanceAfter     │
                                 └──────────────────┘
```

### Table Details

#### 1. Roles
| Column | Type | Constraints |
|--------|------|-------------|
| RoleId | INT IDENTITY(1,1) | PK |
| RoleName | NVARCHAR(50) | UNIQUE, NOT NULL |
| Description | NVARCHAR(200) | NULL |

#### 2. Users
| Column | Type | Constraints |
|--------|------|-------------|
| UserId | INT IDENTITY(1,1) | PK |
| Email | NVARCHAR(100) | UNIQUE, NOT NULL |
| Username | NVARCHAR(50) | UNIQUE, NOT NULL |
| PasswordHash | NVARCHAR(200) | NOT NULL |
| FirstName | NVARCHAR(50) | NOT NULL |
| LastName | NVARCHAR(50) | NOT NULL |
| RoleId | INT | FK → Roles, NOT NULL |
| WalletBalance | DECIMAL(18,2) | DEFAULT 0, NOT NULL |
| IsActive | BIT | DEFAULT 1, NOT NULL |
| CreatedAt | DATETIME2(7) | DEFAULT SYSUTCDATETIME() |
| UpdatedAt | DATETIME2(7) | DEFAULT SYSUTCDATETIME() |

**Indexes:** IX_Users_RoleId (Nonclustered)

#### 3. Categories
| Column | Type | Constraints |
|--------|------|-------------|
| CategoryId | INT IDENTITY(1,1) | PK |
| Name | NVARCHAR(100) | UNIQUE, NOT NULL |
| Description | NVARCHAR(500) | NULL |
| ImageUrl | NVARCHAR(500) | NULL |
| IsActive | BIT | DEFAULT 1, NOT NULL |

#### 4. Products
| Column | Type | Constraints |
|--------|------|-------------|
| ProductId | INT IDENTITY(1,1) | PK |
| DealerId | INT | FK → Users, NOT NULL |
| CategoryId | INT | FK → Categories, NOT NULL |
| Name | NVARCHAR(200) | NOT NULL |
| Description | NVARCHAR(2000) | NULL |
| Price | DECIMAL(18,2) | NOT NULL |
| OriginalPrice | DECIMAL(18,2) | NOT NULL |
| ImageUrl | NVARCHAR(500) | NULL |
| Stock | INT | DEFAULT 0, NOT NULL |
| ApprovalStatus | NVARCHAR(20) | CHECK IN ('Pending','Approved','Rejected'), DEFAULT 'Pending' |
| ReviewerNotes | NVARCHAR(500) | NULL |
| ReviewedBy | INT | FK → Users, NULL |
| ReviewedAt | DATETIME2(7) | NULL |
| AverageRating | DECIMAL(3,2) | DEFAULT 0, NOT NULL |
| DiscountPercent | DECIMAL(5,2) | DEFAULT 0, NOT NULL |

**Indexes:** IX_Products_DealerId, IX_Products_CategoryId, IX_Products_ApprovalStatus (all Nonclustered)

#### 5. CartItems
| Column | Type | Constraints |
|--------|------|-------------|
| CartItemId | INT IDENTITY(1,1) | PK |
| UserId | INT | FK → Users, NOT NULL |
| ProductId | INT | FK → Products, NOT NULL |
| Quantity | INT | DEFAULT 1, NOT NULL |
| AddedAt | DATETIME2(7) | DEFAULT SYSUTCDATETIME() |

**Constraints:** UNIQUE(UserId, ProductId) — one entry per user per product
**Indexes:** IX_CartItems_UserId (Nonclustered)

#### 6. Orders
| Column | Type | Constraints |
|--------|------|-------------|
| OrderId | INT IDENTITY(1,1) | PK |
| UserId | INT | FK → Users, NOT NULL |
| TotalAmount | DECIMAL(18,2) | NOT NULL |
| DiscountAmount | DECIMAL(18,2) | DEFAULT 0, NOT NULL |
| OrderStatus | NVARCHAR(20) | CHECK IN ('Placed','Shipped','Delivered','Cancelled'), DEFAULT 'Placed' |
| ShippingAddress | NVARCHAR(500) | NOT NULL |

**Indexes:** IX_Orders_UserId, IX_Orders_OrderStatus (Nonclustered)

#### 7. OrderItems
| Column | Type | Constraints |
|--------|------|-------------|
| OrderItemId | INT IDENTITY(1,1) | PK |
| OrderId | INT | FK → Orders, NOT NULL |
| ProductId | INT | FK → Products, NOT NULL |
| Quantity | INT | NOT NULL |
| UnitPrice | DECIMAL(18,2) | NOT NULL |

**Indexes:** IX_OrderItems_OrderId (Nonclustered)

#### 8. ProductReviews
| Column | Type | Constraints |
|--------|------|-------------|
| ReviewId | INT IDENTITY(1,1) | PK |
| ProductId | INT | FK → Products, NOT NULL |
| UserId | INT | FK → Users, NOT NULL |
| Rating | INT | CHECK (1-5), NOT NULL |
| Comment | NVARCHAR(1000) | NULL |

**Constraints:** UNIQUE(UserId, ProductId) — one review per user per product
**Indexes:** IX_ProductReviews_ProductId (Nonclustered)

#### 9. Transactions
| Column | Type | Constraints |
|--------|------|-------------|
| TransactionId | INT IDENTITY(1,1) | PK |
| UserId | INT | FK → Users, NOT NULL |
| OrderId | INT | FK → Orders, NULL |
| Amount | DECIMAL(18,2) | NOT NULL |
| Type | NVARCHAR(10) | CHECK IN ('Debit','Credit'), NOT NULL |
| BalanceAfter | DECIMAL(18,2) | NOT NULL |

**Indexes:** IX_Transactions_UserId (Nonclustered)

#### 10. Notifications
| Column | Type | Constraints |
|--------|------|-------------|
| NotificationId | INT IDENTITY(1,1) | PK |
| UserId | INT | FK → Users, NOT NULL |
| Title | NVARCHAR(200) | NOT NULL |
| Message | NVARCHAR(1000) | NOT NULL |
| IsRead | BIT | DEFAULT 0, NOT NULL |

**Indexes:** IX_Notifications_UserId_IsRead (Nonclustered composite)

#### 11. OfferRules
| Column | Type | Constraints |
|--------|------|-------------|
| OfferId | INT IDENTITY(1,1) | PK |
| Name | NVARCHAR(200) | NOT NULL |
| DiscountPercent | DECIMAL(5,2) | NOT NULL |
| CategoryId | INT | FK → Categories, NULL (null = all categories) |
| SeasonTag | NVARCHAR(50) | NULL |
| MinPrice | DECIMAL(18,2) | NULL |
| MaxPrice | DECIMAL(18,2) | NULL |
| IsActive | BIT | DEFAULT 1, NOT NULL |
| StartDate | DATE | NULL |
| EndDate | DATE | NULL |

## Seed Data

### Roles (5)
| RoleId | RoleName | Description |
|--------|----------|-------------|
| 1 | Administrator | Full system access, user management |
| 2 | Dealer | Can add and manage products |
| 3 | Reviewer | Reviews and approves/rejects dealer products |
| 4 | EndUser | Browse, purchase products, write reviews |
| 5 | SupportAgent | View orders, products, handle customer issues |

### Users (9)
All accounts use password: **Testing@123**

| UserId | Username | Role | Email | Wallet |
|--------|----------|------|-------|--------|
| 1 | admin | Administrator | admin@nlkart.com | Rs.0 |
| 2 | reviewer1 | Reviewer | reviewer1@nlkart.com | Rs.0 |
| 3 | reviewer2 | Reviewer | reviewer2@nlkart.com | Rs.0 |
| 4 | dealer1 | Dealer | dealer1@nlkart.com | Rs.0 |
| 5 | dealer2 | Dealer | dealer2@nlkart.com | Rs.0 |
| 6 | user1 | EndUser | user1@nlkart.com | Rs.10,000 |
| 7 | user2 | EndUser | user2@nlkart.com | Rs.10,000 |
| 8 | user3 | EndUser | user3@nlkart.com | Rs.10,000 |
| 9 | support1 | SupportAgent | support1@nlkart.com | Rs.0 |

### Categories (5)
Electronics, Clothing, Books, Home & Kitchen, Sports — with picsum.photos images

### Products (20)
- **13 Approved** — Across all 5 categories (headphones, charger, keyboard, t-shirt, jeans, shoes, books, kitchenware, sports gear)
- **4 Pending** — Awaiting reviewer approval
- **3 Rejected** — With reviewer notes explaining rejection reasons

### Reviews (13)
Product reviews from EndUsers (user1, user2, user3) with ratings 3-5 and comments

### Offer Rules (5)
| Name | Discount | Category | Season | Active |
|------|----------|----------|--------|--------|
| Summer Clothing Sale | 15% | Clothing | Summer | Yes |
| Electronics Weekend Deal | 10% | Electronics | — | Yes |
| Books Clearance | 20% | Books | — | Yes |
| Sports Fitness Month | 12% | Sports | — | Yes |
| Home Essentials Discount | 8% | Home & Kitchen | — | No |

## How to Deploy

### Prerequisites
- Visual Studio 2017+ with SSDT (SQL Server Data Tools)
- SQL Server 2019+ running on localhost
- Windows Authentication enabled

### Method 1: Visual Studio (Recommended)

1. Open `nlkart-database.sln` in Visual Studio
2. Right-click the `nlkart-database` project → **Build**
3. Right-click the project → **Publish...**
4. Select `local.publish.xml` as the publish profile
5. Click **Publish**

### Method 2: CLI (MSBuild + SqlPackage)

```bash
cd nlkart-database

# Build the DACPAC
MSBuild nlkart-database\nlkart-database.sqlproj /p:Configuration=Debug

# Publish to localhost
SqlPackage /Action:Publish /SourceFile:"nlkart-database\bin\Debug\nlkart-database.dacpac" /Profile:"nlkart-database\local.publish.xml"
```

### How DACPAC Deployment Works

```
.sqlproj (source) → Build → .dacpac (compiled schema)
                                    ↓
                    SqlPackage compares .dacpac vs live DB
                                    ↓
                    Generates diff script (ALTER/CREATE only)
                                    ↓
                    Applies changes + runs PostDeployment script
                    (MERGE statements = idempotent seed data)
```

### Publish Profile Settings (`local.publish.xml`)

| Setting | Value | Meaning |
|---------|-------|---------|
| TargetDatabaseName | nlkart_db | Database name on server |
| TargetConnectionString | localhost, Integrated Security | Windows Auth |
| BlockOnPossibleDataLoss | True | Won't drop data without confirmation |
| CreateNewDatabase | False | Incremental updates, not full recreate |

### Fix Password Hashes After Deploy

Seed data contains a static bcrypt hash. If login fails after re-deploy:

```bash
cd ../nlkart-api
python -c "import bcrypt, pyodbc; h=bcrypt.hashpw(b'Testing@123',bcrypt.gensalt(12)).decode(); conn=pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=nlkart_db;Trusted_Connection=yes'); conn.cursor().execute('UPDATE Users SET PasswordHash=?',h); conn.commit(); print(f'Updated: {h}')"
```

## PostDeployment Script Execution Order

The master `Script.PostDeployment.sql` uses SQLCMD `:r` includes in dependency order:

```sql
:r .\SeedData\Script.RolesSeedData.sql          -- 1. Roles (no dependencies)
:r .\SeedData\Script.UsersSeedData.sql          -- 2. Users (depends on Roles)
:r .\SeedData\Script.CategoriesSeedData.sql     -- 3. Categories (no dependencies)
:r .\SeedData\Script.ProductsSeedData.sql       -- 4. Products (depends on Users, Categories)
:r .\SeedData\Script.ReviewsSeedData.sql        -- 5. Reviews (depends on Products, Users)
:r .\SeedData\Script.OfferRulesSeedData.sql     -- 6. OfferRules (depends on Categories)
```

Each script uses `SET IDENTITY_INSERT ON/OFF` and `MERGE` statements for idempotent, rerunnable deployments.

## Related Repositories

| Repo | Description |
|------|-------------|
| [nlkart](https://github.com/dlokanadham/nlkart) | React frontend |
| [nlkart-api](https://github.com/dlokanadham/nlkart-api) | Flask REST API backend |
| [nlkart-utils](https://github.com/dlokanadham/nlkart-utils) | Python utility scripts |
| [nlkart-trend-analyzer](https://github.com/dlokanadham/nlkart-trend-analyzer) | Analytics dashboard |
