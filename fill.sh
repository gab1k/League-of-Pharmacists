#!/bin/bash

# Скрипт запускается из корневой директории, таблицы лежат в папке ./csv

# Поменяйте postgres_user на пользователя под которым происходит работа с базой данных
postgres_user="postgres"

sudo -u $postgres_user psql -c "\copy league_of_pharmacist.users(name, surname, sex, passport, birthdate, registration_date, city, mail, phone_number)
FROM './csv/users.csv'
DELIMITER ',' CSV HEADER;"

sudo -u $postgres_user psql -c "\copy league_of_pharmacist.event_types(name, is_online)
FROM './csv/event_types.csv'
DELIMITER ',' CSV HEADER;"

sudo -u $postgres_user psql -c "\copy league_of_pharmacist.events(event_type_id, event_name, start_time)
FROM './csv/event.csv'
DELIMITER ',' CSV HEADER;"

sudo -u $postgres_user psql -c "\copy league_of_pharmacist.acceptable_conditions(event_type_id, name_bet_condition)
FROM './csv/acceptable_condition.csv'
DELIMITER ',' CSV HEADER;"

sudo -u $postgres_user psql -c "\copy league_of_pharmacist.bets(user_id, event_id, acceptable_condition_id, ratio, time, amount)
FROM './csv/bets.csv'
DELIMITER ',' CSV HEADER;"

sudo -u $postgres_user psql -c "\copy league_of_pharmacist.ratios(event_id, acceptable_condition_id, ratio, is_lost, start_time, end_time)
FROM './csv/ratio.csv'
DELIMITER ',' CSV HEADER;"

sudo -u $postgres_user psql -c "\copy league_of_pharmacist.transactions(user_id, bet_id, amount, time, type)
FROM './csv/transactions.csv'
DELIMITER ',' CSV HEADER;"
