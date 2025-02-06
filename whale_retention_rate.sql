WITH previous_period_whales AS (
    SELECT DISTINCT from_address
    FROM NEAR.core.ez_token_transfers
    WHERE
        amount_usd > 100000
        AND block_timestamp BETWEEN CURRENT_DATE - INTERVAL '60 DAYS' AND CURRENT_DATE - INTERVAL '30 DAYS'
AND block_timestamp >= '2024-10-01'
),
current_period_whales AS (
    SELECT DISTINCT from_address
    FROM NEAR.core.ez_token_transfers
    WHERE
        amount_usd > 100000
        AND block_timestamp >= CURRENT_DATE - INTERVAL '30 DAYS'
)
SELECT
    COUNT(current_period_whales.from_address) AS retained_whale_count,
    COUNT(previous_period_whales.from_address) AS previous_whale_count,
    (COUNT(current_period_whales.from_address) * 1.0 / COUNT(previous_period_whales.from_address)) * 100 AS retention_rate
FROM
    previous_period_whales
LEFT JOIN
    current_period_whales
ON
    previous_period_whales.from_address = current_period_whales.from_address;
