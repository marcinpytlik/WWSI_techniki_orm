/*
 ORM Shop: bootstrap laboratory only, run as instance administrator (sa).
 NEVER run from ASP.NET Core application.
 Execute using SSMS with SQLCMD Mode OFF; run this file as whole.
 Credentials are created separately by 02-create-logins.sql (SQLCMD variables).
*/
USE master;
GO
IF DB_ID(N'OrmShop') IS NULL CREATE DATABASE OrmShop;
GO
ALTER DATABASE OrmShop SET COMPATIBILITY_LEVEL = 160;
GO
USE OrmShop;
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name=N'shop')
    EXEC(N'CREATE SCHEMA shop AUTHORIZATION dbo;');
GO
PRINT 'OrmShop database and shop schema ready';
GO
