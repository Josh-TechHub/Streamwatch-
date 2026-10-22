# StreamWatch: Day 1 Dimensional Design Defense

## 1. Fact Table Grain Declaration
* **Declared Grain:** One record per distinct watch event session (`event_id`).
* **Definition:** Each row represents a single streaming session initiated by a user for a specific content title on a given date and device.

---

## 2. Column Classification Table

| Source Column Name | Classification | Target Layer / Destination | Rationale |
| :--- | :--- | :--- | :--- |
| `event_id` | **Degenerate Dimension** | `fct_watch_events` | Unique session primary key; kept on the fact table for grain tracing without a separate dimension table. |
| `user_id` | **Foreign Key** | `fct_watch_events` | Joins to `dim_users` (`user_hk`). |
| `user_name` | **Dimension Attribute** | `dim_users` | User descriptive property. |
| `user_country` | **Dimension Attribute** | `dim_users` | User geographic attribute. |
| `user_subscription_tier` | **Dimension Attribute** | `dim_users` | User membership level (Free, Basic, Premium). |
| `content_id` | **Foreign Key** | `fct_watch_events` | Joins to `dim_content` (`content_hk`). |
| `content_title` | **Dimension Attribute** | `dim_content` | Descriptive metadata. |
| `content_genre` | **Dimension Attribute** | `dim_content` | Categorical metadata. |
| `content_release_date` | **Dimension Attribute** | `dim_content` | Static title attribute. |
| `content_duration_minutes` | **Dimension Attribute** | `dim_content` | Full runtime metric of the title. |
| `watch_date` | **Foreign Key** | `fct_watch_events` | Connects session event to `dim_date`. |
| `device_type` | **Degenerate Dimension** | `fct_watch_events` | Event categorical attribute stored directly on the fact. |
| `minutes_watched` | **Additive Measure** | `fct_watch_events` | Continuous numeric fact metric. |
| `completed_flag` | **Stored Physical Measure** | `fct_watch_events` | Pre-computed binary completion metric ($1/0$). |
| `rating_given` | **Nullable Measure** | `fct_watch_events` | Optional session metric ($1\text{--}5$). |

---

## 3. Position & Justification on the Four Design Tensions

### Tension 1: `device_type` (Junk Dimension vs. Degenerate Dimension)
* **Position:** Retained as a **Degenerate Dimension** on `fct_watch_events`.
* **Justification:** With only 4 distinct values (Mobile, TV, Desktop, Tablet) and no extra metadata attributes (like OS version or browser family), creating a separate dimension table or junk dimension creates unnecessary join operations without adding analytical value.

### Tension 2: `completed_flag` vs. `minutes_watched` (Stored Measure vs. Query-Time Derivation)
* **Position:** Retained as a **Stored Physical Measure** on `fct_watch_events`.
* **Justification:** Data analysis reveals that `completed_flag = 1` occurs when `minutes_watched` reaches ~85–90% of `content_duration_minutes` (accounting for credits/skips), rather than strict 100% mathematical completion. Recomputing `minutes_watched / content_duration_minutes >= 1.0` produces **978 incorrect completions**. Storing the physical flag preserves business definitions and enables direct additive aggregations (`SUM(completed_flag)`).

### Tension 3: Placement and Nullability of `rating_given`
* **Position:** Retained as a **Nullable Measure Column** on `fct_watch_events`.
* **Justification:** In this dataset, ratings occur synchronously at the close of a watch session. Splitting ratings into a separate `fct_ratings` table doubles DAG overhead for a single sparse metric. If future requirements allow async ratings, it can be migrated to a dedicated fact table.

### Tension 4: `content_release_date` (Attribute vs. Role-Playing Date)
* **Position:** Stored as a **Dimensional Attribute** on `dim_content`, while introducing `days_since_release` as a derived fact measure.
* **Justification:** `content_release_date` is an immutable property of the content entity, belonging on `dim_content`. However, calculating `DATEDIFF('day', content_release_date, watch_date)` on the fact table unlocks immediate query analysis on post-release streaming velocity.