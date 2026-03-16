CREATE TABLE [dbo].[CartItems]
(
	[CartItemId] INT           IDENTITY (1, 1) NOT NULL,
	[UserId]     INT           NOT NULL,
	[ProductId]  INT           NOT NULL,
	[Quantity]   INT           NOT NULL DEFAULT (1),
	[AddedAt]    DATETIME2 (7) NOT NULL DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_CartItems] PRIMARY KEY CLUSTERED ([CartItemId] ASC),
	CONSTRAINT [FK_CartItems_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId]),
	CONSTRAINT [FK_CartItems_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products] ([ProductId]),
	CONSTRAINT [UQ_CartItems_UserProduct] UNIQUE NONCLUSTERED ([UserId] ASC, [ProductId] ASC)
);

GO

CREATE NONCLUSTERED INDEX [IX_CartItems_UserId]
	ON [dbo].[CartItems] ([UserId] ASC);
