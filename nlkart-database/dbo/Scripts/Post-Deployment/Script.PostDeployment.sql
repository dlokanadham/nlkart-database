/*
    Post-Deployment Script for nlkart database
    Loads seed data in dependency order using SQLCMD :r includes
*/

PRINT '=== nlkart Post-Deployment: Loading Seed Data ===';

-- 1. Roles (no dependencies)
:r .\SeedData\Script.RolesSeedData.sql
PRINT '  Roles seeded.';

-- 2. Users (depends on Roles)
:r .\SeedData\Script.UsersSeedData.sql
PRINT '  Users seeded.';

-- 3. Categories (no dependencies)
:r .\SeedData\Script.CategoriesSeedData.sql
PRINT '  Categories seeded.';

-- 4. Products (depends on Users, Categories)
:r .\SeedData\Script.ProductsSeedData.sql
PRINT '  Products seeded.';

-- 5. Product Reviews (depends on Products, Users)
:r .\SeedData\Script.ReviewsSeedData.sql
PRINT '  Product Reviews seeded.';

-- 6. Offer Rules (depends on Categories)
:r .\SeedData\Script.OfferRulesSeedData.sql
PRINT '  Offer Rules seeded.';

PRINT '=== nlkart Post-Deployment Complete ===';
PRINT 'Users: 9 (admin, 2 reviewers, 2 dealers, 3 end users, 1 support)';
PRINT 'Categories: 5';
PRINT 'Products: 20 (13 approved, 4 pending, 3 rejected)';
PRINT 'Reviews: 13';
PRINT 'Offer Rules: 5';
