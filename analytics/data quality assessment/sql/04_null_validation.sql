-- FCT_WATCH_EVENT

SELECT * FROM STREAMWATCH_DB.RAW.FCT_WATCH_EVENTS;
DESCRIBE TABLE STREAMWATCH_DB.RAW.FCT_WATCH_EVENTS;
-- null count of records in fct_watch_events
SELECT 
    SUM(
    CASE 
        WHEN EVENT_ID IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_event_id,
    SUM(
    CASE 
        WHEN USER_ID IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_user_id,
    SUM(
    CASE
        WHEN CONTENT_ID IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_content_id,
    SUM(
     CASE 
        WHEN RATING_GIVEN IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_rating,
    SUM(
    CASE
        WHEN WATCH_DATE IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_watch_date,
    SUM(
    CASE 
        WHEN DEVICE_TYPE IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_device_type,
    SUM(
    CASE 
        WHEN MINUTES_WATCHED IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_minutes_watch,
    SUM(
    CASE
        WHEN COMPLETION_PCT IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_completion_pct
FROM STREAMWATCH_DB.RAW.FCT_WATCH_EVENTS;
-- missing rating percentage
SELECT
    SUM(
        CASE
            WHEN RATING_GIVEN IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_ratings,
    COUNT(*) AS total_events,
    ((missing_ratings / total_events) * 100.0) AS missing_rating_pct
FROM STREAMWATCH_DB.RAW.FCT_WATCH_EVENTS;



-- DIM_USER 

SELECT * FROM STREAMWATCH_DB.RAW.DIM_USERS;
DESCRIBE TABLE STREAMWATCH_DB.RAW.DIM_USERS;
-- null count of records in dim_users
SELECT
    SUM(
    CASE  
        WHEN USER_ID IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_user_id,
    SUM(
    CASE
        WHEN USER_NAME IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_user_name,
    SUM(
    CASE
        WHEN USER_SUBSCRIPTION_TIER IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_subscription,
    SUM(
    CASE 
        WHEN USER_COUNTRY IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_user_country
FROM STREAMWATCH_DB.RAW.DIM_USERS;



-- DIM_CONTENT TABLE

SELECT * FROM STREAMWATCH_DB.RAW.DIM_CONTENT;
DESCRIBE TABLE STREAMWATCH_DB.RAW.DIM_CONTENT;
-- null count of records in dim_content
SELECT
    SUM(
    CASE  
        WHEN CONTENT_ID IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_content_id,
    SUM(
    CASE
        WHEN CONTENT_TITLE IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_content_title,
    SUM(
    CASE
        WHEN CONTENT_GENRE IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_content_genre,
    SUM(
    CASE
        WHEN CONTENT_RELEASE_DATE IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_content_release_date,
    SUM(
    CASE
        WHEN CONTENT_DURATION_MINUTES IS NULL THEN 1
        ELSE 0
    END
    ) AS missing_content_duration
    FROM STREAMWATCH_DB.RAW.DIM_CONTENT;