-- Вставка матча в таблицу events
INSERT INTO events (event_type_id, event_name, start_time)
VALUES (1, 'ПСЖ - Боруссия', '2023-12-23 18:00');

-- Вставка ставок на новый матч в таблицу ratios
INSERT INTO ratios (event_id, acceptable_condition_id, ratio, is_lost, start_time, end_time)
VALUES (12, 1, 1.55, NULL, '2023-12-23 18:00', '9999-12-23 19:45'),
       (12, 2, 1.7, NULL, '2023-12-23 18:00', '9999-12-23 19:45'),
       (12, 3, 1.9, NULL, '2023-12-23 18:00', '9999-12-23 19:45'),
       (12, 4, 2.05, NULL, '2023-12-23 18:00', '9999-12-23 19:45'),
       (12, 5, 2.75, NULL, '2023-12-23 18:00', '9999-12-23 19:45');

-- Ввод событий всех событий
SELECT e.event_name AS "Название события", e.start_time AS "Время начала"
FROM events e;

-- Вывод возможных ставок
SELECT ratios.event_id AS "id События", ratios.acceptable_condition_id AS "id типа ставки", ratios.ratio AS "Коэфицент", ratios.start_time AS "Время начала"
FROM ratios
ORDER BY ratios.event_id;

-- обновление коэфицента на победу ПСЖ
UPDATE ratios
SET ratio = 1.2
WHERE event_id = 12 AND acceptable_condition_id = 1;

-- обновление времени матча ПСЖ - Боруссия
UPDATE events
SET start_time = '2023-12-24 18:00'
WHERE event_id = 12;


-- В связи с снятием Боруссии с турнира удалим ставки на матч
DELETE FROM ratios
WHERE event_id = 12;

-- Удаление матча ПСЖ - Боруссия изза снятия Боруссии с турнира
DELETE FROM events
WHERE event_id = 12;
