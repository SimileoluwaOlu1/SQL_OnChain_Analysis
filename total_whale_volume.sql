SELECT
    SUM(amount_usd) AS total_whale_volume_usd
FROM
    NEAR.core.ez_token_transfers
WHERE
    amount_usd > 100000
    AND block_timestamp >= CURRENT_DATE - INTERVAL '30 DAYS'
    AND block_timestamp >= '2024-10-01';
