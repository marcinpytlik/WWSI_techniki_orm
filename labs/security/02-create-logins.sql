/*
 Run by ADMINISTRATOR in SSMS SQLCMD MODE.
 Set variables via :setvar lines below BEFORE execution, or use a secure
 sqlcmd -v injection from environment. NEVER commit actual passwords.
 SQLCMD MODE REQUIRED; do not execute using a regular query window.
 Database/schema must be created using 01-bootstrap.sql first.
 Passwords in editor history/command line may be exposed: keep this for an
 isolated local training instance. For production use managed identities
 / secret stores and an approved provisioning process.
*/
:setvar AppPassword "CHANGE_ME_TO_RANDOM_STRONG_APP_PASSWORD"
:setvar DeployPassword "CHANGE_ME_TO_RANDOM_STRONG_DEPLOY_PASSWORD"

USE master;
GO
IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'orm_shop_app')
    CREATE LOGIN orm_shop_app WITH PASSWORD = N'$(AppPassword)', CHECK_POLICY = ON;
GO
IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'orm_shop_deploy')
    CREATE LOGIN orm_shop_deploy WITH PASSWORD = N'$(DeployPassword)', CHECK_POLICY = ON;
GO
USE OrmShop;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N'orm_shop_app')
    CREATE USER orm_shop_app FOR LOGIN orm_shop_app;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N'orm_shop_deploy')
    CREATE USER orm_shop_deploy FOR LOGIN orm_shop_deploy;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N'role_shop_runtime')
    CREATE ROLE role_shop_runtime AUTHORIZATION dbo;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N'role_shop_deploy')
    CREATE ROLE role_shop_deploy AUTHORIZATION dbo;
GO
ALTER ROLE role_shop_runtime ADD MEMBER orm_shop_app;
ALTER ROLE role_shop_deploy ADD MEMBER orm_shop_deploy;
GO
/* App: data access only for the shop schema, never ALTER/CONTROL/CREATE. */
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::shop TO role_shop_runtime;
GO
/* EF migrations: DDL limited to shop plus database CREATE TABLE and migration
   history. Nontrivial migration (ALTER INDEX etc.) may require additional,
   temporary, reviewed permissions — grant only when justified. */
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE FUNCTION, CREATE TYPE TO role_shop_deploy;
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::shop TO role_shop_deploy;
GO
/* We configure EF migration history in shop.__EFMigrationsHistory;
   schema owner is dbo, NOT the deployment principal. */
PRINT 'Users and roles created. Verify access before first migration.';
GO
