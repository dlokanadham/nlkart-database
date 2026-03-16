/*
    Seed Data: Roles
    5 roles for nlkart e-commerce platform
*/
SET IDENTITY_INSERT [dbo].[Roles] ON;

MERGE INTO [dbo].[Roles] AS target
USING (VALUES
    (1, 'Administrator', 'Full system access, user management'),
    (2, 'Dealer', 'Can add and manage products'),
    (3, 'Reviewer', 'Reviews and approves/rejects dealer products'),
    (4, 'EndUser', 'Browse, purchase products, write reviews'),
    (5, 'SupportAgent', 'View orders, products, handle customer issues')
) AS source ([RoleId], [RoleName], [Description])
ON target.[RoleId] = source.[RoleId]
WHEN NOT MATCHED THEN
    INSERT ([RoleId], [RoleName], [Description])
    VALUES (source.[RoleId], source.[RoleName], source.[Description]);

SET IDENTITY_INSERT [dbo].[Roles] OFF;
