CREATE TABLE [dbo].[Transactions]
(
    [TransactionId] INT            IDENTITY(1,1) NOT NULL,
    [UserId]        INT            NOT NULL,
    [OrderId]       INT            NULL,
    [Amount]        DECIMAL(18,2)  NOT NULL,
    [Type]          NVARCHAR(10)   NOT NULL,
    [BalanceAfter]  DECIMAL(18,2)  NOT NULL,
    [CreatedAt]     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED ([TransactionId]),
    CONSTRAINT [FK_Transactions_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId]),
    CONSTRAINT [FK_Transactions_Order] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Orders]([OrderId]),
    CONSTRAINT [CK_Transactions_Type] CHECK ([Type] IN ('Debit', 'Credit'))
);
