# Model Run Results Metadata

Functions to retrieve model run metadata and delete model runs. More
information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#get-model-run-results-metadata).

## Usage

``` r
get_model_run(model, run)

get_run(model, run)

get_model_runs_list(model)

get_model_runs(model)

get_runs(model)

get_model_run_status(model, run)

get_run_status(model, run)

get_model_run_list_status(model, run)

get_model_run_status_first(model)

get_model_run_status_last(model)

get_model_run_status_compl(model)
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
get_model_run("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137")
get_run("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137")
get_model_runs_list("RiskPaths")
get_model_runs("RiskPaths")
} # }

```
