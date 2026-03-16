/*
    Seed Data: Products
    20 products: 13 approved, 4 pending, 3 rejected
    Across 5 categories, from 2 dealers (dealer1=UserId 4, dealer2=UserId 5)
*/
SET IDENTITY_INSERT [dbo].[Products] ON;

MERGE INTO [dbo].[Products] AS target
USING (VALUES
    -- Electronics (Dealer1 - Sneha) - Approved
    (1,  4, 1, 'Wireless Bluetooth Headphones',   'Premium noise-cancelling headphones with 30hr battery life', 2499.00, 3499.00, 'https://picsum.photos/seed/headphones/400/300',   50, 'Approved', 'Good quality product', 2, GETUTCDATE(), 4.2, 0),
    (2,  4, 1, 'USB-C Fast Charger 65W',          'GaN charger compatible with laptops and phones',            1299.00, 1799.00, 'https://picsum.photos/seed/charger/400/300',       100, 'Approved', 'Verified specs', 2, GETUTCDATE(), 4.5, 0),
    (3,  4, 1, 'Mechanical Gaming Keyboard',       'RGB backlit with blue switches, full-size layout',          3999.00, 4999.00, 'https://picsum.photos/seed/keyboard/400/300',      30, 'Approved', NULL, 3, GETUTCDATE(), 4.0, 0),
    (4,  5, 1, 'Smartphone Stand Holder',          'Adjustable aluminum desk stand for phones and tablets',     599.00,  899.00,  'https://picsum.photos/seed/phonestand/400/300',    200, 'Approved', 'Nice product', 2, GETUTCDATE(), 3.8, 0),

    -- Clothing (Dealer2 - Vikram) - Approved
    (5,  5, 2, 'Cotton Casual T-Shirt',            'Premium cotton, available in multiple colors',              799.00,  1299.00, 'https://picsum.photos/seed/tshirt/400/300',        150, 'Approved', 'Good fabric quality', 2, GETUTCDATE(), 4.3, 0),
    (6,  5, 2, 'Slim Fit Denim Jeans',             'Stretchable denim, dark blue wash',                        1999.00, 2499.00, 'https://picsum.photos/seed/jeans/400/300',         80,  'Approved', NULL, 3, GETUTCDATE(), 4.1, 0),
    (7,  4, 2, 'Running Shoes - Lightweight',       'Breathable mesh, cushioned sole for daily running',        2999.00, 3999.00, 'https://picsum.photos/seed/shoes/400/300',         60,  'Approved', 'Approved', 2, GETUTCDATE(), 4.6, 0),

    -- Books (Dealer1) - Approved
    (8,  4, 3, 'Clean Code by Robert C. Martin',    'A handbook of agile software craftsmanship',               499.00,  650.00,  'https://picsum.photos/seed/cleancode/400/300',     40,  'Approved', 'Classic book', 3, GETUTCDATE(), 4.8, 0),
    (9,  4, 3, 'The Pragmatic Programmer',          'Your journey to mastery, 20th anniversary edition',        599.00,  799.00,  'https://picsum.photos/seed/pragmatic/400/300',     35,  'Approved', NULL, 2, GETUTCDATE(), 4.7, 0),

    -- Home & Kitchen (Dealer2) - Approved
    (10, 5, 4, 'Stainless Steel Water Bottle',      '1 liter insulated bottle, keeps drinks cold for 24hrs',    699.00,  999.00,  'https://picsum.photos/seed/waterbottle/400/300',   120, 'Approved', 'Good quality', 2, GETUTCDATE(), 4.4, 0),
    (11, 5, 4, 'Non-Stick Frying Pan 26cm',         'Premium coating, induction compatible',                    1199.00, 1599.00, 'https://picsum.photos/seed/fryingpan/400/300',     70,  'Approved', NULL, 3, GETUTCDATE(), 4.0, 0),

    -- Sports (Dealer1) - Approved
    (12, 4, 5, 'Yoga Mat - 6mm Premium',            'Anti-slip surface, includes carry strap',                  899.00,  1299.00, 'https://picsum.photos/seed/yogamat/400/300',       90,  'Approved', 'Good for beginners', 2, GETUTCDATE(), 4.3, 0),
    (13, 4, 5, 'Resistance Bands Set (5 Pack)',     'Different resistance levels with door anchor',             499.00,  799.00,  'https://picsum.photos/seed/bands/400/300',         110, 'Approved', NULL, 3, GETUTCDATE(), 4.1, 0),

    -- PENDING products (awaiting review)
    (14, 4, 1, 'Wireless Gaming Mouse',            '16000 DPI, RGB lighting, ergonomic design',                1799.00, 2299.00, 'https://picsum.photos/seed/gamingmouse/400/300',   45,  'Pending',  NULL, NULL, NULL, 0, 0),
    (15, 5, 2, 'Winter Jacket - Quilted',           'Water-resistant, warm padded jacket for winter',           3499.00, 4999.00, 'https://picsum.photos/seed/jacket/400/300',        25,  'Pending',  NULL, NULL, NULL, 0, 0),
    (16, 4, 4, 'Smart LED Desk Lamp',              'Touch control, adjustable brightness and color temp',      1499.00, 1999.00, 'https://picsum.photos/seed/desklamp/400/300',      55,  'Pending',  NULL, NULL, NULL, 0, 0),
    (17, 5, 5, 'Cricket Bat - English Willow',      'Grade A willow, full size, ready to play',                 4999.00, 6499.00, 'https://picsum.photos/seed/cricketbat/400/300',    20,  'Pending',  NULL, NULL, NULL, 0, 0),

    -- REJECTED products
    (18, 5, 1, 'Cheap Earbuds',                    'Basic earbuds with mic',                                   99.00,   199.00,  'https://picsum.photos/seed/earbuds/400/300',       500, 'Rejected', 'Product description too vague, price suspiciously low', 2, GETUTCDATE(), 0, 0),
    (19, 4, 3, 'Unknown Author Book',              'A book about something',                                   150.00,  250.00,  'https://picsum.photos/seed/book/400/300',          100, 'Rejected', 'Missing ISBN, author details, and proper description', 3, GETUTCDATE(), 0, 0),
    (20, 5, 4, 'Magic Kitchen Gadget',             'Does everything in the kitchen',                           9999.00, 9999.00, 'https://picsum.photos/seed/gadget/400/300',        10,  'Rejected', 'Unrealistic claims, no specifications provided', 2, GETUTCDATE(), 0, 0)
) AS source ([ProductId], [DealerId], [CategoryId], [Name], [Description], [Price], [OriginalPrice], [ImageUrl], [Stock], [ApprovalStatus], [ReviewerNotes], [ReviewedBy], [ReviewedAt], [AverageRating], [DiscountPercent])
ON target.[ProductId] = source.[ProductId]
WHEN NOT MATCHED THEN
    INSERT ([ProductId], [DealerId], [CategoryId], [Name], [Description], [Price], [OriginalPrice], [ImageUrl], [Stock], [ApprovalStatus], [ReviewerNotes], [ReviewedBy], [ReviewedAt], [AverageRating], [DiscountPercent])
    VALUES (source.[ProductId], source.[DealerId], source.[CategoryId], source.[Name], source.[Description], source.[Price], source.[OriginalPrice], source.[ImageUrl], source.[Stock], source.[ApprovalStatus], source.[ReviewerNotes], source.[ReviewedBy], source.[ReviewedAt], source.[AverageRating], source.[DiscountPercent]);

SET IDENTITY_INSERT [dbo].[Products] OFF;
