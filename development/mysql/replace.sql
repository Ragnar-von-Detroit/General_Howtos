-- instead of an update, a replace deletes the current entry and inserts a new one
REPLACE INTO 
  `my_table` 
(`column_1`, `column_2`) 
VALUES (
  'foo', 
  23
);

-- update and replace parts of the string

UPDATE 
    `table_one`
SET 
    `my_column` = REPLACE(`my_column`, 'search_string', 'replace_string');
