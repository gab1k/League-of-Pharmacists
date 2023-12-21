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