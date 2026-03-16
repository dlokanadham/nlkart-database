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
