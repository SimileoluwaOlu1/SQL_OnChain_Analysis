WITH historical_whales AS (
    SELECT DISTINCT from_address
    FROM NEAR.core.ez_token_transfers
    WHERE
        amount_usd > 100000
        AND block_timestamp < CURRENT_DATE - INTERVAL '30 DAYS'
        AND block_timestamp >= '2024-10-01'
),
recent_whales AS (
    SELECT DISTINCT from_address
    FROM NEAR.core.ez_token_transfers
    WHERE
        amount_usd > 100000
        AND block_timestamp >= CURRENT_DATE - INTERVAL '30 DAYS'
)
SELECT
    COUNT(recent_whales.from_address) AS new_whale_count
FROM
    recent_whales
LEFT JOIN
    historical_whales
ON
    recent_whales.from_address = historical_whales.from_address
WHERE
    historical_whales.from_address IS NULL;
