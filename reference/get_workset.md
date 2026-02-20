# Model Workset Metadata

Functions for creating, copying, merging, retrieving, and deleting
worksets. More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#get-model-workset-metadata-set-of-input-parameters).

## Usage

``` r
get_workset(model, set)

get_worksets_list(model)

get_worksets(model)

get_scenarios(model)

get_workset_status(model, set)

get_workset_status_default(model)
```

## Arguments

- model:

  Model digest or model name.

- set:

  Name of workset (input set of model parameters).

## Value

A `list`, `tibble`, or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_worksets("RiskPaths")
get_scenarios("RiskPaths")
get_workset("RiskPaths", "Default")
} # }

```
