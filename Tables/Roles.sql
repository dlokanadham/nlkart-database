CREATE TABLE [dbo].[Roles]
(
    [RoleId]      INT           IDENTITY(1,1) NOT NULL,
    [RoleName]    NVARCHAR(50)  NOT NULL,
    [Description] NVARCHAR(200) NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([RoleId]),
    CONSTRAINT [UQ_Roles_RoleName] UNIQUE ([RoleName])
);
