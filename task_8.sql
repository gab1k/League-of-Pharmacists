DROP SCHEMA IF EXISTS view_schema CASCADE;

CREATE SCHEMA view_schema;

SET SEARCH_PATH = view_schema, public;

CREATE OR REPLACE VIEW user_betting_summary AS
SELECT
    u.name || ' ' || u.surname AS user_name,
    et.name AS event_type_name,
    ac.name_bet_condition,
    e.event_name,
    b.ratio,
    b.amount AS bet_amount,
    CASE
        WHEN r.is_lost IS NULL THEN 'In Progress'
        WHEN r.is_lost = true THEN 'Lost'
        WHEN r.is_lost = false THEN 'Won'
    END AS bet_result
FROM
    league_of_pharmacist.users u
JOIN
    league_of_pharmacist.bets b ON u.user_id = b.user_id
JOIN
    league_of_pharmacist.events e ON b.event_id = e.event_id
JOIN
    league_of_pharmacist.acceptable_conditions ac ON b.acceptable_condition_id = ac.acceptable_condition_id
JOIN
    league_of_pharmacist.event_types et ON e.event_type_id = et.event_type_id
LEFT JOIN
    league_of_pharmacist.ratios r ON b.event_id = r.event_id AND b.acceptable_condition_id = r.acceptable_condition_id;

-- Вся информация по ставкам для каждого пользователя

CREATE OR REPLACE VIEW football AS
SELECT
    e.event_name as "Матч",
    MAX(CASE WHEN ac.name_bet_condition = 'Победа первой команды' THEN r.ratio END) AS "Победа первой команды",
    MAX(CASE WHEN ac.name_bet_condition = 'Победа второй команды' THEN r.ratio END) AS "Победа второй команды",
    MAX(CASE WHEN ac.name_bet_condition = 'Тотал голов больше 1.5' THEN r.ratio END) AS "Тотал голов больше 1.5",
    MAX(CASE WHEN ac.name_bet_condition = 'Тотал голов больше 2.5' THEN r.ratio END) AS "Тотал голов больше 2.5",
    MAX(CASE WHEN ac.name_bet_condition = 'Тотал голов больше 3.5' THEN r.ratio END) AS "Тотал голов больше 3.5"
FROM
    league_of_pharmacist.events e
JOIN
    league_of_pharmacist.ratios r ON e.event_id = r.event_id
JOIN
    league_of_pharmacist.acceptable_conditions ac ON r.acceptable_condition_id = ac.acceptable_condition_id
WHERE
    e.event_type_id = 1
GROUP BY
    e.event_name;

-- Информация про коэффициенты на матчи по футболу

CREATE OR REPLACE VIEW event_statistics AS
SELECT
    e.event_name,
    et.name AS event_type_name,
    COUNT(b.bet_id) AS total_bets,
    COALESCE(SUM(b.amount), 0) AS total_bet_amount,
    SUM(CASE WHEN r.is_lost = false THEN b.amount ELSE 0 END) AS total_winnings
FROM
    league_of_pharmacist.events e
JOIN
    league_of_pharmacist.event_types et ON e.event_type_id = et.event_type_id
LEFT JOIN
    league_of_pharmacist.bets b ON e.event_id = b.event_id
LEFT JOIN
    league_of_pharmacist.ratios r ON b.event_id = r.event_id AND b.acceptable_condition_id = r.acceptable_condition_id
GROUP BY
    e.event_id, e.event_name, et.name;

-- Информация по ставкам для каждого события