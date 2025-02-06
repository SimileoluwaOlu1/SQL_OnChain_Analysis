WITH whale_transactions AS (
    SELECT
        from_address AS whale_address,
        to_address,
        contract_address,
        symbol,
        transfer_type,
        amount_usd,
        DATE(block_timestamp) AS activity_date
    FROM
        NEAR.core.ez_token_transfers
    WHERE
        amount_usd > 100000
    AND block_timestamp >= '2024-10-01'
),
top_whales AS (
    SELECT
        whale_address,
        COUNT(*) AS transaction_count,
        SUM(amount_usd) AS total_volume_usd
    FROM
        whale_transactions
    GROUP BY
        whale_address
    ORDER BY
        total_volume_usd DESC
    LIMIT 10
),
whale_activity_by_token AS (
    SELECT
        symbol AS token,
        COUNT(*) AS transaction_count,
        SUM(amount_usd) AS total_volume_usd
    FROM
        whale_transactions
    GROUP BY
        symbol
    ORDER BY
        total_volume_usd DESC
),
whale_daily_activity AS (
    SELECT
        activity_date,
        COUNT(*) AS daily_transaction_count,
        SUM(amount_usd) AS daily_volume_usd
    FROM
        whale_transactions
    GROUP BY
        activity_date
    ORDER BY
        activity_date DESC
),
top_whale_contracts AS (
    SELECT
        contract_address,
        COUNT(*) AS transaction_count,
        SUM(amount_usd) AS total_volume_usd
    FROM
        whale_transactions
    GROUP BY
        contract_address
    ORDER BY
        total_volume_usd DESC
    LIMIT 10
)
SELECT
    -- Top Whales
    w.whale_address,
    w.transaction_count AS whale_transaction_count,
    w.total_volume_usd AS whale_total_volume_usd,
    -- Whale Activity by Token
    t.token AS token,
    t.transaction_count AS token_transaction_count,
    t.total_volume_usd AS token_total_volume_usd,
    -- Whale Daily Activity
    d.activity_date AS activity_date,
    d.daily_transaction_count,
    d.daily_volume_usd,
    -- Top Whale Contracts
    c.contract_address,
    c.transaction_count AS contract_transaction_count,
    c.total_volume_usd AS contract_total_volume_usd
FROM
    top_whales w
LEFT JOIN whale_activity_by_token t ON 1=1
LEFT JOIN whale_daily_activity d ON 1=1
LEFT JOIN top_whale_contracts c ON 1=1;
