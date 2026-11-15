# StreamWatch | Core Business Analysis Findings

## Overview

This document presents the findings from the core business analysis of StreamWatch, a fictional streaming platform.

Using SQL in Snowflake, the analysis explored four areas of platform performance:

1. User engagement
2. Content performance and audience preferences
3. Subscription and device behaviour
4. Geographic engagement

The objective was to understand how users interact with the platform, what content attracts viewing activity, and how engagement varies across subscription tiers, devices, and markets.

**Dataset overview:**

- 6,000 viewing events
- 200 registered users
- 400 content records
- 10 content genres
- 10 geographical markets
- 4 device types

---

## 1. User Engagement

The first stage examined how viewing activity was distributed across registered users and whether a small group of users accounted for a disproportionate share of platform consumption.

### Key Findings

| Metric                            |        Result |
| --------------------------------- | ------------: |
| Registered users                  |           200 |
| Users with recorded activity      |           200 |
| Activity coverage                 |          100% |
| Total platform watch time         | 7,461.7 hours |
| Average watch time per user       |   37.31 hours |
| Median watch time per user        |   36.57 hours |
| Top 10 users' share of watch time |         7.09% |

All 200 registered users had at least one recorded viewing event during the observation period.

The 10 highest-consuming users accounted for 528.9 hours, representing 7.09% of total platform watch time. Although these users represent 5% of the user base, they did not account for a disproportionately large share of viewing activity.

Average watch time per user was 37.31 hours, slightly above the median of 36.57 hours. This suggests that consumption around the centre of the distribution was relatively balanced, although higher-consuming users may have slightly increased the average.

**Key takeaway:** Viewing activity was distributed across a broad user base rather than being heavily concentrated among a small group of high-consuming users.

---

## 2. Content Performance and Audience Preferences

This analysis examined genre engagement, viewing completion, content age, and audience ratings to understand how content performed beyond viewing volume alone.

### 2.1 Genre Performance

- Drama recorded the highest total watch time.
- Thriller and Horror showed relatively strong completion performance.
- Genre popularity and completion performance did not necessarily move together.

**Finding:** The genres attracting the most viewing time were not automatically the genres with the strongest completion performance.

### 2.2 Viewing Completion

| Metric               | Result |
| -------------------- | -----: |
| Total viewing events |  6,000 |
| Completed events     |    998 |
| Non-completed events |  5,002 |
| Completion rate      | 16.63% |
| Non-completion rate  | 83.37% |

Further investigation of non-completed events showed:

- Average completion progress: 69.36%
- Median completion progress: 72.03%
- Average watch duration: 70.35 minutes

This indicates that many events not marked as completed still recorded substantial viewing progress.

**Finding:** A low recorded completion rate does not necessarily mean viewers stopped watching shortly after starting.

*&#x20;Note: A non-completed event means the event was not marked as completed on the streamwatch backend system. It does not independently establish deliberate abandonment.*

### 2.3 Content Age and Performance

| Content Age | Viewing Events | Completion Rate |
| ----------- | -------------: | --------------: |
| 0–2 years   |            315 |          16.83% |
| 3–5 years   |          1,631 |          16.92% |
| 6–8 years   |          1,917 |          16.54% |
| 9–12 years  |          2,137 |          16.47% |

*Important Note: Content age is the duration of the content since its release date. The column was measured using a scalar expression "FLOOR()" that uses the CURRENT_DATE() which is the most recent date the data has to offer, and the CONTENT_RELEASE_DATE column to express the release dates of each streamwatch content in years.*

Content aged 9–12 years generated the highest viewing activity, while content aged 0–2 years recorded the fewest events.

However, completion rates remained relatively similar across all age groups, ranging from 16.47% to 16.92%.

**Finding:** Older content continued to attract substantial viewing activity, while newer content did not demonstrate a significant completion advantage.

### 2.4 Audience Ratings

A total of 1,472 viewing events had submitted ratings.

| Rating  | Number of Ratings |
| ------- | ----------------: |
| 1 star  |               168 |
| 2 stars |               375 |
| 3 stars |               367 |
| 4 stars |               328 |
| 5 stars |               234 |

Additional findings:

- Ratings of 1–3 accounted for 61.82%.
- Ratings of 4–5 accounted for 38.18%.
- Average genre ratings ranged from 2.93 to 3.17.
- Thriller recorded the highest average rating at 3.17.
- Action recorded the lowest average rating at 2.93.

### 2.5 Content Popularity vs. Audience Ratings

