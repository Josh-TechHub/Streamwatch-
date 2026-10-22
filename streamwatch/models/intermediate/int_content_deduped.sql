WITH stg AS (
    SELECT * FROM {{ ref('stg_watch_events') }}
),

ranked AS (
    SELECT
        content_id,
        content_title,
        content_genre,
        content_release_date,
        content_duration_minutes,
        watch_date,
        ROW_NUMBER() OVER (
            PARTITION BY content_id
            ORDER BY watch_date DESC
        ) AS rn
    FROM stg
)

SELECT
    content_id,
    content_title,
    content_genre,
    content_release_date,
    content_duration_minutes
FROM ranked
WHERE rn = 1