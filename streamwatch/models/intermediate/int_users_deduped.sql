WITH stg AS (
    SELECT * FROM {{ ref('stg_watch_events') }}
),

ranked AS (
    SELECT
        user_id,
        user_name,
        user_country,
        user_subscription_tier,
        watch_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY watch_date DESC
        ) AS rn
    FROM stg
)

SELECT
    user_id,
    user_name,
    user_country,
    user_subscription_tier
FROM ranked
WHERE rn = 1