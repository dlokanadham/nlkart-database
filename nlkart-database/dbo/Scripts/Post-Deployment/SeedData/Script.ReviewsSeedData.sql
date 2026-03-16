/*
    Seed Data: Product Reviews
    13 reviews from end users on approved products
*/
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
