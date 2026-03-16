CREATE TABLE [dbo].[Users]
(
    [UserId]        INT            IDENTITY(1,1) NOT NULL,
    [Email]         NVARCHAR(255)  NOT NULL,
    [Username]      NVARCHAR(100)  NOT NULL,
    [PasswordHash]  NVARCHAR(255)  NOT NULL,
    [FirstName]     NVARCHAR(100)  NOT NULL,
    [LastName]      NVARCHAR(100)  NOT NULL,
    [RoleId]        INT            NOT NULL,
    [WalletBalance] DECIMAL(18,2)  NOT NULL DEFAULT 0,
    [IsActive]      BIT            NOT NULL DEFAULT 1,
    [CreatedAt]     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt]     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId]),
    CONSTRAINT [UQ_Users_Email] UNIQUE ([Email]),
    CONSTRAINT [UQ_Users_Username] UNIQUE ([Username]),
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles]([RoleId])
);
