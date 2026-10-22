WITH content AS (

    SELECT * FROM {{ ref('int_content_deduped') }}

)
SELECT
    {{ dbt_utils.generate_surrogate_key(['content_id']) }} AS content_key,
    content_id,
    content_title,
    content_genre,
    content_release_date,
    content_duration_minutes

FROM content