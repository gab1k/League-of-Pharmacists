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

