CREATE TABLE [dbo].[ProductReviews]
(
    [ReviewId]  INT            IDENTITY(1,1) NOT NULL,
    [ProductId] INT            NOT NULL,
    [UserId]    INT            NOT NULL,
    [Rating]    INT            NOT NULL,
    [Comment]   NVARCHAR(1000) NULL,
    [CreatedAt] DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_ProductReviews] PRIMARY KEY CLUSTERED ([ReviewId]),
    CONSTRAINT [FK_ProductReviews_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products]([ProductId]),
    CONSTRAINT [FK_ProductReviews_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [CK_ProductReviews_Rating] CHECK ([Rating] BETWEEN 1 AND 5),
    CONSTRAINT [UQ_ProductReviews_UserProduct] UNIQUE ([UserId], [ProductId])
);
