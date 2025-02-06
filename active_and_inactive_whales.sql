WITH recent_activity AS (
    SELECT
        from_address,
        COUNT(*) AS recent_tx_count,
        SUM(amount_usd) AS recent_total_usd
    FROM
        NEAR.core.ez_token_transfers
    WHERE
        block_timestamp >= CURRENT_DATE - INTERVAL '30 DAYS'
    AND block_timestamp >= '2024-10-01'
    GROUP BY
        from_address
),
all_whales AS (
    SELECT
        from_address,
        COUNT(*) AS total_tx_count,
        SUM(amount_usd) AS total_usd
    FROM
        NEAR.core.ez_token_transfers
    WHERE
        amount_usd > 100000
    GROUP BY
        from_address
),
active_whales AS (
    SELECT
        a.from_address,
        a.total_tx_count,
        a.total_usd,
        r.recent_tx_count,
        r.recent_total_usd
    FROM
        all_whales a
    INNER JOIN
        recent_activity r
    ON
        a.from_address = r.from_address
),
inactive_whales AS (
    SELECT
        a.from_address,
        a.total_tx_count,
        a.total_usd
    FROM
        all_whales a
    LEFT JOIN
        recent_activity r
    ON
        a.from_address = r.from_address
    WHERE
        r.from_address IS NULL
)
SELECT
    'Active' AS whale_status,
    COUNT(*) AS whale_count,
    SUM(total_usd) AS total_usd_transacted,
    SUM(total_tx_count) AS total_transactions
FROM
    active_whales

UNION ALL

SELECT
    'Inactive' AS whale_status,
    COUNT(*) AS whale_count,
    SUM(total_usd) AS total_usd_transacted,
    SUM(total_tx_count) AS total_transactions
FROM
    inactive_whales;
