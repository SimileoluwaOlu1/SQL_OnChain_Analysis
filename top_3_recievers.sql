SELECT
    to_address AS whale_address,
    COUNT(*) AS transaction_count,
    SUM(amount_usd) AS total_received_usd
FROM
    NEAR.core.ez_token_transfers
WHERE
    amount_usd > 100000
AND block_timestamp >= '2024-10-01'
GROUP BY
    to_address
ORDER BY
    total_received_usd DESC
LIMIT 3;
