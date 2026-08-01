# Tariff Policy and Cross-Border Trade: Difference-in-Differences Portfolio Project

This repository is a portfolio version of an Economic Big Data Analysis coursework project. It studies whether a tariff-policy shock is associated with changes in Chinese provincial exports to affected destination markets using a province-destination-month panel and fixed-effects difference-in-differences models.

## Research Question

Did the tariff-policy event reduce Chinese provincial exports to treated destination markets after the policy shock, relative to comparable destination markets?

## Why This Project Matters

The project connects trade policy, applied econometrics, and reproducible data work. It is designed to show graduate-level preparation in:

- panel-data construction
- difference-in-differences reasoning
- fixed effects
- clustered standard errors
- parallel-trend checks
- placebo/robustness checks
- transparent limitations

## Existing Frameworks Used

This repo adapts workflow patterns from official and educational DID resources:

- Stata official DID examples: https://www.stata.com/features/overview/difference-in-differences-DID-DDD/
- Coding for Applied Economists DID notes: https://jdavidm.github.io/learn-stata/materials/12-did/
- DID Handbook: https://github.com/IanHo2019/DID_Handbook
- JEL DiD replication materials: https://psantanna.com/JEL-DiD/

The economics question, data schema, interpretation, and portfolio packaging are customized for Liu Xuan's application materials.

## Repository Structure

```text
tariff-trade-did-analysis/
  README.md
  LICENSE
  .gitignore
  code/
    tariff_trade_did.do
  data/
    README.md
    sample_panel.csv
  docs/
    one_page_abstract.md
    data_dictionary.md
  outputs/
    README.md
```

## Data Schema

The expected panel is province-destination-month:

- `province`: Chinese province name or anonymized province code
- `destination`: export destination country or anonymized destination code
- `month`: monthly date
- `export_value`: export value
- `ln_export`: log export value
- `treated`: 1 if destination belongs to the tariff-affected group
- `post`: 1 after the policy event
- `did`: `treated * post`
- `exchange_rate`: RMB/USD or relevant exchange-rate control
- `province_gdp_growth`: province-level GDP growth control
- `inflation`: inflation control

## Main Specification

The baseline model is:

```text
ln_export_{pdm} = beta * (treated_d x post_m)
                 + province fixed effects
                 + destination fixed effects
                 + month fixed effects
                 + controls
                 + error_{pdm}
```

where `p` is province, `d` is destination, and `m` is month.

## How To Run

1. Put your cleaned panel data in `data/clean_trade_panel.csv`.
2. Open Stata.
3. Run:

```stata
do code/tariff_trade_did.do
```

4. Export tables and figures into `outputs/`.

The included `data/sample_panel.csv` is only a tiny synthetic example so that the repo structure is understandable before the real/anonymized data is added.

## Confidentiality

Do not upload private course files, paid database exports, confidential raw data, or any data whose redistribution is not allowed. If the original dataset cannot be shared, include a data dictionary, synthetic sample, and reproducible code that runs after the user places the private data locally.

## Portfolio Summary

This project demonstrates my transition from descriptive market/data summaries toward empirical economic analysis. The core skill is not simply running a regression, but defining treatment and comparison groups, checking whether the identifying comparison is credible, and explaining the limits of causal interpretation.

