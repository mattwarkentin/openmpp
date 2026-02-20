# Read Parameters

Functions for retrieving parameters from worksets or model runs. More
information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#read-parameters-output-tables-or-microdata-values).

## Usage

``` r
get_workset_param(model, set, name)

get_workset_param_csv(model, set, name)

get_run_param(model, run, name)

get_run_param_csv(model, run, name)
```

## Arguments

- model:

  Model digest or model name.

- set:

  Name of workset (input set of model parameters).

- name:

  Output table name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

## Value

A `list` or `tibble`.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_workset_param("RiskPaths", "Default", "AgeBaselinePreg1")
} # }
```
