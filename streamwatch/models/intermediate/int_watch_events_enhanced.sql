WITH stg AS (
    SELECT * FROM {{ ref('stg_watch_events') }}
)

SELECT
    event_id,
    user_id,
    content_id,
    watch_date,
    device_type,
    minutes_watched,
    content_duration_minutes,
    completed_flag,
    rating_given,

    -- Derived metrics
    ROUND(
        (minutes_watched / NULLIF(content_duration_minutes, 0)) * 100,
        2
    ) AS completion_pct,

    DATEDIFF(
        'day',
        content_release_date,
        watch_date
    ) AS days_since_release,

    CASE
        WHEN rating_given >= 4 THEN TRUE
        ELSE FALSE
    END AS is_high_rating

FROM stg