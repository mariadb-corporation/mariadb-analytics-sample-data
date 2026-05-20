SELECT object_name,
       ROUND(raw_object_size  / 1024 / 1024, 2) AS raw_mb,
       ROUND(mem_object_size  / 1024 / 1024, 2) AS mem_mb,
       ROUND(raw_object_size  / NULLIF(mem_object_size, 0), 2) AS compression_ratio
FROM   exa_all_object_sizes
WHERE  object_type   = 'TABLE'
  AND  root_name     = 'INNODB_BTS'
  AND  object_name IN ('FLIGHTS', 'AIRLINES', 'AIRPORTS')
ORDER BY mem_object_size DESC;
