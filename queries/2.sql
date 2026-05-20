SELECT `q`.`airline`,
       `q`.`year`,
       `q`.`delay_type`,
       `q`.`delay`
FROM
    (SELECT `a`.`airline`,
            `f`.`year`,
            'Airline Delay' AS `delay_type`,
            COUNT(*) AS `delay`
     FROM `innodb_bts`.`flights` `f`
     JOIN `innodb_bts`.`airlines` `a` ON `f`.`carrier` = `a`.`iata_code`
     WHERE `f`.`carrier_delay` > 0 GROUP  BY `a`.`airline`,
                                             `f`.`year`
     UNION ALL SELECT `a`.`airline`,
                      `f`.`year`,
                      'Late Aircraft Delay' AS `delay_type`,
                      COUNT(*) AS `delay`
     FROM `innodb_bts`.`flights` `f`
     JOIN `innodb_bts`.`airlines` `a` ON `f`.`carrier` = `a`.`iata_code`
     WHERE `f`.`late_aircraft_delay` > 0 GROUP  BY `a`.`airline`,
                                                   `f`.`year`
     UNION ALL SELECT `a`.`airline`,
                      `f`.`year`,
                      'Air System Delay' AS `delay_type`,
                      COUNT(*) AS `delay`
     FROM `innodb_bts`.`flights` `f`
     JOIN `innodb_bts`.`airlines` `a` ON `f`.`carrier` = `a`.`iata_code`
     WHERE `f`.`nas_delay` > 0 GROUP  BY `a`.`airline`,
                                         `f`.`year`
     UNION ALL SELECT `a`.`airline`,
                      `f`.`year`,
                      'Weather Delay' `delay_type`,
                                      COUNT(*) AS `delay`
     FROM `innodb_bts`.`flights` `f`
     JOIN `innodb_bts`.`airlines` `a` ON `f`.`carrier` = `a`.`iata_code`
     WHERE `f`.`weather_delay` > 0 GROUP  BY `a`.`airline`,
                                             `f`.`year`) AS `q`
ORDER  BY 1,
          2,
          3;
