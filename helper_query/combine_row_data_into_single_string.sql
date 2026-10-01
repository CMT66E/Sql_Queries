select c.name from sys.columns c
join sys.tables AS t
on t.object_id=c.object_id
where c.name not in (select name from sys.identity_columns where is_identity=1)
and  t.name='tblTemp'


declare @Temp table
(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NULL 
)

insert into @Temp
select c.name from sys.columns c
join sys.tables AS t
on t.object_id=c.object_id
where c.name not in (select name from sys.identity_columns where is_identity=1)
and  t.name='tblTemp'


SELECT Stuff(
  (SELECT N', ' + Name FROM @Temp FOR XML PATH(''),TYPE)
  .value('text()[1]','nvarchar(max)'),1,2,N'')