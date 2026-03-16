/*
    Seed Data: Categories
    5 product categories for nlkart
*/
SET IDENTITY_INSERT [dbo].[Categories] ON;

MERGE INTO [dbo].[Categories] AS target
USING (VALUES
    (1, 'Electronics',      'Gadgets, phones, laptops and accessories',        'https://picsum.photos/seed/electronics/400/300'),
    (2, 'Clothing',         'Men and women fashion, casual and formal wear',   'https://picsum.photos/seed/clothing/400/300'),
    (3, 'Books',            'Fiction, non-fiction, academic and more',          'https://picsum.photos/seed/books/400/300'),
    (4, 'Home & Kitchen',   'Appliances, furniture, decor and cookware',       'https://picsum.photos/seed/kitchen/400/300'),
    (5, 'Sports',           'Fitness equipment, outdoor gear and sportswear',  'https://picsum.photos/seed/sports/400/300')
) AS source ([CategoryId], [Name], [Description], [ImageUrl])
ON target.[CategoryId] = source.[CategoryId]
WHEN NOT MATCHED THEN
    INSERT ([CategoryId], [Name], [Description], [ImageUrl])
    VALUES (source.[CategoryId], source.[Name], source.[Description], source.[ImageUrl]);

SET IDENTITY_INSERT [dbo].[Categories] OFF;
