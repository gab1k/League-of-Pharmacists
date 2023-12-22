DROP SCHEMA IF EXISTS view_schema CASCADE;

CREATE SCHEMA view_schema;

SET SEARCH_PATH = view_schema, public;


CREATE OR REPLACE VIEW view_schema.masked_users AS
SELECT
    user_id,
    name,
    surname,
    CASE
        WHEN LENGTH(passport) > 4 THEN CONCAT('********', RIGHT(passport, 4))
        ELSE '********'
    END AS masked_passport,
    birthdate,
    registration_date,
    city,
    CASE
        WHEN POSITION('@' IN mail) > 3 THEN CONCAT(LEFT(mail, POSITION('@' IN mail) - 3), '***@***.***')
        ELSE '***'
    END AS masked_mail,
    CONCAT('***-***-', RIGHT(phone_number, 4)) AS masked_phone_number
FROM league_of_pharmacist.users;

CREATE OR REPLACE VIEW view_schema.masked_bets AS
SELECT
    bet_id,
    user_id,
    event_id,
    acceptable_condition_id,
    ratio,
    time,
    amount
FROM league_of_pharmacist.bets;

CREATE OR REPLACE VIEW view_schema.masked_events AS
SELECT
    event_id,
    event_type_id,
    event_name,
    start_time
FROM league_of_pharmacist.events;

CREATE OR REPLACE VIEW view_schema.masked_event_types AS
SELECT
    event_type_id,
    name,
    is_online
FROM league_of_pharmacist.event_types;

CREATE OR REPLACE VIEW view_schema.masked_acceptable_conditions AS
SELECT
    acceptable_condition_id,
    event_type_id,
    name_bet_condition
FROM league_of_pharmacist.acceptable_conditions;

CREATE OR REPLACE VIEW view_schema.masked_ratios AS
SELECT
    event_id,
    acceptable_condition_id,
    ratio,
    is_lost,
    start_time,
    end_time
FROM league_of_pharmacist.ratios;

CREATE OR REPLACE VIEW view_schema.masked_transactions AS
SELECT
    transactions_id,
    user_id,
    bet_id,
    amount,
    time,
    type
FROM league_of_pharmacist.transactions;
