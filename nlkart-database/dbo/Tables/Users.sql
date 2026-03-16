CREATE TABLE [dbo].[Users]
(
	[UserId]        INT             IDENTITY (1, 1) NOT NULL,
	[Email]         NVARCHAR (100)  NOT NULL,
	[Username]      NVARCHAR (50)   NOT NULL,
	[PasswordHash]  NVARCHAR (200)  NOT NULL,
	[FirstName]     NVARCHAR (50)   NOT NULL,
	[LastName]      NVARCHAR (50)   NOT NULL,
	[RoleId]        INT             NOT NULL,
	[WalletBalance] DECIMAL (18, 2) NOT NULL DEFAULT (0),
	[IsActive]      BIT             NOT NULL DEFAULT (1),
	[CreatedAt]     DATETIME2 (7)   NOT NULL DEFAULT (SYSUTCDATETIME()),
	[UpdatedAt]     DATETIME2 (7)   NOT NULL DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC),
	CONSTRAINT [UQ_Users_Email] UNIQUE NONCLUSTERED ([Email] ASC),
	CONSTRAINT [UQ_Users_Username] UNIQUE NONCLUSTERED ([Username] ASC),
	CONSTRAINT [FK_Users_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleId])
);

GO

CREATE NONCLUSTERED INDEX [IX_Users_RoleId]
	ON [dbo].[Users] ([RoleId] ASC);
