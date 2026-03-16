CREATE TABLE [dbo].[Notifications]
(
	[NotificationId] INT            IDENTITY (1, 1) NOT NULL,
	[UserId]         INT            NOT NULL,
	[Title]          NVARCHAR (200) NOT NULL,
	[Message]        NVARCHAR (1000) NOT NULL,
	[IsRead]         BIT            NOT NULL DEFAULT (0),
	[CreatedAt]      DATETIME2 (7)  NOT NULL DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([NotificationId] ASC),
	CONSTRAINT [FK_Notifications_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
);

GO

CREATE NONCLUSTERED INDEX [IX_Notifications_UserId_IsRead]
	ON [dbo].[Notifications] ([UserId] ASC, [IsRead] ASC);
