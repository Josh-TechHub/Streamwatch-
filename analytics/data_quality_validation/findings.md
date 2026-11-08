# StreamWatch — Data Quality & Validation

## 1. Overview

This stage evaluates the quality, consistency and analytical readiness of the StreamWatch dataset stored in Snowflake under `STREAMWATCH_DB.RAW`.

| Table | Rows | Type |
|---|---:|---|
| `FCT_WATCH_EVENTS` | 6,000 | Transient |
| `DIM_USERS` | 200 | Transient |
| `DIM_CONTENT` | 400 | Transient |
| `WATCH_EVENTS_FLAT` | 6,000 | Regular |

The analytical model consists of one fact table and two dimensions:

- **FCT_WATCH_EVENTS:** One row per watch event.
- **DIM_USERS:** User attributes, including country and subscription tier.
- **DIM_CONTENT:** Content attributes, including title, genre, release date and duration.

## 2. Data Quality Assessment

The following checks were performed across the analytical tables:

- NULL and empty string validation.
- Duplicate record and key validation.
- Referential integrity validation.
- Numeric value validation.

### Missing Values

The only identified missing values were in `RATING_GIVEN`.

| Metric | Result |
|---|---:|
| Events without ratings | 4,528 |
| Total events | 6,000 |
| Missing rating percentage | 75.47% |

Ratings are treated as optional. Events without ratings were retained because missing feedback does not invalidate the associated viewing activity.

NULL ratings will be excluded from rating-specific calculations where appropriate.

### Other Data Quality Checks

| Validation | Finding |
|---|---|
| Empty strings | None identified |
| Duplicate event IDs and fact keys | None identified |
| Duplicate user IDs and keys | None identified |
| Duplicate content IDs and keys | None identified |
| Missing user references | 0 |
| Missing content references | 0 |
| User/content identifier mismatches | 0 |
| Negative viewing durations | 0 |
| Completion percentages outside 0–100 | 0 |
| Ratings outside 1–5 | 0 |
| Invalid completion flags | 0 |

No invalid values or inconsistencies were identified in the fields examined.

## 3. Temporal Validation

The observation period runs from **28 June 2022 to 30 June 2024**.

| Metric | Result |
|---|---:|
| First recorded watch date | 28 June 2022 |
| Last recorded watch date | 30 June 2024 |
| Distinct dates with events | 685 |
| Dates without recorded events | 49 |

Additional checks confirmed:

- No watch events occurred before their corresponding content release dates.
- No mismatches were found between `DAYS_SINCE_RELEASE` and independently calculated date differences.

The 49 dates without recorded events do not, by themselves, establish whether there was no activity or a recording gap.

## 4. Business Rule Validation

### Viewing Duration vs. Content Duration

| Comparison | Events | Percentage |
|---|---:|---:|
| Below content duration | 5,980 | 99.67% |
| Equal to content duration | 20 | 0.33% |
| Above content duration | 0 | 0% |

No viewing durations exceeded their corresponding content durations. However, viewing less than the full duration does not automatically mean an event was incomplete.

### Completion Percentage vs. Completed Flag

| Completion Range | Flag 0 | Flag 1 |
|---|---:|---:|
| Below 80% | 3,553 | 0 |
| 80–84.99% | 721 | 0 |
| 85–89.99% | 557 | 168 |
| 90–94.99% | 171 | 458 |
| 95–99.99% | 0 | 352 |
| 100% | 0 | 20 |
| **Total** | **5,002** | **998** |

`COMPLETION_PCT` is calculated in the intermediate dbt model, while `COMPLETED_FLAG` is retained from the source data.

The two fields do not follow one consistent percentage cutoff. The source completion flag was therefore retained without modification.

### Rating Distribution

| Rating | Events | Percentage |
|---|---:|---:|
| 1 | 168 | 11.39% |
| 2 | 375 | 25.42% |
| 3 | 367 | 24.88% |
| 4 | 328 | 22.22% |
| 5 | 234 | 15.85% |
| **Total** | **1,472** | **100%** |

The `IS_HIGH_RATING` transformation was also validated:

- Ratings 1–3 are classified as `FALSE`.
- Ratings 4–5 are classified as `TRUE`.
- Unrated events are also classified as `FALSE` by the current transformation.

Unrated events must not be interpreted as low-rated events. Rating-specific analysis should exclude NULL ratings where appropriate.

## 5. Initial Event Distribution

A preliminary breakdown of viewing events was performed across three business dimensions.

**Device Type**

| Device | Watch Events |
|---|---:|
| Mobile | 2,713 |
| TV | 1,772 |
| Desktop | 934 |
| Tablet | 581 |

**Subscription Tier**

| Tier | Watch Events |
|---|---:|
| Premium | 2,110 |
| Basic | 2,083 |
| Free | 1,807 |

**Content Genre**

| Genre | Watch Events |
|---|---:|
| Drama | 860 |
| Thriller | 832 |
| Comedy | 799 |
| Action | 666 |
| Sci-Fi | 577 |
| Reality | 558 |
| Romance | 491 |
| Documentary | 475 |
| Kids | 382 |
| Horror | 360 |

These figures represent viewing-event counts, not distinct users or content items. A user can generate multiple events.

## 6. Analytical Data Model & Considerations

The fact table uses surrogate keys to connect viewing events to the user and content dimensions.

The dimension models retain the latest observed record for each user and content item through `ROW_NUMBER()` ranking.

**Modelling limitation:** Historical changes to user and content attributes are not preserved.

Other considerations for subsequent analysis:

- Subscription tier is a segmentation variable, not verified revenue or profitability.
- Cohort analysis measures observed viewing retention, not confirmed subscription retention.
- Missing ratings must be treated separately from low ratings.
- Dates without recorded events should not automatically be interpreted as zero activity.

## 7. Overall Assessment

The initial data quality, temporal consistency, business rule and analytical model checks have been completed.

No duplicate identifiers, empty strings, unmatched dimension references or invalid numeric values were identified in the checks performed. The missing ratings were documented and retained as optional feedback.

**The analytical dataset is ready for business-focused analysis**, with the documented limitations considered when interpreting results.

The next stage focuses on user engagement, content performance, device usage and subscription-tier activity using SQL.