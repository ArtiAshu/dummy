--drop table #t2 
--INSERT INTO [dbo].[ATODB1]
--SELECT * FROM [dbo].[ATODB]

SELECT 
[ID]
,MAX([Permission]) AS [Permission]
,MAX([Database]) AS [Database]
,COALESCE(MAX([Object Schema]), MAX([Schema Name])) [Schema Name]
,MAX([Object Name]) [Object Name]
,MAX([State]) AS [State]
,MAX([Additional information]) AS [Additional information]
,MAX([Extended Protection]) AS [Extended Protection]
,MAX([principal name]) AS [principal name]
,MAX([Granted By]) AS [Granted By]
,MAX([Days since password has been changed]) AS [Days since password has been changed]
,MAX([Latest security patch]) AS [Latest security patch]
,MAX([Login]) AS [Login]
,MAX([Status]) AS [Status]
,MAX([Installed Service Pack]) AS [Installed Service Pack]
,MAX([Service Display Name]) AS [Service Display Name]
,MAX([Service Name]) AS [Service Name]
,MAX([Class]) AS [Class]
,MAX([Value]) AS [Value]
,MAX([Value in use]) AS [Value in use]
,MAX([Privilege]) AS [Privilege]
,MAX([Is Encrypted]) AS [Is Encrypted]
,MAX([permission name]) AS [permission name]
,MAX([Account Name]) AS [Account Name]
,MAX([Number of Error Logs]) AS [Number of Error Logs]
,MAX([Password]) AS [Password]
,MAX([Grantee]) AS [Grantee]
,MAX([Object Type]) AS [Object Type]
,MAX([Granted To]) AS [Granted To]
,MAX([Owner]) AS [Owner]
,MAX([Name]) AS [Name]
,MAX([Database Version]) AS [Database Version]
into #t2
FROM 
(
SELECT * FROM   
(
 SELECT t.id, s.value v,
  substring(s.value,1,PATINDEX('%=%',s.value)-1)  col 
,substring(s.value,PATINDEX('%=%',s.value)+1,100) val
  FROM [dbo].[ATODB] t 
  CROSS APPLY STRING_SPLIT(t.[OccurenceDetail], ';') s
  --where t.id < 3
) t 
PIVOT(
    min(val) 
    FOR col IN ( 
[Database]
,[Object Schema]
,[Schema Name]
,[Object Name]
,[State]
,[Additional information]
,[Extended Protection]
,[principal name]
,[Permission]
,[Granted By]
,[Days since password has been changed]
,[Latest security patch]
,[Login]
,[Status]
,[Installed Service Pack]
,[Service Display Name]
,[Service Name]
,[Class]
,[Value]
,[Value in use]
,[Privilege]
,[Is Encrypted]
,[permission name]
,[Account Name]
,[Number of Error Logs]
,[Password]
,[Grantee]
,[Object Type]
,[Granted To]
,[Owner]
,[Name]
,[Database Version]
        )
) AS pivot_table
--order by 1,2
) B
GROUP BY ID

select t1.*, t2.* from [dbo].[ATODB] t1 join #t2 t2 on t1.id = t2.id