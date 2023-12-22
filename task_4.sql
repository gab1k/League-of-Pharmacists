SET SEARCH_PATH = league_of_pharmacist;

-- Заполнение таблицы users
INSERT INTO users (name, surname, sex, passport, birthdate, registration_date, city, mail, phone_number)
VALUES ('John', 'Doe', 'male', '4024 777777', '1990-05-15', '2023-01-01', 'New York', 'john@example.com', '123-456-7890');

-- Заполнение таблицы event_types
INSERT INTO event_types (name, is_online)
VALUES ('Футбол', true);

-- Заполнение таблицы events
INSERT INTO events (event_type_id, event_name, start_time)
VALUES (1, 'Барселона - Зенит', '2023-12-31 23:59:59+00');

-- Заполнение таблицы acceptable_conditions
INSERT INTO acceptable_conditions (event_type_id, name_bet_condition)
VALUES (1, 'Победа команды А');

-- Заполнение таблицы ratios
INSERT INTO ratios (event_id, acceptable_condition_id, ratio, is_lost, start_time, end_time)
VALUES (1, 1, 1.9, null, '2023-07-20 18:00:00+00', '2023-07-20 23:59:59+00');

-- Заполнение таблицы bets
INSERT INTO bets (user_id, event_id, acceptable_condition_id, ratio, time, amount)
VALUES (1, 1, 1, 1.9, '2023-07-18 15:00:00+00', 500.0);

-- Заполнение таблицы transactions
INSERT INTO transactions (user_id, bet_id, amount, time, type)
VALUES (1, 1, 500, '2023-07-18 15:01:00+00', 'withdrawal');

-- Заполнение таблиц из файлов
COPY users(name, surname, sex, passport, birthdate, registration_date, city, mail, phone_number)
FROM './csv/users.csv'
DELIMITER ',' CSV HEADER;

COPY event_types (name, is_online)
FROM './csv/event_types.csv'
DELIMITER ',' CSV HEADER;

COPY events (event_type_id, event_name, start_time)
FROM './csv/event.csv'
DELIMITER ',' CSV HEADER;

COPY  acceptable_conditions (event_type_id, name_bet_condition)
FROM './csv/acceptable_condition.csv'
DELIMITER ',' CSV HEADER;

COPY  bets (user_id, event_id, acceptable_condition_id, ratio, time, amount)
FROM './csv/bets.csv'
DELIMITER ',' CSV HEADER;

COPY ratios (event_id, acceptable_condition_id, ratio, is_lost, start_time, end_time)
FROM './csv/ratio.csv'
DELIMITER ',' CSV HEADER;

COPY  transactions(user_id, bet_id, amount, time, type)
FROM './csv/transactions.csv'
DELIMITER ',' CSV HEADER;
