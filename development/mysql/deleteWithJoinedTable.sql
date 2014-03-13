-- delete with join
-- only tables listed in the DELETE are used for deletion

DELETE
    `t1` 
FROM 
    `table_one` AS `t1`
    LEFT JOIN `table_two` AS `t2` 
        ON `t1`.`id` = `t2`.`t1_id`
WHERE
    `t2`.`id` IS NOT NULL
    AND `t2`.`foo` = 'bar';
