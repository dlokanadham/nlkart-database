CREATE TABLE [dbo].[Notifications]
(
    [NotificationId] INT            IDENTITY(1,1) NOT NULL,
    [UserId]         INT            NOT NULL,
    [Title]          NVARCHAR(200)  NOT NULL,
    [Message]        NVARCHAR(1000) NOT NULL,
    [IsRead]         BIT            NOT NULL DEFAULT 0,
    [CreatedAt]      DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([NotificationId]),
    CONSTRAINT [FK_Notifications_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId])
);
