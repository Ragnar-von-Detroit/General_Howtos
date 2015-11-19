-- define a variable in your statement
-- set a scalar value
SET @MY_VARIABLE = 'foo';

-- set a result
SET @MY_VARIABLE = (SELECT 
    GROUP_CONCAT(DISTINCT `t`.`id`) 
FROM 
    `my_table` AS `t` 
WHERE 
    `t`.`my_column` LIKE '%my parameter%';

-- use your variable
SELECT 
    *
FROM
    `my_table`
WHERE
    `my_table`.`my_column` = @MY_VARIABLE;
