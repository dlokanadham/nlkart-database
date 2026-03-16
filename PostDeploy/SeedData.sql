/*
    Post-Deployment Seed Data for nlkart
    Run this after deploying the DACPAC schema.
    Password for all users: Testing@123
    PasswordHash is bcrypt hash of Testing@123
*/

-- =============================================
-- ROLES
-- =============================================
SET IDENTITY_INSERT [dbo].[Roles] ON;

MERGE INTO [dbo].[Roles] AS target
USING (VALUES
    (1, 'Administrator', 'Full system access, user management'),
    (2, 'Dealer', 'Can add and manage products'),
    (3, 'Reviewer', 'Reviews and approves/rejects dealer products'),
    (4, 'EndUser', 'Browse, purchase products, write reviews'),
    (5, 'SupportAgent', 'View orders, products, handle customer issues')
) AS source ([RoleId], [RoleName], [Description])
ON target.[RoleId] = source.[RoleId]
WHEN NOT MATCHED THEN
    INSERT ([RoleId], [RoleName], [Description])
    VALUES (source.[RoleId], source.[RoleName], source.[Description]);

SET IDENTITY_INSERT [dbo].[Roles] OFF;

-- =============================================
-- USERS (Password: Testing@123 for all)
-- bcrypt hash: $2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2
-- =============================================
SET IDENTITY_INSERT [dbo].[Users] ON;

