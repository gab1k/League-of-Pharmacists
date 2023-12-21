SELECT DISTINCT
    user_id,
    MAX(time) OVER (PARTITION BY user_id) - MIN(time) OVER (PARTITION BY user_id) AS time_difference
FROM
    bets
ORDER BY
    time_difference DESC;

-- Ожидание: Определить время, прошедшее между первой и последней ставкой для каждого пользователя,
-- используя оконные функции, результат упорядочить по убыванию промежутка.