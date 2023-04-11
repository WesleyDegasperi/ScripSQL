ALTER DATABASE medsystem
SET COMPATIBILITY_LEVEL = 100
GO


USE medsystem;  
GO  
SELECT compatibility_level  
FROM sys.databases WHERE name = 'medsystem';  
GO  