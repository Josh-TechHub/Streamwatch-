WITH enhanced_events AS (
    SELECT * FROM {{ ref('int_watch_events_enhanced') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['event_id']) }} AS watch_event_key,
    {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_key,
    {{ dbt_utils.generate_surrogate_key(['content_id']) }} AS content_key,
    event_id,
    user_id,
    content_id,
    watch_date,
    device_type,
    minutes_watched,
    completion_pct,
    completed_flag,
    rating_given,
    is_high_rating,
    days_since_release -- Added to match the Tension 4 write-up!
FROM enhanced_events
