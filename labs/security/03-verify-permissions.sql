USE OrmShop;
GO
-- As administrator: membership and explicit grants
SELECT p.name AS Principal, p.type_desc, r.name AS RoleName
FROM sys.database_principals AS p
LEFT JOIN sys.database_role_members AS drm ON drm.member_principal_id=p.principal_id
LEFT JOIN sys.database_principals AS r ON r.principal_id=drm.role_principal_id
WHERE p.name IN (N'orm_shop_app',N'orm_shop_deploy');
SELECT USER_NAME(grantee_principal_id) AS Grantee, permission_name, state_desc,
       class_desc, SCHEMA_NAME(major_id) AS SchemaName
FROM sys.database_permissions
WHERE grantee_principal_id IN
 (USER_ID(N'role_shop_runtime'),USER_ID(N'role_shop_deploy'));
GO
-- Instructor performs the following logins as separate SSMS connections:
-- orm_shop_app: SELECT/INSERT/UPDATE/DELETE permitted on shop objects.
-- orm_shop_app: CREATE TABLE / ALTER denied. Test using:
-- CREATE TABLE shop.ShouldFail (Id int); -- expected 262 or similar
-- orm_shop_deploy: migrations permitted within shop.
-- Neither account may be a member of db_owner, db_ddladmin, sysadmin.
SELECT r.name AS Role, m.name AS Member
FROM sys.database_role_members AS rm
JOIN sys.database_principals AS r ON rm.role_principal_id=r.principal_id
JOIN sys.database_principals AS m ON rm.member_principal_id=m.principal_id
WHERE m.name LIKE N'orm_shop_%';
GO
