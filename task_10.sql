SET SEARCH_PATH = league_of_pharmacist;

-- Вспомогательная функция

CREATE OR REPLACE FUNCTION get_event_type_id_by_event_id(my_event_id int) RETURNS int AS
$$
BEGIN
    RETURN (SELECT event_type_id
            FROM events
            WHERE my_event_id = event_id);
END;
$$ LANGUAGE PLPGSQL;


-- Процедура, добавляющая в табличку Коэффициенты коэф-ты со всевозможными условиями ставок и дефолтными значениями

CREATE OR REPLACE PROCEDURE default_initializing_ratios_by_event(my_event_id int, default_ratio double precision) AS
$$
DECLARE
    condition_id int;
BEGIN
    FOR condition_id IN SELECT acceptable_condition_id
                        FROM acceptable_conditions
                        WHERE event_type_id = get_event_type_id_by_event_id(my_event_id)
        LOOP
            INSERT INTO ratios (event_id, acceptable_condition_id, ratio, start_time, end_time)
            VALUES (my_event_id, condition_id, default_ratio, NOW(), '9999-12-12 09:00:00.000000 +00:00');
        END LOOP;
END;
$$ LANGUAGE PLPGSQL;


-- Тест процедуры


-- insert into events (event_type_id, event_name, start_time) 
-- values (1, 'game test', '2024-12-12 09:00:00');
-- call default_initializing_ratios_by_event(14, 1.1);


-- Функция, возвращающая n самых прибыльных типов события

CREATE OR REPLACE FUNCTION get_n_most_profitable_types_of_sport(n INT) RETURNS TEXT[] AS
$$
BEGIN
    RETURN ARRAY(SELECT name
                 FROM (SELECT DISTINCT name, sum(sum_by_type) OVER (PARTITION BY name) AS sm
                       FROM (SELECT name, -1 * sum_by_type AS sum_by_type
                             FROM (SELECT DISTINCT event_types.name,
                                                   transactions.type,
                                                   sum(transactions.amount) OVER (PARTITION BY name, type) AS sum_by_type
                                   FROM transactions
                                            INNER JOIN bets ON transactions.bet_id = bets.bet_id
                                            INNER JOIN events ON bets.event_id = events.event_id
                                            INNER JOIN event_types ON events.event_type_id = event_types.event_type_id) AS ntsbt
                             WHERE type = 'replenishment'
                             UNION
                             SELECT name, sum_by_type AS sum_by_type
                             FROM (SELECT DISTINCT event_types.name,
                                                   transactions.type,
                                                   sum(transactions.amount) OVER (PARTITION BY name, type) AS sum_by_type
                                   FROM transactions
                                            INNER JOIN bets ON transactions.bet_id = bets.bet_id
                                            INNER JOIN events ON bets.event_id = events.event_id
                                            INNER JOIN event_types ON events.event_type_id = event_types.event_type_id) AS ntsbt
                             WHERE type = 'withdrawal') AS nsbtnsbt
                       ORDER BY sm DESC) AS ns
                 LIMIT n);
END;
$$ LANGUAGE PLPGSQL;


-- Тест процедуры

-- select get_n_most_profitable_types_of_sport(2);