The title-level analysis revealed that higher viewing activity did not consistently translate into higher ratings.

For example:

| Content Title      | Viewing Events | Average Rating |
| ------------------ | -------------: | -------------: |
| Ordinary the Sun 2 |             24 |           3.67 |
| Hidden Deception   |             24 |           3.63 |
| Blackout Throttle  |             24 |           1.75 |

**Key takeaway:** Viewing volume, completion, and audience ratings measure different aspects of content performance. Popularity alone does not establish audience satisfaction.

---

## 3. Subscription and Device Analysis

This stage examined the distribution of subscription tiers, differences in viewing behaviour across tiers, device usage, and cross-device adoption.

### 3.1 Subscription Distribution

| Subscription Tier | Users | User Share |
| ----------------- | ----: | ---------: |
| Premium           |    70 |     35.00% |
| Basic             |    69 |     34.50% |
| Free              |    61 |     30.50% |

The subscription distribution was relatively balanced, with Premium representing the largest group by a small margin.

### 3.2 Viewing Activity by Subscription Tier

| Tier    | Viewing Events | Unique Viewers | Avg. Events per Viewer | Watch Hours |
| ------- | -------------: | -------------: | ---------------------: | ----------: |
| Premium |          2,110 |             70 |                  30.14 |    2,642.07 |
| Basic   |          2,083 |             69 |                  30.19 |    2,541.83 |
| Free    |          1,807 |             61 |                  29.62 |    2,277.80 |

Premium users generated the highest total viewing activity and watch hours.

Basic users recorded the highest average number of viewing events per viewer, although the difference between tiers was small.

### 3.3 Average Consumption by Subscription Tier

| Tier    | Avg. Minutes per Event | Avg. Watch Hours per Viewer |
| ------- | ---------------------: | --------------------------: |
| Premium |                  75.13 |                       37.74 |
| Free    |                  75.63 |                       37.34 |
| Basic   |                  73.22 |                       36.84 |

Premium users recorded the highest average watch hours per viewer, while Free users had the highest average viewing duration per event.

Basic users recorded the lowest values for both metrics.

**Finding:** Viewing behaviour was broadly similar across subscription tiers, with Premium users recording slightly higher overall consumption.

*Limitation: These comparisons use current subscription tiers. Historical subscription records are unavailable, so the analysis cannot establish whether subscription upgrades caused changes in viewing behaviour. Subscription tier is also a segmentation variable, not direct evidence of revenue or profitability.*

### 3.4 Device Distribution and Completion

| Device  | Viewing Events | Unique Viewers | Activity Share | Completed Events | Completion Rate |
| ------- | -------------: | -------------: | -------------: | ---------------: | --------------: |
| Mobile  |          2,713 |            200 |         45.22% |              448 |          16.51% |
| TV      |          1,772 |            200 |         29.53% |              294 |          16.59% |
| Desktop |            934 |            198 |         15.57% |              164 |          17.56% |
| Tablet  |            581 |            187 |          9.68% |               92 |          15.83% |

Mobile accounted for the largest share of viewing activity at 45.22%, followed by TV at 29.53%.

Desktop recorded the highest completion rate at 17.56%, while Tablet recorded the lowest at 15.83%.

The differences in completion rates were relatively small.

**Finding:** Mobile and TV were the dominant viewing devices, while desktop recorded a slightly higher completion rate.

### 3.5 Multi-Device Usage

| Number of Devices Used | Users | Percentage |
| ---------------------- | ----: | ---------: |
| 3 devices              |    15 |      7.50% |
| 4 devices              |   185 |     92.50% |

Every user accessed StreamWatch through at least three device types, while 92.5% used all four.

**Finding:** The dataset shows widespread cross-device adoption, suggesting that users access StreamWatch across different viewing environments.

However, multi-device usage alone does not establish the quality of the user experience on each device.

**My Hypothesis:** Streamwatch delivers a good user expirence across all devices, that could be because the UI of the platform is appealing and user interaction is easy and smooth.&#x20;

Out of all the 200 Users, about all of them use or have used  the StreamWatch platform on their Mobiles, and TV.  Then 198 of those users, also use StreamWatch on their Desktop, and 185 users use StreamWatch on their Tablets.

All 200 users, use StreamWatch on more than 2 platforms. They could have used a seperate streaming platform for each device, but the retained StreamWatch for 3 - 4 devices. And that could be because of the ease and appealing UI of Streamwatch across all platforms or the already subscribed account they have with StreamWatch.

