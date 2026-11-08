-- FCT_WATCH_EVENT 

SELECT * FROM STREAMWATCH_DB.RAW.FCT_WATCH_EVENTS;
DESCRIBE TABLE STREAMWATCH_DB.RAW.FCT_WATCH_EVENTS;

-- empty string validation in fct_watch_event
SELECT
    SUM(
        CASE
            WHEN TRIM(EVENT_ID) = '' THEN 1
            ELSE 0
        END
    ) AS empty_event_id,

    SUM(
        CASE
            WHEN TRIM(USER_ID) = '' THEN 1
            ELSE 0
        END
    ) AS empty_user_id,

    SUM(
        CASE
            WHEN TRIM(CONTENT_ID) = '' THEN 1
            ELSE 0
        END
    ) AS empty_content_id,

    SUM(
        CASE
            WHEN TRIM(DEVICE_TYPE) = '' THEN 1
            ELSE 0
        END
    ) AS empty_device_type
FROM STREAMWATCH_DB.RAW.FCT_WATCH_EVENTS;



-- DIM_USER

SELECT * FROM STREAMWATCH_DB.RAW.DIM_USERS;
DESCRIBE TABLE STREAMWATCH_DB.RAW.DIM_USERS;

-- empty string validation in dim_user
SELECT
    SUM(
    CASE  
        WHEN TRIM(USER_ID) = '' THEN 1
        ELSE 0
    END
    ) AS empty_user_id,
    SUM(
    CASE
        WHEN TRIM(USER_NAME) = '' THEN 1
        ELSE 0
    END
    ) AS empty_user_name,
    SUM(
    CASE
        WHEN TRIM(USER_SUBSCRIPTION_TIER) = '' THEN 1
        ELSE 0
    END
    ) AS empty_user_subscription_tier,
    SUM(
    CASE 
        WHEN TRIM(USER_COUNTRY) = '' THEN 1
        ELSE 0
    END
    ) AS empty_user_country
FROM STREAMWATCH_DB.RAW.DIM_USERS;



-- DIM_CONTENT

SELECT * FROM STREAMWATCH_DB.RAW.DIM_CONTENT;
DESCRIBE TABLE STREAMWATCH_DB.RAW.DIM_CONTENT;

-- empty string validation in dim_content
SELECT
    SUM(
    CASE  
        WHEN TRIM(CONTENT_ID) = '' THEN 1
        ELSE 0
    END
    ) AS empty_content_id,
    SUM(
    CASE
        WHEN TRIM(CONTENT_TITLE) = '' THEN 1
        ELSE 0
    END
    ) AS empty_content_title,
    SUM(
    CASE
        WHEN TRIM(CONTENT_GENRE) = '' THEN 1
        ELSE 0
    END
    ) AS empty_content_genre
    FROM STREAMWATCH_DB.RAW.DIM_CONTENT;