# Modeling Task Metadata

Functions for getting creating, updating, retrieving, and deleting model
tasks. More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#get-modeling-task-metadata-and-task-run-history).

## Usage

``` r
get_model_task(model, task)

get_model_tasks_list(model)

get_model_tasks(model)

get_model_task_worksets(model, task)

get_model_task_hist(model, task)

get_model_task_status(model, task, run)

get_model_task_run_list_status(model, task, run)

get_model_task_run_first(model, task)

get_model_task_run_last(model, task)

get_model_task_run_compl(model, task)
```

## Arguments

- model:

  Model digest or model name.

- task:

  Modeling task.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

## Value

A `list`, `tibble`, or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_model_tasks_list("RiskPaths")
get_model_tasks("RiskPaths")
} # }

```
