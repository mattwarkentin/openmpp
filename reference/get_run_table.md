# Read Output Tables

Functions for retrieving output tables from model runs. More information
about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#read-parameters-output-tables-or-microdata-values).

## Usage

``` r
get_run_table(model, run, name)

get_run_table_csv(model, run, name)

get_run_table_acc_csv(model, run, name)

get_run_table_calc_csv(model, run, name, calc)

get_run_table_comparison_csv(model, run, name, compare, variant)
```

## Arguments

- model:

  Model digest or model name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

- name:

  Output table name.

- calc:

  Name of calculation. One of `"avg"`, `"sum"`, `"count"`, `"max"`,
  `"min"`, `"var"`, `"sd"`, `"se"`, or `"cv"`.

- compare:

  Comparison to calculate. One of `"diff"`, `"ratio"`, or `"percent"`.
  Comparisons are for the base run relative to the variant run (i.e.,
  for `"diff"` it is the difference of values represented as Variant -
  Base).

- variant:

  Run digest, name, or stamp for the variant model run.

## Value

A `list` or `tibble`.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_run_table_csv("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137", "T01_LifeExpectancy")
} # }
```
