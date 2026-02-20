# Update Model Runs

Functions to update model runs. More information about these API
endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-model-runs).

## Usage

``` r
delete_model_run(model, run)

delete_run(model, run)

delete_model_runs(model)

delete_runs(model)
```

## Arguments

- model:

  Model digest or model name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

## Value

A `list`, `tibble`, or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
delete_model_run("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137")
} # }
```
