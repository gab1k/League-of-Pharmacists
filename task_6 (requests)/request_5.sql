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