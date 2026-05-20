SELECT `q`.`airline`,
       `q`.`volume` AS `flight_count`,
       ROUND(100 * `q`.`volume` / SUM(`q`.`volume`) OVER (
                                                          ORDER BY `q`.`airline` ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 2) AS `market_share_pct`,
       ROUND(100 * (q.cancelled / q.volume), 2) AS `cancelled_pct`,
       ROUND(100 * (q.diverted / q.volume), 2) AS `diverted_pct`
FROM
    (SELECT `a`.`airline`,
            COUNT(*) AS `volume`,
            SUM(`diverted`) AS `diverted`,
            SUM(`cancelled`) AS `cancelled`
     FROM `innodb_bts`.`flights` `f`
     JOIN `innodb_bts`.`airlines` `a` ON `f`.`carrier` = `a`.`iata_code`
     WHERE `f`.`year` = 2020
     GROUP BY `a`.`airline`) AS `q`
ORDER BY `flight_count` DESC;
