CREATE TABLE [dbo].[Categories]
(
    [CategoryId]  INT           IDENTITY(1,1) NOT NULL,
    [Name]        NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(500) NULL,
    [ImageUrl]    NVARCHAR(500) NULL,
    [IsActive]    BIT           NOT NULL DEFAULT 1,
    CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryId]),
    CONSTRAINT [UQ_Categories_Name] UNIQUE ([Name])
);
