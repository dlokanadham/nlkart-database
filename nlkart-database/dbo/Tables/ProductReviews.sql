CREATE TABLE [dbo].[ProductReviews]
(
	[ReviewId]  INT            IDENTITY (1, 1) NOT NULL,
	[ProductId] INT            NOT NULL,
	[UserId]    INT            NOT NULL,
	[Rating]    INT            NOT NULL,
	[Comment]   NVARCHAR (1000) NULL,
	[CreatedAt] DATETIME2 (7)  NOT NULL DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_ProductReviews] PRIMARY KEY CLUSTERED ([ReviewId] ASC),
	CONSTRAINT [FK_ProductReviews_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products] ([ProductId]),
	CONSTRAINT [FK_ProductReviews_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId]),
	CONSTRAINT [CK_ProductReviews_Rating] CHECK ([Rating] >= 1 AND [Rating] <= 5),
	CONSTRAINT [UQ_ProductReviews_UserProduct] UNIQUE NONCLUSTERED ([UserId] ASC, [ProductId] ASC)
);

GO

CREATE NONCLUSTERED INDEX [IX_ProductReviews_ProductId]
	ON [dbo].[ProductReviews] ([ProductId] ASC);
