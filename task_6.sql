SET SEARCH_PATH = league_of_pharmacist;

-- 1

SELECT
    city, COUNT(user_id) AS user_count
FROM
    users
GROUP BY
    city
HAVING
    COUNT(user_id) >= 1
ORDER BY
    user_count DESC;

-- Ожидание: Подсчет количества пользователей в каждом городе,
-- и вывод только тех городов, в которых зарегистрировано
-- не менее 1 пользователя, упорядоченных по убыванию.

-- 2

SELECT DISTINCT
    user_id, SUM(amount) OVER (PARTITION BY user_id) AS total_bets
FROM
    bets
WINDOW
    user_window AS (PARTITION BY user_id)
ORDER BY
    total_bets DESC
LIMIT 5;

-- Ожидание: Вывести топ-3 пользователей с самыми высокими суммарными ставками,
-- используя оконную функцию для суммирования ставок по каждому пользователю.

-- 3

SELECT DISTINCT
    user_id,
    MAX(time) OVER (PARTITION BY user_id) - MIN(time) OVER (PARTITION BY user_id) AS time_difference
FROM
    bets
ORDER BY
    time_difference DESC;

-- Ожидание: Определить время, прошедшее между первой и последней ставкой для каждого пользователя,
-- используя оконные функции, результат упорядочить по убыванию промежутка.

-- 4

SELECT
    u.user_id,
    u.name,
    u.surname,
    COALESCE(SUM(CASE WHEN t.type = 'replenishment' AND t.bet_id IS NULL THEN 0
                     WHEN t.type = 'withdrawal' AND t.bet_id IS NULL THEN 0
                     WHEN t.type = 'replenishment' AND t.bet_id IS NOT NULL THEN b.amount
                     WHEN t.type = 'withdrawal' AND t.bet_id IS NOT NULL THEN -b.amount END), 0) AS total_winnings
FROM
    users u
LEFT JOIN
    bets b ON u.user_id = b.user_id
LEFT JOIN
    transactions t ON b.bet_id = t.bet_id
GROUP BY
    u.user_id, u.name, u.surname
ORDER BY
    total_winnings DESC;

-- Ожидание: Вывести список пользователей с общим выигрышем в порядке убывания выигрыша

-- 5

SELECT
    u.user_id,
    u.name,
    u.surname,
    COUNT(b.bet_id) AS total_bets
FROM
    users u
LEFT JOIN
    bets b ON u.user_id = b.user_id
GROUP BY
    u.user_id, u.name, u.surname
ORDER BY
    total_bets DESC;

-- Ожидание: Вывести количество ставок, сделанных пользователем в порядке убывания количества.
