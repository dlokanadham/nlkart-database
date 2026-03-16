CREATE TABLE [dbo].[Orders]
(
	[OrderId]         INT             IDENTITY (1, 1) NOT NULL,
	[UserId]          INT             NOT NULL,
	[TotalAmount]     DECIMAL (18, 2) NOT NULL,
	[DiscountAmount]  DECIMAL (18, 2) NOT NULL DEFAULT (0),
	[OrderStatus]     NVARCHAR (20)   NOT NULL DEFAULT ('Placed'),
	[ShippingAddress] NVARCHAR (500)  NOT NULL,
	[CreatedAt]       DATETIME2 (7)   NOT NULL DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderId] ASC),
	CONSTRAINT [FK_Orders_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId]),
	CONSTRAINT [CK_Orders_OrderStatus] CHECK ([OrderStatus] IN ('Placed', 'Shipped', 'Delivered', 'Cancelled'))
);

GO

CREATE NONCLUSTERED INDEX [IX_Orders_UserId]
	ON [dbo].[Orders] ([UserId] ASC);

GO

CREATE NONCLUSTERED INDEX [IX_Orders_OrderStatus]
	ON [dbo].[Orders] ([OrderStatus] ASC);
