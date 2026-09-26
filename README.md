# Global Fuel Price Forecasting

## Table of Contents
- [Project Overview](#project-overview)
- [The Ask](#the-ask)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Preparation (SQL)](#data-preparation-sql)
- [Forecasting Model (Python)](#forecasting-model-python)
- [Dashboard (Power BI)](#dashboard-power-bi)
- [Findings](#findings)
- [Limitations](#limitations)
- [Real-World Context: Nigeria's 2023 Subsidy Removal](#real-world-context-nigerias-2023-subsidy-removal)
- [Conclusion](#conclusion)
- [Applications](#applications)
- [Project Files](#project-files)

---

## Project Overview

This project forecasts weekly retail petrol price shifts across 84 countries using Brent crude oil movements and examines how fuel subsidy policy affects both price level and price stability.

## The Ask

How much does fuel subsidy policy protect consumers from globalcrude oil price swings?

## Data Sources

Weekly fuel price data (2020-2026) across 84 countries, including petrol/diesel/LPG prices, Brent crude, subsidy level, income level and region.

## Tools

- **SQL** - feature engineering with window functions
- **Python (pandas & scikit-learn)** — forecasting model
- **Power BI** — interactive dashboard

## Data Preparation (SQL)

Built lagged crude and retail price features (1-4 weeks back) and a week-over-week crude change signal using `LAG()` window functions, partitioned by country and ordered by date.

## Forecasting Model (Python)

Predicted the week-over-week price shift using a gradient boosting model (I did not use the raw price level, so as to avoid the model simply copying last week's price). Used a time-based train/test split to avoid leaking future data into training.

**Results:**
- MAE: 0.024 vs. 0.035 for a naive "no change" baseline (32% better)
- R²: 0.60

**Top features:** week-over-week crude change (74%), low subsidy
level (16%)

## Dashboard (Power BI)

<img width="1421" height="611" alt="Screenshot (209)" src="https://github.com/user-attachments/assets/8ad24d3d-73d2-4985-9e73-a90fc2e38dbe" />

- Actual vs. predicted price by country (with country slicer)

<img width="1332" height="639" alt="Screenshot (208)" src="https://github.com/user-attachments/assets/5277d9f8-fb0b-408d-b0a8-587e3cebc926" />

- Average price and price volatility by subsidy level
- Average price by region
- Africa and Nigeria comparison cards

## Findings

Crude oil price changes are the biggest driver of retail price shifts. Subsidy level is the second biggest factor, low-subsidy countries pay more and see bigger price swings while high-subsidy countries pay less and stay steadier.

Africa's average price ($1.74) sits close to the global average. Nigeria's average price ($0.24) is far lower.

## Limitations

This dataset assigns each country one fixed subsidy level for the full 2020-2026 period. It does not reflect real policy changes over time such as Nigeria's 2023 fuel subsidy removal. The subsidy-price pattern should be read across countries, not as a timeline of any single country's policy history.

## Real-World Context: Nigeria's 2023 Subsidy Removal

This dataset does not capture Nigeria's actual subsidy removal, but real-world outcomes are worth noting for context.

In May 2023, Nigeria ended its long-standing fuel subsidy. Pump prices rose sharply, from roughly ₦185 per liter in 2023 to over ₦1,000 per liter by 2024. Combined with a weaker naira, this drove national inflation to some of its highest levels in decades and raised the cost of transport, food, and everyday goods. The World Bank projected millions more Nigerians could fall below the poverty line as a result. The removal freed up government funds previously spent on the subsidy, but the change was sudden, and many citizens faced immediate hardship without much cushioning in place.

This shows the real stakes behind the subsidy-price pattern in this dashboard which is, subsidy removal can improve government finances but the short-term cost to consumers can be severe, particularly for lower income households.

**Sources:**
- [The Conversation — Nigeria's fuel subsidy removal was too sudden](https://theconversation.com/nigerias-fuel-subsidy-removal-was-too-sudden-why-a-gradual-approach-would-have-been-better-222224)
- [The Guardian Nigeria — Impact of fuel subsidy removal on Nigeria's economy](https://guardian.ng/opinion/impact-of-fuel-subsidy-removal-on-nigerias-economy/)

## Conclusion

Subsidies don't just lower fuel prices, they also protect consumers from volatility. Countries without subsidy protection are both more expensive and less predictable.

## Applications

Beyond the country-level pricing pattern, this analysis illustrates a risk factor relevant to businesses exposed to crude oil markets.

Fuel cost volatility doesn't stop at the business level either. In low-subsidy markets, sharp fuel price swings raise transport fares and the cost of moving goods, which pushes up prices for food and everyday items. This falls hardest on lower income households who spend a larger share of what they earn on transport and basic goods. The pattern shown in this dashboard and the real-world impact of Nigeria's 2023 subsidy removal described above, point to the same conclusion which is fuel price instability affects not just business costs but ordinary people's cost of living.

Project Files
 - sql/fuel_price_feature_engineering.sql
 - python/fuel_price_forecasting.ipynb
 - data/forecast_results.csv
 - powerbi/fuel_price_dashboard.pbix
