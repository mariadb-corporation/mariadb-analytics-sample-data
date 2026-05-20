SELECT dest,
       month,
       TO_CHAR(fl_date, 'Month')             AS month_name,
       CAST(LEFT(crs_arr_time, 2) AS INTEGER) AS scheduled_arrival_hr,
       AVG(arr_delay)                         AS avg_arr_delay,
       MAX(arr_delay)                         AS max_arr_delay
FROM innodb_bts.flights
WHERE dest IN ('SFO', 'OAK', 'SJC')
  AND arr_delay > 0
  AND year = 2020
GROUP BY 1, 2, 3, 4
ORDER BY 1, 2, 4;
