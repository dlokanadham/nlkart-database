/*
    nlkart Database - Full Deployment Script
    Run this against your SQL Server to create all tables and seed data.

    Usage: sqlcmd -S localhost -E -i deploy_all.sql
    Or run from SSMS after selecting/creating the nlkart_db database.
*/

-- Create database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'nlkart_db')
    CREATE DATABASE [nlkart_db];
GO

USE [nlkart_db];
GO

-- =============================================
-- DROP EXISTING TABLES (in reverse FK order)
-- =============================================
IF OBJECT_ID('dbo.OfferRules', 'U') IS NOT NULL DROP TABLE [dbo].[OfferRules];
IF OBJECT_ID('dbo.Notifications', 'U') IS NOT NULL DROP TABLE [dbo].[Notifications];
IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL DROP TABLE [dbo].[Transactions];
IF OBJECT_ID('dbo.ProductReviews', 'U') IS NOT NULL DROP TABLE [dbo].[ProductReviews];
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE [dbo].[OrderItems];
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE [dbo].[Orders];
IF OBJECT_ID('dbo.CartItems', 'U') IS NOT NULL DROP TABLE [dbo].[CartItems];
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE [dbo].[Products];
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE [dbo].[Categories];
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE [dbo].[Users];
IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL DROP TABLE [dbo].[Roles];
GO

-- =============================================
-- CREATE TABLES
-- =============================================

CREATE TABLE [dbo].[Roles]
(
    [RoleId]      INT           IDENTITY(1,1) NOT NULL,
    [RoleName]    NVARCHAR(50)  NOT NULL,
    [Description] NVARCHAR(200) NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([RoleId]),
    CONSTRAINT [UQ_Roles_RoleName] UNIQUE ([RoleName])
);
GO

CREATE TABLE [dbo].[Users]
(
    [UserId]        INT            IDENTITY(1,1) NOT NULL,
    [Email]         NVARCHAR(255)  NOT NULL,
    [Username]      NVARCHAR(100)  NOT NULL,
    [PasswordHash]  NVARCHAR(255)  NOT NULL,
    [FirstName]     NVARCHAR(100)  NOT NULL,
    [LastName]      NVARCHAR(100)  NOT NULL,
    [RoleId]        INT            NOT NULL,
    [WalletBalance] DECIMAL(18,2)  NOT NULL DEFAULT 0,
    [IsActive]      BIT            NOT NULL DEFAULT 1,
    [CreatedAt]     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt]     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId]),
    CONSTRAINT [UQ_Users_Email] UNIQUE ([Email]),
    CONSTRAINT [UQ_Users_Username] UNIQUE ([Username]),
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles]([RoleId])
);
GO

CREATE TABLE [dbo].[Categories]
(
    [CategoryId]  INT           IDENTITY(1,1) NOT NULL,
    [Name]        NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(500) NULL,
    [ImageUrl]    NVARCHAR(500) NULL,
    [IsActive]    BIT           NOT NULL DEFAULT 1,
    CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryId]),
    CONSTRAINT [UQ_Categories_Name] UNIQUE ([Name])
);
GO

