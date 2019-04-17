SELECT
	s.[name] as [Schema],
	o.[name] as [Entity],
	CASE o.[type]
		WHEN 'U' THEN 'Table'
		WHEN 'V' THEN 'View'
	END as [Entity Type],
	c.[column_id] as [Column Number],
	c.[name] as [Column],
	CASE c.[is_nullable]
		WHEN 1 THEN 'Nullable'
		ELSE 'Not Nullable'
	END as [Nullable],
	CASE
		WHEN st.[name] = 'bigint' THEN st.[name]
		WHEN st.[name] = 'binary' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		WHEN st.[name] = 'bit' THEN st.[name]
		WHEN st.[name] = 'char' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		WHEN st.[name] = 'date' THEN st.[name]
		WHEN st.[name] = 'datetime' THEN st.[name]
		WHEN st.[name] = 'datetime2' THEN st.[name] + '(' + CAST(c.[precision] as varchar) + ')'
		WHEN st.[name] = 'datetimeoffset' THEN st.[name] + '(' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'decimal' THEN st.[name] + '(' + CAST(c.[precision] as varchar) + ',' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'float' THEN st.[name]
		WHEN ut.[name] = 'geography' THEN ut.[name]
		WHEN ut.[name] = 'geometry' THEN ut.[name]
		WHEN ut.[name] = 'hierarchyid' THEN ut.[name]
		WHEN st.[name] = 'image' THEN st.[name]
		WHEN st.[name] = 'int' THEN st.[name]
		WHEN st.[name] = 'money' THEN st.[name]
		WHEN st.[name] = 'nchar' THEN st.[name] + '(' + CAST(c.[max_length] / 2 as varchar) + ')'
		WHEN st.[name] = 'ntext' THEN st.[name]
		WHEN st.[name] = 'numeric' THEN st.[name] + '(' + CAST(c.[precision] as varchar) + ',' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'nvarchar' AND c.[max_length] = -1 THEN st.[name] + '(max)'
		WHEN st.[name] = 'nvarchar' THEN st.[name] + '(' + CAST(c.[max_length] / 2 as varchar) + ')'
		WHEN st.[name] = 'real' THEN st.[name]
		WHEN st.[name] = 'smalldatetime' THEN st.[name]
		WHEN st.[name] = 'smallint' THEN st.[name]
		WHEN st.[name] = 'smallmoney' THEN st.[name]
		WHEN st.[name] = 'sql_variant' THEN st.[name]
		WHEN st.[name] = 'text' THEN st.[name]
		WHEN st.[name] = 'time' THEN st.[name] + '(' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'timestamp' THEN st.[name]
		WHEN st.[name] = 'tinyint' THEN st.[name]
		WHEN st.[name] = 'uniqueidentifier' THEN st.[name]
		WHEN st.[name] = 'varbinary' AND c.[max_length] = -1 THEN st.[name] + '(max)'
		WHEN st.[name] = 'varbinary' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		WHEN st.[name] = 'varchar' AND c.[max_length] = -1 THEN st.[name] + '(max)'
		WHEN st.[name] = 'varchar' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		WHEN st.[name] = 'xml' THEN st.[name]
	END as [Data Type],
	ut.[name] as [User Data Type],
	st.[name] as [System Data Type],
	c.[max_length] as [Length (in bytes)],
	c.[precision] as [Precision],
	c.[scale] as [Scale],
	c.[collation_name] as [Collation],
	dc.[definition] as [Default],
	c.is_identity,
	c.is_rowguidcol
FROM sys.columns c
JOIN sys.objects o
	ON o.[object_id] = c.[object_id]
JOIN sys.schemas s
	ON s.[schema_id] = o.[schema_id]
JOIN sys.types ut
	ON ut.[user_type_id] = c.[user_type_id]
LEFT JOIN sys.types st
	ON st.[user_type_id] = ut.[system_type_id]
LEFT JOIN sys.default_constraints dc
	ON dc.[object_id] = c.[default_object_id]
-- WHERE o.[type] IN ('U', 'V')
ORDER BY
	s.[name],
	o.[name],
	c.[column_id]