MERGE INTO [dbo].[Users] AS target
USING (VALUES
    (1, 'admin@nlkart.com',      'admin',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Arjun',   'Kumar',     1, 0.00,     1),
    (2, 'reviewer1@nlkart.com',  'reviewer1',  '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Priya',   'Sharma',    3, 0.00,     1),
    (3, 'reviewer2@nlkart.com',  'reviewer2',  '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Rahul',   'Verma',     3, 0.00,     1),
    (4, 'dealer1@nlkart.com',    'dealer1',    '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Sneha',   'Patel',     2, 0.00,     1),
    (5, 'dealer2@nlkart.com',    'dealer2',    '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Vikram',  'Singh',     2, 0.00,     1),
    (6, 'user1@nlkart.com',      'user1',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Ananya',  'Reddy',     4, 10000.00, 1),
    (7, 'user2@nlkart.com',      'user2',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Karthik', 'Nair',      4, 10000.00, 1),
    (8, 'user3@nlkart.com',      'user3',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Divya',   'Gupta',     4, 10000.00, 1),
    (9, 'support1@nlkart.com',   'support1',   '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Manoj',   'Tiwari',    5, 0.00,     1)
) AS source ([UserId], [Email], [Username], [PasswordHash], [FirstName], [LastName], [RoleId], [WalletBalance], [IsActive])
ON target.[UserId] = source.[UserId]
WHEN NOT MATCHED THEN
    INSERT ([UserId], [Email], [Username], [PasswordHash], [FirstName], [LastName], [RoleId], [WalletBalance], [IsActive])
    VALUES (source.[UserId], source.[Email], source.[Username], source.[PasswordHash], source.[FirstName], source.[LastName], source.[RoleId], source.[WalletBalance], source.[IsActive]);

SET IDENTITY_INSERT [dbo].[Users] OFF;

-- =============================================
-- CATEGORIES
-- =============================================
SET IDENTITY_INSERT [dbo].[Categories] ON;

MERGE INTO [dbo].[Categories] AS target
USING (VALUES
    (1, 'Electronics',      'Gadgets, phones, laptops and accessories',        'https://via.placeholder.com/300x200?text=Electronics'),
    (2, 'Clothing',         'Men and women fashion, casual and formal wear',   'https://via.placeholder.com/300x200?text=Clothing'),
    (3, 'Books',            'Fiction, non-fiction, academic and more',          'https://via.placeholder.com/300x200?text=Books'),
    (4, 'Home & Kitchen',   'Appliances, furniture, decor and cookware',       'https://via.placeholder.com/300x200?text=Home+Kitchen'),
    (5, 'Sports',           'Fitness equipment, outdoor gear and sportswear',  'https://via.placeholder.com/300x200?text=Sports')
) AS source ([CategoryId], [Name], [Description], [ImageUrl])
ON target.[CategoryId] = source.[CategoryId]
WHEN NOT MATCHED THEN
    INSERT ([CategoryId], [Name], [Description], [ImageUrl])
    VALUES (source.[CategoryId], source.[Name], source.[Description], source.[ImageUrl]);

SET IDENTITY_INSERT [dbo].[Categories] OFF;

-- =============================================
-- PRODUCTS (mix of Approved, Pending, Rejected)
-- =============================================
SET IDENTITY_INSERT [dbo].[Products] ON;

MERGE INTO [dbo].[Products] AS target
USING (VALUES
    -- Electronics (Dealer1 - Sneha) - Approved
    (1,  4, 1, 'Wireless Bluetooth Headphones',   'Premium noise-cancelling headphones with 30hr battery life', 2499.00, 3499.00, 'https://via.placeholder.com/300x300?text=Headphones',   50, 'Approved', 'Good quality product', 2, GETUTCDATE(), 4.2, 0),
    (2,  4, 1, 'USB-C Fast Charger 65W',          'GaN charger compatible with laptops and phones',            1299.00, 1799.00, 'https://via.placeholder.com/300x300?text=Charger',       100, 'Approved', 'Verified specs', 2, GETUTCDATE(), 4.5, 0),
    (3,  4, 1, 'Mechanical Gaming Keyboard',       'RGB backlit with blue switches, full-size layout',          3999.00, 4999.00, 'https://via.placeholder.com/300x300?text=Keyboard',      30, 'Approved', NULL, 3, GETUTCDATE(), 4.0, 0),
    (4,  5, 1, 'Smartphone Stand Holder',          'Adjustable aluminum desk stand for phones and tablets',     599.00,  899.00,  'https://via.placeholder.com/300x300?text=Stand',         200, 'Approved', 'Nice product', 2, GETUTCDATE(), 3.8, 0),

    -- Clothing (Dealer2 - Vikram) - Approved
    (5,  5, 2, 'Cotton Casual T-Shirt',            'Premium cotton, available in multiple colors',              799.00,  1299.00, 'https://via.placeholder.com/300x300?text=TShirt',        150, 'Approved', 'Good fabric quality', 2, GETUTCDATE(), 4.3, 0),
    (6,  5, 2, 'Slim Fit Denim Jeans',             'Stretchable denim, dark blue wash',                        1999.00, 2499.00, 'https://via.placeholder.com/300x300?text=Jeans',         80,  'Approved', NULL, 3, GETUTCDATE(), 4.1, 0),
    (7,  4, 2, 'Running Shoes - Lightweight',       'Breathable mesh, cushioned sole for daily running',        2999.00, 3999.00, 'https://via.placeholder.com/300x300?text=Shoes',         60,  'Approved', 'Approved', 2, GETUTCDATE(), 4.6, 0),

    -- Books (Dealer1) - Approved
    (8,  4, 3, 'Clean Code by Robert C. Martin',    'A handbook of agile software craftsmanship',               499.00,  650.00,  'https://via.placeholder.com/300x300?text=CleanCode',     40,  'Approved', 'Classic book', 3, GETUTCDATE(), 4.8, 0),
    (9,  4, 3, 'The Pragmatic Programmer',          'Your journey to mastery, 20th anniversary edition',        599.00,  799.00,  'https://via.placeholder.com/300x300?text=PragProg',      35,  'Approved', NULL, 2, GETUTCDATE(), 4.7, 0),

    -- Home & Kitchen (Dealer2) - Approved
    (10, 5, 4, 'Stainless Steel Water Bottle',      '1 liter insulated bottle, keeps drinks cold for 24hrs',    699.00,  999.00,  'https://via.placeholder.com/300x300?text=Bottle',        120, 'Approved', 'Good quality', 2, GETUTCDATE(), 4.4, 0),
    (11, 5, 4, 'Non-Stick Frying Pan 26cm',         'Premium coating, induction compatible',                    1199.00, 1599.00, 'https://via.placeholder.com/300x300?text=Pan',           70,  'Approved', NULL, 3, GETUTCDATE(), 4.0, 0),

    -- Sports (Dealer1) - Approved
    (12, 4, 5, 'Yoga Mat - 6mm Premium',            'Anti-slip surface, includes carry strap',                  899.00,  1299.00, 'https://via.placeholder.com/300x300?text=YogaMat',       90,  'Approved', 'Good for beginners', 2, GETUTCDATE(), 4.3, 0),
    (13, 4, 5, 'Resistance Bands Set (5 Pack)',     'Different resistance levels with door anchor',             499.00,  799.00,  'https://via.placeholder.com/300x300?text=Bands',         110, 'Approved', NULL, 3, GETUTCDATE(), 4.1, 0),

    -- PENDING products (awaiting review)
    (14, 4, 1, 'Wireless Gaming Mouse',            '16000 DPI, RGB lighting, ergonomic design',                1799.00, 2299.00, 'https://via.placeholder.com/300x300?text=Mouse',         45,  'Pending',  NULL, NULL, NULL, 0, 0),
    (15, 5, 2, 'Winter Jacket - Quilted',           'Water-resistant, warm padded jacket for winter',           3499.00, 4999.00, 'https://via.placeholder.com/300x300?text=Jacket',        25,  'Pending',  NULL, NULL, NULL, 0, 0),
    (16, 4, 4, 'Smart LED Desk Lamp',              'Touch control, adjustable brightness and color temp',      1499.00, 1999.00, 'https://via.placeholder.com/300x300?text=Lamp',          55,  'Pending',  NULL, NULL, NULL, 0, 0),
    (17, 5, 5, 'Cricket Bat - English Willow',      'Grade A willow, full size, ready to play',                 4999.00, 6499.00, 'https://via.placeholder.com/300x300?text=CricketBat',    20,  'Pending',  NULL, NULL, NULL, 0, 0),

    -- REJECTED products
    (18, 5, 1, 'Cheap Earbuds',                    'Basic earbuds with mic',                                   99.00,   199.00,  'https://via.placeholder.com/300x300?text=Earbuds',       500, 'Rejected', 'Product description too vague, price suspiciously low', 2, GETUTCDATE(), 0, 0),
    (19, 4, 3, 'Unknown Author Book',              'A book about something',                                   150.00,  250.00,  'https://via.placeholder.com/300x300?text=Book',          100, 'Rejected', 'Missing ISBN, author details, and proper description', 3, GETUTCDATE(), 0, 0),
    (20, 5, 4, 'Magic Kitchen Gadget',             'Does everything in the kitchen',                           9999.00, 9999.00, 'https://via.placeholder.com/300x300?text=Gadget',        10,  'Rejected', 'Unrealistic claims, no specifications provided', 2, GETUTCDATE(), 0, 0)
) AS source ([ProductId], [DealerId], [CategoryId], [Name], [Description], [Price], [OriginalPrice], [ImageUrl], [Stock], [ApprovalStatus], [ReviewerNotes], [ReviewedBy], [ReviewedAt], [AverageRating], [DiscountPercent])
ON target.[ProductId] = source.[ProductId]
WHEN NOT MATCHED THEN
    INSERT ([ProductId], [DealerId], [CategoryId], [Name], [Description], [Price], [OriginalPrice], [ImageUrl], [Stock], [ApprovalStatus], [ReviewerNotes], [ReviewedBy], [ReviewedAt], [AverageRating], [DiscountPercent])
    VALUES (source.[ProductId], source.[DealerId], source.[CategoryId], source.[Name], source.[Description], source.[Price], source.[OriginalPrice], source.[ImageUrl], source.[Stock], source.[ApprovalStatus], source.[ReviewerNotes], source.[ReviewedBy], source.[ReviewedAt], source.[AverageRating], source.[DiscountPercent]);

SET IDENTITY_INSERT [dbo].[Products] OFF;

-- =============================================
-- PRODUCT REVIEWS (for approved products)
-- =============================================
SET IDENTITY_INSERT [dbo].[ProductReviews] ON;

MERGE INTO [dbo].[ProductReviews] AS target
USING (VALUES
    (1,  1, 6, 5, 'Amazing headphones! Noise cancellation is superb.'),
    (2,  1, 7, 4, 'Good sound quality but a bit heavy.'),
    (3,  2, 6, 5, 'Fast charging, works great with my laptop.'),
    (4,  5, 7, 4, 'Comfortable t-shirt, fits well.'),
    (5,  5, 8, 5, 'Best running shoes I have ever owned!'),
    (6,  7, 6, 4, 'Nice quality for the price.'),
    (7,  7, 8, 3, 'Decent but expected better material.'),
    (8,  8, 6, 4, 'Must-read for every developer!'),
    (9,  8, 7, 5, 'Great book, changed my perspective on coding.'),
    (10, 9, 8, 5, 'Perfect for daily use, keeps water cold all day.'),
    (11, 10, 6, 4, 'Good value for money.'),
    (12, 12, 7, 5, 'Excellent yoga mat, very comfortable.'),
    (13, 12, 8, 4, 'Good resistance bands for home workouts.')
) AS source ([ReviewId], [ProductId], [UserId], [Rating], [Comment])
ON target.[ReviewId] = source.[ReviewId]
WHEN NOT MATCHED THEN
    INSERT ([ReviewId], [ProductId], [UserId], [Rating], [Comment])
    VALUES (source.[ReviewId], source.[ProductId], source.[UserId], source.[Rating], source.[Comment]);

SET IDENTITY_INSERT [dbo].[ProductReviews] OFF;

-- =============================================
-- OFFER RULES
-- =============================================
SET IDENTITY_INSERT [dbo].[OfferRules] ON;

MERGE INTO [dbo].[OfferRules] AS target
USING (VALUES
    (1, 'Summer Clothing Sale',      15.00, 2, 'Summer',  NULL,    NULL,    1, '2026-04-01', '2026-06-30'),
    (2, 'Electronics Weekend Deal',  10.00, 1, NULL,      1000.00, 5000.00, 1, '2026-03-01', '2026-12-31'),
    (3, 'Books Clearance',           20.00, 3, NULL,      NULL,    500.00,  1, '2026-03-01', '2026-04-30'),
    (4, 'Sports Fitness Month',      12.00, 5, NULL,      NULL,    NULL,    1, '2026-01-01', '2026-03-31'),
    (5, 'Home Essentials Discount',   8.00, 4, NULL,      500.00,  2000.00, 0, NULL,         NULL)
) AS source ([OfferId], [Name], [DiscountPercent], [CategoryId], [SeasonTag], [MinPrice], [MaxPrice], [IsActive], [StartDate], [EndDate])
ON target.[OfferId] = source.[OfferId]
WHEN NOT MATCHED THEN
    INSERT ([OfferId], [Name], [DiscountPercent], [CategoryId], [SeasonTag], [MinPrice], [MaxPrice], [IsActive], [StartDate], [EndDate])
    VALUES (source.[OfferId], source.[Name], source.[DiscountPercent], source.[CategoryId], source.[SeasonTag], source.[MinPrice], source.[MaxPrice], source.[IsActive], source.[StartDate], source.[EndDate]);

SET IDENTITY_INSERT [dbo].[OfferRules] OFF;

PRINT 'Seed data loaded successfully!';
PRINT 'Users: 9 (admin, 2 reviewers, 2 dealers, 3 end users, 1 support)';
PRINT 'Categories: 5';
PRINT 'Products: 20 (13 approved, 4 pending, 3 rejected)';
PRINT 'Reviews: 13';
PRINT 'Offer Rules: 5';