CREATE TABLE [dbo].[Products]
(
    [ProductId]      INT            IDENTITY(1,1) NOT NULL,
    [DealerId]       INT            NOT NULL,
    [CategoryId]     INT            NOT NULL,
    [Name]           NVARCHAR(200)  NOT NULL,
    [Description]    NVARCHAR(2000) NULL,
    [Price]          DECIMAL(18,2)  NOT NULL,
    [OriginalPrice]  DECIMAL(18,2)  NOT NULL,
    [ImageUrl]       NVARCHAR(500)  NULL,
    [Stock]          INT            NOT NULL DEFAULT 0,
    [ApprovalStatus] NVARCHAR(20)   NOT NULL DEFAULT 'Pending',
    [ReviewerNotes]  NVARCHAR(1000) NULL,
    [ReviewedBy]     INT            NULL,
    [ReviewedAt]     DATETIME2      NULL,
    [AverageRating]  DECIMAL(3,2)   NOT NULL DEFAULT 0,
    [DiscountPercent] DECIMAL(5,2)  NOT NULL DEFAULT 0,
    [CreatedAt]      DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt]      DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductId]),
    CONSTRAINT [FK_Products_Dealer] FOREIGN KEY ([DealerId]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [FK_Products_Category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories]([CategoryId]),
    CONSTRAINT [FK_Products_Reviewer] FOREIGN KEY ([ReviewedBy]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [CK_Products_ApprovalStatus] CHECK ([ApprovalStatus] IN ('Pending', 'Approved', 'Rejected'))
);
GO

CREATE TABLE [dbo].[CartItems]
(
    [CartItemId] INT       IDENTITY(1,1) NOT NULL,
    [UserId]     INT       NOT NULL,
    [ProductId]  INT       NOT NULL,
    [Quantity]   INT       NOT NULL DEFAULT 1,
    [AddedAt]    DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_CartItems] PRIMARY KEY CLUSTERED ([CartItemId]),
    CONSTRAINT [FK_CartItems_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [FK_CartItems_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products]([ProductId]),
    CONSTRAINT [UQ_CartItems_UserProduct] UNIQUE ([UserId], [ProductId])
);
GO

CREATE TABLE [dbo].[Orders]
(
    [OrderId]         INT            IDENTITY(1,1) NOT NULL,
    [UserId]          INT            NOT NULL,
    [TotalAmount]     DECIMAL(18,2)  NOT NULL,
    [DiscountAmount]  DECIMAL(18,2)  NOT NULL DEFAULT 0,
    [OrderStatus]     NVARCHAR(20)   NOT NULL DEFAULT 'Placed',
    [ShippingAddress] NVARCHAR(500)  NULL,
    [CreatedAt]       DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderId]),
    CONSTRAINT [FK_Orders_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [CK_Orders_Status] CHECK ([OrderStatus] IN ('Placed', 'Shipped', 'Delivered', 'Cancelled'))
);
GO

CREATE TABLE [dbo].[OrderItems]
(
    [OrderItemId] INT           IDENTITY(1,1) NOT NULL,
    [OrderId]     INT           NOT NULL,
    [ProductId]   INT           NOT NULL,
    [Quantity]    INT           NOT NULL,
    [UnitPrice]   DECIMAL(18,2) NOT NULL,
    CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED ([OrderItemId]),
    CONSTRAINT [FK_OrderItems_Order] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Orders]([OrderId]),
    CONSTRAINT [FK_OrderItems_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products]([ProductId])
);
GO

CREATE TABLE [dbo].[ProductReviews]
(
    [ReviewId]  INT            IDENTITY(1,1) NOT NULL,
    [ProductId] INT            NOT NULL,
    [UserId]    INT            NOT NULL,
    [Rating]    INT            NOT NULL,
    [Comment]   NVARCHAR(1000) NULL,
    [CreatedAt] DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_ProductReviews] PRIMARY KEY CLUSTERED ([ReviewId]),
    CONSTRAINT [FK_ProductReviews_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products]([ProductId]),
    CONSTRAINT [FK_ProductReviews_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [CK_ProductReviews_Rating] CHECK ([Rating] BETWEEN 1 AND 5),
    CONSTRAINT [UQ_ProductReviews_UserProduct] UNIQUE ([UserId], [ProductId])
);
GO

CREATE TABLE [dbo].[Transactions]
(
    [TransactionId] INT            IDENTITY(1,1) NOT NULL,
    [UserId]        INT            NOT NULL,
    [OrderId]       INT            NULL,
    [Amount]        DECIMAL(18,2)  NOT NULL,
    [Type]          NVARCHAR(10)   NOT NULL,
    [BalanceAfter]  DECIMAL(18,2)  NOT NULL,
    [CreatedAt]     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED ([TransactionId]),
    CONSTRAINT [FK_Transactions_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [FK_Transactions_Order] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Orders]([OrderId]),
    CONSTRAINT [CK_Transactions_Type] CHECK ([Type] IN ('Debit', 'Credit'))
);
GO

CREATE TABLE [dbo].[Notifications]
(
    [NotificationId] INT            IDENTITY(1,1) NOT NULL,
    [UserId]         INT            NOT NULL,
    [Title]          NVARCHAR(200)  NOT NULL,
    [Message]        NVARCHAR(1000) NOT NULL,
    [IsRead]         BIT            NOT NULL DEFAULT 0,
    [CreatedAt]      DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([NotificationId]),
    CONSTRAINT [FK_Notifications_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId])
);
GO

