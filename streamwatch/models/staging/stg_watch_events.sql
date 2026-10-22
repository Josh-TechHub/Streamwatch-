WITH source AS (
    SELECT * FROM {{ source('raw', 'WATCH_EVENTS_FLAT') }}
),

renamed AS (
    SELECT
        CAST(event_id AS VARCHAR(255)) AS event_id,
        CAST(user_id AS VARCHAR(255)) AS user_id,
        CAST(user_name AS VARCHAR(255)) AS user_name,
        CAST(user_country AS VARCHAR(255)) AS user_country,
        CAST(user_subscription_tier AS VARCHAR(255)) AS user_subscription_tier,
        CAST(content_id AS VARCHAR(255)) AS content_id,
        CAST(content_title AS VARCHAR(255)) AS content_title,
        CAST(content_genre AS VARCHAR(255)) AS content_genre,
        CAST(content_release_date AS DATE) AS content_release_date,
        CAST(content_duration_minutes AS INTEGER) AS content_duration_minutes,
        CAST(watch_date AS DATE) AS watch_date,
        CAST(device_type AS VARCHAR(255)) AS device_type,
        CAST(minutes_watched AS INTEGER) AS minutes_watched,
        CAST(completed_flag AS INTEGER) AS completed_flag,
        CAST(rating_given AS INTEGER) AS rating_given
    FROM source
)
SELECT * FROM renamed
