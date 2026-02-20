# Update Workset Metadata

Functions for creating, copying, merging, retrieving, and deleting
worksets. More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-model-workset-set-of-input-parameters).

## Usage

``` r
set_workset_readonly(model, set, readonly)

new_workset(data)

merge_workset(workset)

update_workset_param_csv(workset, csv)

replace_workset(workset)

delete_workset(model, set)

delete_scenario(model, set)

delete_workset_param(model, set, name)

update_workset_param(model, set, name, data)

copy_param_run_to_workset(model, set, name, run)

merge_param_run_to_workset(model, set, name, run)

copy_param_workset_to_workset(model, set, name, from)

merge_param_workset_to_workset(model, set, name, from)

upload_workset_params(model, set, data)
```

## Arguments

- model:

  Model digest or model name.

- set:

  Name of workset (input set of model parameters).

- readonly:

  Boolean. Should workset be read-only?

- data:

  Data used for the body of the request.

- workset:

  Workset metadata.

- csv:

  CSV file path.

- name:

  Output table name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

- from:

  Source workset name.

## Value

A `list`, `tibble`, or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
set_workset_readonly("RiskPaths", "Default", TRUE)
} # }
```
