SELECT
    symbol AS token,
    COUNT(*) AS transaction_count,
    SUM(amount_usd) AS total_volume_usd
FROM
    NEAR.core.ez_token_transfers
WHERE
    amount_usd > 100000
AND block_timestamp >= '2024-10-01'
GROUP BY
    symbol
ORDER BY
    total_volume_usd;