CREATE TABLE [dbo].[OfferRules]
(
    [OfferId]         INT           IDENTITY(1,1) NOT NULL,
    [Name]            NVARCHAR(200) NOT NULL,
    [DiscountPercent] DECIMAL(5,2)  NOT NULL,
    [CategoryId]      INT           NULL,
    [SeasonTag]       NVARCHAR(50)  NULL,
    [MinPrice]        DECIMAL(18,2) NULL,
    [MaxPrice]        DECIMAL(18,2) NULL,
    [IsActive]        BIT           NOT NULL DEFAULT 1,
    [StartDate]       DATE          NULL,
    [EndDate]         DATE          NULL,
    CONSTRAINT [PK_OfferRules] PRIMARY KEY CLUSTERED ([OfferId]),
    CONSTRAINT [FK_OfferRules_Category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories]([CategoryId])
);
GO

-- =============================================
-- SEED DATA
-- =============================================

-- ROLES
SET IDENTITY_INSERT [dbo].[Roles] ON;
INSERT INTO [dbo].[Roles] ([RoleId], [RoleName], [Description]) VALUES
    (1, 'Administrator', 'Full system access, user management'),
    (2, 'Dealer', 'Can add and manage products'),
    (3, 'Reviewer', 'Reviews and approves/rejects dealer products'),
    (4, 'EndUser', 'Browse, purchase products, write reviews'),
    (5, 'SupportAgent', 'View orders, products, handle customer issues');
SET IDENTITY_INSERT [dbo].[Roles] OFF;
GO

-- USERS (Password: Testing@123 for all)
SET IDENTITY_INSERT [dbo].[Users] ON;
INSERT INTO [dbo].[Users] ([UserId], [Email], [Username], [PasswordHash], [FirstName], [LastName], [RoleId], [WalletBalance], [IsActive]) VALUES
    (1, 'admin@nlkart.com',     'admin',     '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Arjun',   'Kumar',  1, 0.00,     1),
    (2, 'reviewer1@nlkart.com', 'reviewer1', '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Priya',   'Sharma', 3, 0.00,     1),
    (3, 'reviewer2@nlkart.com', 'reviewer2', '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Rahul',   'Verma',  3, 0.00,     1),
    (4, 'dealer1@nlkart.com',   'dealer1',   '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Sneha',   'Patel',  2, 0.00,     1),
    (5, 'dealer2@nlkart.com',   'dealer2',   '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Vikram',  'Singh',  2, 0.00,     1),
    (6, 'user1@nlkart.com',     'user1',     '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Ananya',  'Reddy',  4, 10000.00, 1),
    (7, 'user2@nlkart.com',     'user2',     '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Karthik', 'Nair',   4, 10000.00, 1),
    (8, 'user3@nlkart.com',     'user3',     '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Divya',   'Gupta',  4, 10000.00, 1),
    (9, 'support1@nlkart.com',  'support1',  '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Manoj',   'Tiwari', 5, 0.00,     1);
SET IDENTITY_INSERT [dbo].[Users] OFF;
GO

-- CATEGORIES
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT INTO [dbo].[Categories] ([CategoryId], [Name], [Description], [ImageUrl]) VALUES
    (1, 'Electronics',    'Gadgets, phones, laptops and accessories',       'https://via.placeholder.com/300x200?text=Electronics'),
    (2, 'Clothing',       'Men and women fashion, casual and formal wear',  'https://via.placeholder.com/300x200?text=Clothing'),
    (3, 'Books',          'Fiction, non-fiction, academic and more',         'https://via.placeholder.com/300x200?text=Books'),
    (4, 'Home & Kitchen', 'Appliances, furniture, decor and cookware',      'https://via.placeholder.com/300x200?text=Home+Kitchen'),
    (5, 'Sports',         'Fitness equipment, outdoor gear and sportswear', 'https://via.placeholder.com/300x200?text=Sports');
SET IDENTITY_INSERT [dbo].[Categories] OFF;
GO