The data does not cover past subscriptions for my hypothesis to be confirmed by change in user subscription tier over-time.

---

## 4. Geographic Engagement

The geographic analysis explored how viewing activity, genre engagement, and subscription composition varied across StreamWatch's ten markets.

### 4.1 Country-Level Engagement

| Country        | Unique Viewers | Viewing Events | Watch Hours | Completion Rate |
| -------------- | -------------: | -------------: | ----------: | --------------: |
| Nigeria        |             41 |          1,210 |    1,490.23 |          16.28% |
| South Africa   |             29 |            855 |    1,055.15 |          15.67% |
| United States  |             27 |            848 |    1,043.15 |          16.75% |
| United Kingdom |             19 |            602 |      741.68 |          17.94% |
| India          |             20 |            590 |      741.73 |          15.08% |
| Egypt          |             15 |            443 |      562.35 |          16.93% |
| Kenya          |             14 |            427 |      525.72 |          17.56% |
| Ghana          |             14 |            409 |      508.93 |          16.14% |
| Philippines    |             10 |            310 |      397.85 |          18.71% |
| Brazil         |             11 |            306 |      394.90 |          17.65% |

Nigeria was the largest market by viewing activity, recording 1,210 events and 1,490.23 watch hours.

However, the Philippines recorded the highest completion rate at 18.71%, followed by the United Kingdom at 17.94%. India recorded the lowest at 15.08%.

**Finding:** The largest market by viewing activity was not necessarily the market with the highest completion rate.

### 4.2 Genre Engagement Across Markets

Analysis of 100 country-genre combinations revealed recurring patterns:

- Drama led viewing activity in Nigeria, Brazil, India, South Africa, and the United States.
- Thriller led in Kenya, the Philippines, and the United Kingdom.
- Comedy led in Egypt and Ghana.
- Drama, Thriller, Comedy, and Action consistently attracted substantial viewing activity across markets.
- Kids and Reality generally recorded lower viewing activity and watch hours.

**Finding:** Several genres attracted substantial viewing activity across different markets, although the leading genre varied by country.

Viewing activity provides an indication of consumption patterns, but it does not independently establish individual preference or satisfaction.

### 4.3 Subscription Distribution Across Markets

The subscription mix differed across countries:

- Nigeria recorded the highest Premium representation at 43.90%.
- The United States followed with 40.74% Premium users.
- Ghana had the highest Free-tier representation at 50%.
- India also recorded a substantial Free-tier share at 40%.
- Kenya had the highest Basic-tier representation at 57.14%.
- Egypt and the United Kingdom had relatively balanced subscription distributions.

**Finding:** Subscription composition varies geographically, providing useful context for future market-level subscription and conversion investigations.

*Limitation: Country-level populations are relatively small, so percentage differences should be interpreted cautiously. Current subscription distribution does not establish historical conversion or market revenue.*

Although marketing stategies and product promotions are strongly advised due to the low number of users(Unique Viewers) in each country, regardless of the different population size.

---

## 5. Overall Findings

Across the four areas of core business analysis, several patterns emerged:

1. **User engagement:** Viewing activity was broadly distributed across the registered user base, with the top 10 users contributing 7.09% of total watch time.

2. **Content performance:** Viewing popularity, completion, and audience ratings did not consistently move together. Older content continued to attract substantial viewing activity.

3. **Subscription behaviour:** Subscription distribution was relatively balanced, and Premium users recorded the highest total watch hours. However, differences in average consumption across tiers were small.

4. **Device behaviour:** Mobile generated the largest share of viewing activity, while 92.5% of users accessed the platform through all four device types.

5. **Geographic engagement:** Nigeria was the largest market by viewing activity, while smaller markets recorded higher completion rates. Genre engagement and subscription composition also varied across countries.

## 6. Analytical Limitations

The findings should be interpreted within the limits of the available dataset:

- Recorded viewing activity does not necessarily indicate current or recurring engagement.
- Non-completed events do not automatically represent deliberate abandonment.
- Current subscription tiers cannot establish historical subscription changes or conversion.
- Subscription tiers do not provide direct evidence of revenue or profitability.
- Viewing activity does not independently establish content preference or satisfaction.
- Small country-level populations can make percentage comparisons less stable.
- Observed differences do not establish causation.

## Conclusion

The core business analysis provides an initial understanding of how StreamWatch users consume content and interact with the platform.

The findings show that engagement is distributed across a broad user base, content popularity does not always align with completion or ratings, mobile drives the largest share of viewing activity, and engagement patterns vary across geographical markets.

