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