-- PRODUCTS
SET IDENTITY_INSERT [dbo].[Products] ON;
INSERT INTO [dbo].[Products] ([ProductId], [DealerId], [CategoryId], [Name], [Description], [Price], [OriginalPrice], [ImageUrl], [Stock], [ApprovalStatus], [ReviewerNotes], [ReviewedBy], [ReviewedAt], [AverageRating], [DiscountPercent]) VALUES
    (1,  4, 1, 'Wireless Bluetooth Headphones',  'Premium noise-cancelling headphones with 30hr battery life', 2499.00, 3499.00, 'https://via.placeholder.com/300x300?text=Headphones', 50,  'Approved', 'Good quality product', 2, GETUTCDATE(), 4.20, 0),
    (2,  4, 1, 'USB-C Fast Charger 65W',         'GaN charger compatible with laptops and phones',            1299.00, 1799.00, 'https://via.placeholder.com/300x300?text=Charger',    100, 'Approved', 'Verified specs',       2, GETUTCDATE(), 4.50, 0),
    (3,  4, 1, 'Mechanical Gaming Keyboard',      'RGB backlit with blue switches, full-size layout',          3999.00, 4999.00, 'https://via.placeholder.com/300x300?text=Keyboard',   30,  'Approved', NULL,                   3, GETUTCDATE(), 4.00, 0),
    (4,  5, 1, 'Smartphone Stand Holder',         'Adjustable aluminum desk stand for phones and tablets',     599.00,  899.00,  'https://via.placeholder.com/300x300?text=Stand',      200, 'Approved', 'Nice product',         2, GETUTCDATE(), 3.80, 0),
    (5,  5, 2, 'Cotton Casual T-Shirt',           'Premium cotton, available in multiple colors',              799.00,  1299.00, 'https://via.placeholder.com/300x300?text=TShirt',     150, 'Approved', 'Good fabric quality',  2, GETUTCDATE(), 4.30, 0),
    (6,  5, 2, 'Slim Fit Denim Jeans',            'Stretchable denim, dark blue wash',                        1999.00, 2499.00, 'https://via.placeholder.com/300x300?text=Jeans',      80,  'Approved', NULL,                   3, GETUTCDATE(), 4.10, 0),
    (7,  4, 2, 'Running Shoes - Lightweight',     'Breathable mesh, cushioned sole for daily running',        2999.00, 3999.00, 'https://via.placeholder.com/300x300?text=Shoes',      60,  'Approved', 'Approved',             2, GETUTCDATE(), 4.60, 0),
    (8,  4, 3, 'Clean Code by Robert C. Martin',  'A handbook of agile software craftsmanship',               499.00,  650.00,  'https://via.placeholder.com/300x300?text=CleanCode',  40,  'Approved', 'Classic book',         3, GETUTCDATE(), 4.80, 0),
    (9,  4, 3, 'The Pragmatic Programmer',        'Your journey to mastery, 20th anniversary edition',        599.00,  799.00,  'https://via.placeholder.com/300x300?text=PragProg',   35,  'Approved', NULL,                   2, GETUTCDATE(), 4.70, 0),
    (10, 5, 4, 'Stainless Steel Water Bottle',    '1 liter insulated bottle, keeps drinks cold for 24hrs',    699.00,  999.00,  'https://via.placeholder.com/300x300?text=Bottle',     120, 'Approved', 'Good quality',         2, GETUTCDATE(), 4.40, 0),
    (11, 5, 4, 'Non-Stick Frying Pan 26cm',       'Premium coating, induction compatible',                    1199.00, 1599.00, 'https://via.placeholder.com/300x300?text=Pan',        70,  'Approved', NULL,                   3, GETUTCDATE(), 4.00, 0),
    (12, 4, 5, 'Yoga Mat - 6mm Premium',          'Anti-slip surface, includes carry strap',                  899.00,  1299.00, 'https://via.placeholder.com/300x300?text=YogaMat',    90,  'Approved', 'Good for beginners',   2, GETUTCDATE(), 4.30, 0),
    (13, 4, 5, 'Resistance Bands Set (5 Pack)',   'Different resistance levels with door anchor',             499.00,  799.00,  'https://via.placeholder.com/300x300?text=Bands',      110, 'Approved', NULL,                   3, GETUTCDATE(), 4.10, 0),
    (14, 4, 1, 'Wireless Gaming Mouse',           '16000 DPI, RGB lighting, ergonomic design',               1799.00, 2299.00, 'https://via.placeholder.com/300x300?text=Mouse',      45,  'Pending',  NULL, NULL, NULL, 0, 0),
    (15, 5, 2, 'Winter Jacket - Quilted',         'Water-resistant, warm padded jacket for winter',           3499.00, 4999.00, 'https://via.placeholder.com/300x300?text=Jacket',     25,  'Pending',  NULL, NULL, NULL, 0, 0),
    (16, 4, 4, 'Smart LED Desk Lamp',             'Touch control, adjustable brightness and color temp',      1499.00, 1999.00, 'https://via.placeholder.com/300x300?text=Lamp',       55,  'Pending',  NULL, NULL, NULL, 0, 0),
    (17, 5, 5, 'Cricket Bat - English Willow',    'Grade A willow, full size, ready to play',                 4999.00, 6499.00, 'https://via.placeholder.com/300x300?text=CricketBat', 20,  'Pending',  NULL, NULL, NULL, 0, 0),
    (18, 5, 1, 'Cheap Earbuds',                   'Basic earbuds with mic',                                  99.00,   199.00,  'https://via.placeholder.com/300x300?text=Earbuds',    500, 'Rejected', 'Product description too vague, price suspiciously low',    2, GETUTCDATE(), 0, 0),
    (19, 4, 3, 'Unknown Author Book',             'A book about something',                                  150.00,  250.00,  'https://via.placeholder.com/300x300?text=Book',       100, 'Rejected', 'Missing ISBN, author details, and proper description',     3, GETUTCDATE(), 0, 0),
    (20, 5, 4, 'Magic Kitchen Gadget',            'Does everything in the kitchen',                          9999.00, 9999.00, 'https://via.placeholder.com/300x300?text=Gadget',     10,  'Rejected', 'Unrealistic claims, no specifications provided',           2, GETUTCDATE(), 0, 0);
