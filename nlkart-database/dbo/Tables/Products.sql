CREATE TABLE [dbo].[Products]
(
	[ProductId]       INT             IDENTITY (1, 1) NOT NULL,
	[DealerId]        INT             NOT NULL,
	[CategoryId]      INT             NOT NULL,
	[Name]            NVARCHAR (200)  NOT NULL,
	[Description]     NVARCHAR (2000) NULL,
	[Price]           DECIMAL (18, 2) NOT NULL,
	[OriginalPrice]   DECIMAL (18, 2) NOT NULL,
	[ImageUrl]        NVARCHAR (500)  NULL,
	[Stock]           INT             NOT NULL DEFAULT (0),
	[ApprovalStatus]  NVARCHAR (20)   NOT NULL DEFAULT ('Pending'),
	[ReviewerNotes]   NVARCHAR (500)  NULL,
	[ReviewedBy]      INT             NULL,
	[ReviewedAt]      DATETIME2 (7)   NULL,
	[AverageRating]   DECIMAL (3, 2)  NOT NULL DEFAULT (0),
	[DiscountPercent] DECIMAL (5, 2)  NOT NULL DEFAULT (0),
	[CreatedAt]       DATETIME2 (7)   NOT NULL DEFAULT (SYSUTCDATETIME()),
	[UpdatedAt]       DATETIME2 (7)   NOT NULL DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductId] ASC),
	CONSTRAINT [FK_Products_DealerId] FOREIGN KEY ([DealerId]) REFERENCES [dbo].[Users] ([UserId]),
	CONSTRAINT [FK_Products_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([CategoryId]),
	CONSTRAINT [FK_Products_ReviewedBy] FOREIGN KEY ([ReviewedBy]) REFERENCES [dbo].[Users] ([UserId]),
	CONSTRAINT [CK_Products_ApprovalStatus] CHECK ([ApprovalStatus] IN ('Pending', 'Approved', 'Rejected'))
);

GO

CREATE NONCLUSTERED INDEX [IX_Products_DealerId]
	ON [dbo].[Products] ([DealerId] ASC);

GO

CREATE NONCLUSTERED INDEX [IX_Products_CategoryId]
	ON [dbo].[Products] ([CategoryId] ASC);

GO

CREATE NONCLUSTERED INDEX [IX_Products_ApprovalStatus]
	ON [dbo].[Products] ([ApprovalStatus] ASC);
