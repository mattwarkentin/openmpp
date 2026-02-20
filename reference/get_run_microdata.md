# Read Run Microdata

Functions for retrieving microdata from model runs. More information
about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#read-parameters-output-tables-or-microdata-values).

## Usage

``` r
get_run_microdata(model, run, name)

get_run_microdata_csv(model, run, name)
```

## Arguments

- model:

  Model digest or model name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp, or
  task run name.

- name:

  Microdata entity name.

## Value

A `list` or `tibble`.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_run_microdata_csv("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137", "Person")
} # }
```
