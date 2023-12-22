SET SEARCH_PATH = league_of_pharmacist;

-- Триггер на создание банковских транзакций пользователям, у которых сыграла ставка

CREATE OR REPLACE FUNCTION add_transaction_for_all_users_by_event() RETURNS TRIGGER AS
$$
DECLARE
    r record;
BEGIN
    FOR r IN SELECT users.user_id, bets.bet_id, bets.ratio, bets.amount FROM users INNER JOIN bets ON users.user_id = bets.user_id
            WHERE bets.event_id=NEW.event_id and bets.acceptable_condition_id=NEW.acceptable_condition_id
        LOOP
            IF NEW.is_lost = true THEN
                INSERT INTO transactions (user_id, bet_id, amount, time, type)
                VALUES (r.user_id, r.bet_id, r.amount, NEW.end_time, 'withdrawal');
            ELSE
                INSERT INTO transactions (user_id, bet_id, amount, time, type)
                VALUES (r.user_id, r.bet_id, r.ratio * r.amount, NEW.end_time, 'replenishment');
            END IF;
        END LOOP;
    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE TRIGGER transaction_by_event
    AFTER INSERT
    ON ratios
    FOR EACH ROW
    WHEN (NEW.is_lost IS NOT NULL)
EXECUTE PROCEDURE add_transaction_for_all_users_by_event();


-- Тест транзакции

-- insert into events (event_type_id, event_name, start_time)
-- values (1, 'Игра для теста №1', '2024-02-02 10:00:00');
--
-- insert into ratios (event_id, acceptable_condition_id, ratio, start_time, end_time)
-- values (12, 1, 1.5, '2024-02-02 10:00:00', '9999-12-12 09:00:00.000000 +00:00');
--
-- insert into bets (user_id, event_id, acceptable_condition_id, ratio, time, amount)
-- values (1, 12, 1, 1.5, '2024-02-02 10:15:00', 600),
--         (2, 12, 1, 1.5, '2024-02-02 10:20:00', 1000);
--
-- update ratios
-- set end_time = '2024-02-02 11:00:00'
-- where event_id=12 and acceptable_condition_id=1;
--
-- insert into ratios (event_id, acceptable_condition_id, ratio, is_lost, start_time, end_time)
-- values (12, 1, 1.5, false, '2024-02-02 11:00:00', '2024-02-02 12:00:00');



-- Триггер на выплату бонусного депозита новым пользоваелям

CREATE OR REPLACE FUNCTION add_free_bet_transaction() RETURNS TRIGGER AS
$$
DECLARE
    free_bet_amount int = 1000;
BEGIN
    INSERT INTO transactions (user_id, amount, time, type)
    VALUES (NEW.user_id, free_bet_amount, NOW(), 'replenishment');
    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE TRIGGER free_bet_for_new_users
    AFTER INSERT
    ON users
    FOR EACH ROW
EXECUTE PROCEDURE add_free_bet_transaction();


-- Тест транзакции

-- insert into users (name, surname, sex, passport, birthdate, registration_date, city, mail, phone_number)
-- values ('Michael', 'Jordan', 'male', '123456', '1963-02-17', NOW(), 'Moscow', 'lol@rambler.ru', '88005553535'),
--         ('John', 'Clinton', 'male', '987654', '2000-02-17', NOW(), 'Boston', 'john@mail.com', '84959951030');
