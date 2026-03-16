/*
    Seed Data: Users
    Password for all users: Testing@123
    PasswordHash is bcrypt hash of Testing@123
    9 users: admin, 2 reviewers, 2 dealers, 3 end users, 1 support agent
*/
SET IDENTITY_INSERT [dbo].[Users] ON;

MERGE INTO [dbo].[Users] AS target
USING (VALUES
    (1, 'admin@nlkart.com',      'admin',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Arjun',   'Kumar',     1, 0.00,     1),
    (2, 'reviewer1@nlkart.com',  'reviewer1',  '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Priya',   'Sharma',    3, 0.00,     1),
    (3, 'reviewer2@nlkart.com',  'reviewer2',  '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Rahul',   'Verma',     3, 0.00,     1),
    (4, 'dealer1@nlkart.com',    'dealer1',    '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Sneha',   'Patel',     2, 0.00,     1),
    (5, 'dealer2@nlkart.com',    'dealer2',    '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Vikram',  'Singh',     2, 0.00,     1),
    (6, 'user1@nlkart.com',      'user1',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Ananya',  'Reddy',     4, 10000.00, 1),
    (7, 'user2@nlkart.com',      'user2',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Karthik', 'Nair',      4, 10000.00, 1),
    (8, 'user3@nlkart.com',      'user3',      '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Divya',   'Gupta',     4, 10000.00, 1),
    (9, 'support1@nlkart.com',   'support1',   '$2b$12$bHgtTtvDQggGjMFgU27M3ubc2V7LzcQ97ls6DZWzCmEo0FnkOMrG2', 'Manoj',   'Tiwari',    5, 0.00,     1)
) AS source ([UserId], [Email], [Username], [PasswordHash], [FirstName], [LastName], [RoleId], [WalletBalance], [IsActive])
ON target.[UserId] = source.[UserId]
WHEN NOT MATCHED THEN
    INSERT ([UserId], [Email], [Username], [PasswordHash], [FirstName], [LastName], [RoleId], [WalletBalance], [IsActive])
    VALUES (source.[UserId], source.[Email], source.[Username], source.[PasswordHash], source.[FirstName], source.[LastName], source.[RoleId], source.[WalletBalance], source.[IsActive]);

SET IDENTITY_INSERT [dbo].[Users] OFF;
