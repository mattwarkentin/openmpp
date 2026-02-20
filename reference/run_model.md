# Run Models and Monitor Progress

More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#run-models-run-models-and-monitor-progress).

## Usage

``` r
run_model(data)

get_model_run_state(model, stamp)

get_run_state(model, stamp)

stop_model_run(model, stamp)

stop_run(model, stamp)
```

## Arguments

- data:

  Data used for the body of the POST request.

- model:

  Model digest or name.

- stamp:

  Model run stamp.

## Value

A `list` or nothing, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_model_run_state("RiskPaths", "2025_01_28_21_00_48_385")
} # }
```
