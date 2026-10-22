WITH users AS (
    SELECT * FROM {{ ref('int_users_deduped') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_key,
    user_id,
    user_name,
    user_country,
    user_subscription_tier
FROM users
