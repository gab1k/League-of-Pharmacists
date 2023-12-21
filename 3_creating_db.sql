DROP SCHEMA IF EXISTS league_of_pharmacist CASCADE;

CREATE SCHEMA league_of_pharmacist;

SET SEARCH_PATH = league_of_pharmacist;

create type sex_type AS ENUM ('male', 'female');

CREATE TABLE users
(
    user_id           serial PRIMARY KEY,
    name              varchar(50) NOT NULL,
    surname           varchar(50),
    sex               sex_type,
    passport          varchar(20),
    birthdate         date,
    registration_date date        NOT NULL,
    city              varchar(50),
    mail              varchar(50),
    phone_number      varchar(15) NOT NULL
);

CREATE TABLE event_types
(
    event_type_id serial PRIMARY KEY,
    name          varchar(255),
    is_online     bool NOT NULL
);

CREATE TABLE events
(
    event_id      serial PRIMARY KEY,
    event_type_id int NOT NULL,
    event_name    varchar(255),
    start_time    timestamp with time zone,
    foreign key (event_type_id) references event_types (event_type_id)
);

CREATE TABLE acceptable_conditions
(
    acceptable_condition_id serial PRIMARY KEY,
    event_type_id           int          NOT NULL,
    name_bet_condition      varchar(255) NOT NULL,
    foreign key (event_type_id) references event_types (event_type_id)
);

CREATE TABLE ratios
(
    event_id                int,
    acceptable_condition_id int,
    ratio                   float CHECK ( ratio >= 1.0 ),
    is_lost                 bool,
    start_time              timestamp with time zone NOT NULL,
    end_time                timestamp with time zone NOT NULL,
    primary key (event_id, acceptable_condition_id),
    foreign key (event_id) references events (event_id),
    foreign key (acceptable_condition_id) references acceptable_conditions (acceptable_condition_id)

);

CREATE TABLE bets
(
    bet_id                  serial PRIMARY KEY,
    user_id                 int                      NOT NULL,
    event_id                int                      NOT NULL,
    acceptable_condition_id int                      NOT NULL,
    ratio                   float CHECK ( ratio >= 1.0 ),
    time                    timestamp with time zone NOT NULL,
    amount                  double precision CHECK ( amount >= 10.0 ),
    foreign key (user_id) references users (user_id),
    foreign key (event_id) references events (event_id),
    foreign key (acceptable_condition_id) references acceptable_conditions (acceptable_condition_id)
);

create type transaction_type AS ENUM ('withdrawal', 'replenishment'); -- Снятие или пополнение

CREATE TABLE transactions
(
    transactions_id serial PRIMARY KEY,
    user_id         int                      NOT NULL,
    bet_id          int,
    amount          int                      NOT NULL,
    time            timestamp with time zone NOT NULL,
    type            transaction_type         NOT NULL,
    foreign key (user_id) references users (user_id),
    foreign key (bet_id) references bets (bet_id)
);
