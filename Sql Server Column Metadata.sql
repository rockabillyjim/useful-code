WITH

PKs as (
SELECT
	pk.[object_id],
	pkc.[column_id],
	pkc.[index_column_id]
FROM sys.indexes pk
JOIN sys.index_columns pkc
	ON pkc.[object_id] = pk.[object_id]
	AND pkc.[index_id] = pk.[index_id]
WHERE pk.[is_primary_key] = 1
)

SELECT
	s.[name] as [Schema],
	o.[name] as [Entity],
	CASE o.[type]
		WHEN 'U' THEN 'Table'
		WHEN 'V' THEN 'View'
		WHEN 'IF' THEN 'Table Valued Function'
		WHEN 'TF' THEN 'Table Valued Function'
	END as [Entity Type],
	c.[column_id] as [Column #],
	c.[name] as [Column],
	CASE c.[is_nullable]
		WHEN 1 THEN 'Nullable'
		ELSE 'Not Nullable'
	END as [Nullable],
	CASE
		WHEN st.[name] = 'binary' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		WHEN st.[name] = 'char' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		WHEN st.[name] = 'datetime2' THEN st.[name] + '(' + CAST(c.[precision] as varchar) + ')'
		WHEN st.[name] = 'datetimeoffset' THEN st.[name] + '(' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'decimal' THEN st.[name] + '(' + CAST(c.[precision] as varchar) + ',' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'float' THEN st.[name]
		WHEN ut.[name] = 'geography' THEN ut.[name]
		WHEN ut.[name] = 'geometry' THEN ut.[name]
		WHEN ut.[name] = 'hierarchyid' THEN ut.[name]
		WHEN st.[name] = 'nchar' THEN st.[name] + '(' + CAST(c.[max_length] / 2 as varchar) + ')'
		WHEN st.[name] = 'numeric' THEN st.[name] + '(' + CAST(c.[precision] as varchar) + ',' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'nvarchar' AND c.[max_length] = -1 THEN st.[name] + '(max)'
		WHEN st.[name] = 'nvarchar' THEN st.[name] + '(' + CAST(c.[max_length] / 2 as varchar) + ')'
		WHEN st.[name] = 'real' THEN st.[name]
		WHEN st.[name] = 'time' THEN st.[name] + '(' + CAST(c.[scale] as varchar) + ')'
		WHEN st.[name] = 'varbinary' AND c.[max_length] = -1 THEN st.[name] + '(max)'
		WHEN st.[name] = 'varbinary' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		WHEN st.[name] = 'varchar' AND c.[max_length] = -1 THEN st.[name] + '(max)'
		WHEN st.[name] = 'varchar' THEN st.[name] + '(' + CAST(c.[max_length] as varchar) + ')'
		ELSE st.[name]
	END as [Data Type],
	ut.[name] as [User Data Type],
	c.[collation_name] as [Collation],
	dc.[definition] as [Default],
	cc.[definition] as [Computed Definition],
	PKs.index_column_id as [PK Column #],
	CASE c.is_identity WHEN 1 THEN 'Identity' END as [Identity],
	CASE c.is_rowguidcol WHEN 1 THEN 'Row GUID' END as [Row GUID],
	c.[object_id]
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
LEFT JOIN sys.computed_columns cc
	ON cc.[object_id] = c.[object_id]
	AND cc.[column_id] = c.[column_id]
LEFT JOIN PKs
	ON PKs.[object_id] = c.[object_id]
	AND PKs.[column_id] = c.[column_id]
WHERE o.[is_ms_shipped] = 0
ORDER BY
	s.[name],
	o.[name],
	c.[column_id]
