/*
    Seed Data: Offer Rules
    5 discount rules for various categories and seasons
*/
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
