*******************************************************
* Tariff Policy and Cross-Border Trade DID Project
* Portfolio version for Liu Xuan
*
* Framework adapted from official and educational DID
* examples. Replace sample data with cleaned/anonymized
* project data before publishing final results.
*******************************************************

clear all
set more off

* 1. Paths
global ROOT "."
global DATA "$ROOT/data"
global OUT "$ROOT/outputs"

* 2. Load data
capture confirm file "$DATA/clean_trade_panel.csv"
if _rc == 0 {
    import delimited "$DATA/clean_trade_panel.csv", clear varnames(1)
}
else {
    di as txt "clean_trade_panel.csv not found; loading synthetic sample_panel.csv"
    import delimited "$DATA/sample_panel.csv", clear varnames(1)
}

* 3. Basic cleaning
capture confirm variable ln_export
if _rc != 0 {
    gen ln_export = ln(export_value)
}

gen did = treated * post

* Convert month such as 2024m11 into Stata monthly date if needed.
capture confirm numeric variable month
if _rc != 0 {
    gen month_id = monthly(month, "YM")
    format month_id %tm
}
else {
    gen month_id = month
    format month_id %tm
}

encode province, gen(province_id)
encode destination, gen(destination_id)

* Province-destination panel identifier.
egen panel_id = group(province_id destination_id)
xtset panel_id month_id

* 4. Descriptive checks
tab treated post
summ export_value ln_export exchange_rate province_gdp_growth inflation

preserve
collapse (mean) ln_export, by(treated month_id)
twoway ///
    (connected ln_export month_id if treated == 1, lcolor(navy) mcolor(navy)) ///
    (connected ln_export month_id if treated == 0, lcolor(maroon) mcolor(maroon)), ///
    legend(order(1 "Treated destinations" 2 "Comparison destinations")) ///
    title("Average log exports before and after tariff event") ///
    xtitle("Month") ytitle("Mean log export value")
graph export "$OUT/parallel_trend_preview.png", replace
restore

* 5. Baseline DID: simple interaction model
reg ln_export i.treated##i.post, vce(cluster panel_id)
estimates store did_simple

* 6. Fixed-effects specification
areg ln_export did exchange_rate province_gdp_growth inflation i.destination_id i.month_id, ///
    absorb(province_id) vce(cluster panel_id)
estimates store did_fe

* 7. Alternative panel fixed-effects specification
xtreg ln_export did exchange_rate province_gdp_growth inflation i.month_id i.destination_id, ///
    fe vce(cluster panel_id)
estimates store did_xtfe

* 8. Placebo example
* Adjust this section after defining a real placebo month.
gen placebo_post = month_id >= tm(2024m12)
gen placebo_did = treated * placebo_post

areg ln_export placebo_did exchange_rate province_gdp_growth inflation i.destination_id i.month_id, ///
    absorb(province_id) vce(cluster panel_id)
estimates store did_placebo

* 9. Export compact text log
log using "$OUT/stata_results.smcl", replace
estimates replay did_simple
estimates replay did_fe
estimates replay did_xtfe
estimates replay did_placebo
log close

di as result "Done. Check outputs/ for figures and Stata log."

