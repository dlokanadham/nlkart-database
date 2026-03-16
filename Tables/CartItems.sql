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
