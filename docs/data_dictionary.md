# Data Dictionary

| Variable | Type | Description |
| --- | --- | --- |
| `province` | string | Province name or anonymized province code. |
| `destination` | string | Export destination country or anonymized destination code. |
| `month` | string | Monthly period, recommended Stata format after import: `%tm`. |
| `export_value` | numeric | Export value in consistent currency/unit. |
| `ln_export` | numeric | Natural log of export value. If missing, generate with `ln(export_value)`. |
| `treated` | binary | 1 for tariff-affected destination group, 0 for comparison destination group. |
| `post` | binary | 1 for months after the policy event, 0 before. |
| `did` | binary | Interaction term: `treated * post`. Generated in the do-file. |
| `exchange_rate` | numeric | Exchange-rate control, such as RMB/USD. |
| `province_gdp_growth` | numeric | Province-level GDP growth control. |
| `inflation` | numeric | Inflation control. |

## Notes

- Use consistent units across all months.
- If original data cannot be shared, keep raw data outside GitHub and commit only this dictionary plus a synthetic sample.
- Before publishing, check that destination treatment assignment and policy date are factually accurate.

