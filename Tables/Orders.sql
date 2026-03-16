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
