/*
 ORM Shop — VS Code / MSSQL extension, zwykły T-SQL (bez SQLCMD :setvar).
 TYLKO izolowany SQL Server na stanowisku studenta.
 Wykonaj jako sa; nigdy jako orm_shop_app.

 UWAGA: w tej wersji skryptu hasła podaje się na początku jako zmienne T-SQL.
 NIE zapisuj pliku po wpisaniu prawdziwych haseł i nie commituj ich.
 W środowiskach współdzielonych i produkcyjnych używaj zarządzanych sekretów
 oraz odrębnego procesu provisioningowego. Hasła nie mogą zawierać apostrofu;
 poniższa kontrola przerywa wykonanie, jeśli pozostały placeholdery.
*/
SET NOCOUNT ON;
DECLARE @AppPassword nvarchar(128) = N'CHANGE_ME_APP_PASSWORD';
DECLARE @DeployPassword nvarchar(128) = N'CHANGE_ME_DEPLOY_PASSWORD';

IF @AppPassword LIKE N'CHANGE_ME%' OR @DeployPassword LIKE N'CHANGE_ME%'
    THROW 51000, 'Wpisz indywidualne hasla w zmiennych T-SQL przed wykonaniem.', 1;
IF @AppPassword = @DeployPassword
    THROW 51001, 'Hasla app i deploy musza byc rozne.', 1;
IF LEN(@AppPassword) < 15 OR LEN(@DeployPassword) < 15
    THROW 51002, 'Hasla musza miec przynajmniej 15 znakow.', 1;
IF CHARINDEX(NCHAR(39), @AppPassword) > 0 OR CHARINDEX(NCHAR(39), @DeployPassword) > 0
    THROW 51003, 'W tej wersji instrukcji wybierz hasla bez apostrofu.', 1;

USE master;
IF DB_ID(N'OrmShop') IS NULL
    THROW 51004, 'Uruchom najpierw 01-bootstrap.sql.', 1;

DECLARE @sql nvarchar(max);
IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'orm_shop_app')
    SET @sql = N'CREATE LOGIN [orm_shop_app] WITH PASSWORD = N''' + REPLACE(@AppPassword, N'''', N'''''') + N''', CHECK_POLICY = ON;';
ELSE
    SET @sql = N'ALTER LOGIN [orm_shop_app] WITH PASSWORD = N''' + REPLACE(@AppPassword, N'''', N'''''') + N''', CHECK_POLICY = ON;';
EXEC sys.sp_executesql @sql;

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'orm_shop_deploy')
    SET @sql = N'CREATE LOGIN [orm_shop_deploy] WITH PASSWORD = N''' + REPLACE(@DeployPassword, N'''', N'''''') + N''', CHECK_POLICY = ON;';
ELSE
    SET @sql = N'ALTER LOGIN [orm_shop_deploy] WITH PASSWORD = N''' + REPLACE(@DeployPassword, N'''', N'''''') + N''', CHECK_POLICY = ON;';
EXEC sys.sp_executesql @sql;

/* Dynamic SQL keeps all operations in a single batch; USE in a dynamic batch
   changes context for subsequent statements only inside this batch. */
EXEC(N'
USE [OrmShop];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N''orm_shop_app'')
    CREATE USER [orm_shop_app] FOR LOGIN [orm_shop_app];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N''orm_shop_deploy'')
    CREATE USER [orm_shop_deploy] FOR LOGIN [orm_shop_deploy];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N''role_shop_runtime'')
    CREATE ROLE [role_shop_runtime] AUTHORIZATION dbo;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=N''role_shop_deploy'')
    CREATE ROLE [role_shop_deploy] AUTHORIZATION dbo;
IF IS_ROLEMEMBER(N''role_shop_runtime'', N''orm_shop_app'') <> 1
    ALTER ROLE [role_shop_runtime] ADD MEMBER [orm_shop_app];
IF IS_ROLEMEMBER(N''role_shop_deploy'', N''orm_shop_deploy'') <> 1
    ALTER ROLE [role_shop_deploy] ADD MEMBER [orm_shop_deploy];
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[shop] TO [role_shop_runtime];
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE FUNCTION, CREATE TYPE TO [role_shop_deploy];
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[shop] TO [role_shop_deploy];
');
PRINT N'OrmShop loginy, role i uprawnienia utworzone. Sprawdz 03-verify-permissions.sql.';
