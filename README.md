
# StreamWatch Analytics: ELT & Dimensional Modeling

StreamWatch is an analytics engineering project where I turned a flat file of streaming activity into a structured data warehouse. I used **Python** to load the raw data, **Snowflake** to store it, and **dbt Core** to transform it into a tested **star schema**.

The goal was simple: make the data easier to trust, understand, and use for analysis.

## Project Overview

- **Dataset:** 6,000 streaming sessions
- **Tools:** Python, SQL, Snowflake, dbt Core, Git
- **Modeling approach:** Dimensional modeling (star schema)
- **Final models:** `dim_users`, `dim_content`, `fct_watch_events`

## Architecture

The pipeline moves from the original event data through staging and intermediate transformations to the final analytics models.

```text
watch_events_flat
       |
       v
stg_watch_events
       |
       +-----------------------+
       |                       |
       v                       v
int_users_deduped       int_content_deduped
       |                       |
       +-----------+-----------+
                   |
                   v
        int_watch_events_enhanced
                   |
                   v
          +--------+--------+
          |                 |
          v                 v
      dim_users         dim_content
          |                 |
          +--------+--------+
                   |
                   v
            fct_watch_events
```

The final fact table connects to the user and content dimensions through keys.

## The Data Models

| Model | Description |
|-------|-------------|
| `dim_users` | One record per unique user, including country and subscription tier. |
| `dim_content` | One record per unique content item, including title, genre, release date, and duration. |
| `fct_watch_events` | Individual streaming sessions, including watch date, device type, minutes watched, completion status, and any rating provided. |

### Understanding the Fact Table

The grain of `fct_watch_events` is **one row per watch session (`event_id`)**.

For example, if a user watches the same video three times on separate occasions, those are three distinct events and should remain three separate rows.

Generated surrogate keys connect each event to the relevant user and content records.

## How the Pipeline Works

### 1. Raw Ingestion — Python

The `ingest_raw_data.py` script loads the flat-file data into Snowflake's raw layer. This provides a starting point for transformations while keeping the source data available for comparison.

### 2. Staging — `models/staging/`

`stg_watch_events.sql` creates a consistent staging layer over the raw source data. The source configuration documents where the raw data comes from.

### 3. Intermediate Transformations — `models/intermediate/`

The intermediate models prepare the data for the final schema:

- `int_users_deduped.sql` identifies unique user records.
- `int_content_deduped.sql` identifies unique content records.
- `int_watch_events_enhanced.sql` retains the session-level records and adds useful fields such as `days_since_release`.

### 4. Analytics Models — `models/marts/`

The final models organize the data into user and content dimensions alongside the central watch-events fact table. Generated surrogate keys connect the tables and support consistent relationships between them.

## Design Decisions

An important part of this project was deciding which fields needed separate tables and which could remain in the existing models.

- **`device_type` stays in the fact table.** It has a small set of values and no additional attributes to maintain, so a separate dimension was unnecessary for this project.
- **`completed_flag` is retained from the source.** Rather than infer completion from watch duration alone, I kept the recorded status to avoid misclassifying sessions.
- **`rating_given` stays nullable in the fact table.** Ratings are optional, and creating a separate fact table for one optional field would add complexity.
- **`content_release_date` belongs in `dim_content`.** It describes the content itself, while `days_since_release` can be calculated for each viewing event.

These decisions kept the model focused on the data's analytical purpose without adding unnecessary complexity.

## Data Quality & Validation

I used dbt tests to check important parts of the model:

- `unique` and `not_null` tests for key identifiers.
- `relationships` tests to check that user and content keys in the fact table match records in their respective dimensions.
- Reconciliation queries comparing the raw source with the final fact table.

### Reconciliation Results

The final fact table contained **6,000 rows**, matching the raw source. The total `minutes_watched` also matched between the two layers.

These checks gave me confidence that the transformation process had not dropped or duplicated viewing events and that the selected measure was preserved.

## Key Practices

- Loading data into a cloud data warehouse using Python.
- Building a layered transformation workflow with dbt.
- Designing a star schema and defining fact-table grain.
- Deduplicating dimension records and generating surrogate keys.
- Testing data quality and validating transformed results against the source.