SET IDENTITY_INSERT [dbo].[Products] OFF;
GO

-- PRODUCT REVIEWS
SET IDENTITY_INSERT [dbo].[ProductReviews] ON;
INSERT INTO [dbo].[ProductReviews] ([ReviewId], [ProductId], [UserId], [Rating], [Comment]) VALUES
    (1,  1, 6, 5, 'Amazing headphones! Noise cancellation is superb.'),
    (2,  1, 7, 4, 'Good sound quality but a bit heavy.'),
    (3,  2, 6, 5, 'Fast charging, works great with my laptop.'),
    (4,  5, 7, 4, 'Comfortable t-shirt, fits well.'),
    (5,  7, 8, 5, 'Best running shoes I have ever owned!'),
    (6,  3, 6, 4, 'Nice keyboard, great tactile feedback.'),
    (7,  5, 8, 3, 'Decent but expected better material.'),
    (8,  8, 6, 5, 'Must-read for every developer!'),
    (9,  9, 7, 5, 'Great book, changed my perspective on coding.'),
    (10, 10, 6, 4, 'Perfect for daily use, keeps water cold all day.'),
    (11, 10, 7, 5, 'Great value for money.'),
    (12, 12, 7, 5, 'Excellent yoga mat, very comfortable.'),
    (13, 13, 8, 4, 'Good resistance bands for home workouts.');
SET IDENTITY_INSERT [dbo].[ProductReviews] OFF;
GO

-- OFFER RULES
SET IDENTITY_INSERT [dbo].[OfferRules] ON;
INSERT INTO [dbo].[OfferRules] ([OfferId], [Name], [DiscountPercent], [CategoryId], [SeasonTag], [MinPrice], [MaxPrice], [IsActive], [StartDate], [EndDate]) VALUES
    (1, 'Summer Clothing Sale',      15.00, 2, 'Summer',  NULL,    NULL,    1, '2026-04-01', '2026-06-30'),
    (2, 'Electronics Weekend Deal',  10.00, 1, NULL,      1000.00, 5000.00, 1, '2026-03-01', '2026-12-31'),
    (3, 'Books Clearance',           20.00, 3, NULL,      NULL,    500.00,  1, '2026-03-01', '2026-04-30'),
    (4, 'Sports Fitness Month',      12.00, 5, NULL,      NULL,    NULL,    1, '2026-01-01', '2026-03-31'),
    (5, 'Home Essentials Discount',   8.00, 4, NULL,      500.00,  2000.00, 0, NULL,         NULL);
SET IDENTITY_INSERT [dbo].[OfferRules] OFF;
GO

PRINT '============================================';
PRINT ' nlkart Database Deployment Complete!';
PRINT '============================================';
PRINT ' Roles:      5';
PRINT ' Users:      9 (admin, 2 reviewers, 2 dealers, 3 end users, 1 support)';
PRINT ' Categories: 5';
PRINT ' Products:   20 (13 approved, 4 pending, 3 rejected)';
PRINT ' Reviews:    13';
PRINT ' Offers:     5';
PRINT '============================================';
GO
