CREATE TABLE [dbo].[Transactions]
(
	[TransactionId] INT             IDENTITY (1, 1) NOT NULL,
	[UserId]        INT             NOT NULL,
	[OrderId]       INT             NULL,
	[Amount]        DECIMAL (18, 2) NOT NULL,
	[Type]          NVARCHAR (10)   NOT NULL,
	[BalanceAfter]  DECIMAL (18, 2) NOT NULL,
	[CreatedAt]     DATETIME2 (7)   NOT NULL DEFAULT (SYSUTCDATETIME()),
	CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED ([TransactionId] ASC),
	CONSTRAINT [FK_Transactions_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId]),
	CONSTRAINT [FK_Transactions_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Orders] ([OrderId]),
	CONSTRAINT [CK_Transactions_Type] CHECK ([Type] IN ('Debit', 'Credit'))
);

GO

CREATE NONCLUSTERED INDEX [IX_Transactions_UserId]
	ON [dbo].[Transactions] ([UserId] ASC);
