SELECT table_name,
       ROUND(data_length  / 1024 / 1024, 2) AS data_mb,
       ROUND(index_length / 1024 / 1024, 2) AS index_mb,
       ROUND((data_length + index_length) / 1024 / 1024, 2) AS total_mb,
       ROUND(data_free    / 1024 / 1024, 2) AS free_mb,
       table_rows
FROM information_schema.tables
WHERE table_schema = 'innodb_bts'
  AND table_name IN ('flights', 'airlines', 'airports')
ORDER BY (data_length + index_length) DESC;
