WITH total_token_volume AS (
    SELECT
        symbol,
        SUM(amount_usd) AS total_volume
    FROM
        NEAR.core.ez_token_transfers
    WHERE
        block_timestamp >= CURRENT_DATE - INTERVAL '30 DAYS'
    AND block_timestamp >= '2024-10-01'
    GROUP BY
        symbol
),
whale_token_volume AS (
    SELECT
        symbol,
        SUM(amount_usd) AS whale_volume
    FROM
        NEAR.core.ez_token_transfers
    WHERE
        amount_usd > 100000
        AND block_timestamp >= CURRENT_DATE - INTERVAL '30 DAYS'
    GROUP BY
        symbol
)
SELECT
    w.symbol,
    w.whale_volume,
    t.total_volume,
    (w.whale_volume / t.total_volume) * 100 AS whale_dominance_percentage
FROM
    whale_token_volume w
JOIN
    total_token_volume t
ON
    w.symbol = t.symbol
ORDER BY
    whale_dominance_percentage DESC;
