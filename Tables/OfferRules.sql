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
