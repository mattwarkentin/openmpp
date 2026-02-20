# Update Modeling Tasks

Functions for updating modeling tasks. More information about these API
endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-modeling-tasks).

## Usage

``` r
create_task(data)

update_task(data)

delete_task(model, task)
```

## Arguments

- data:

  Data used for the body of the request.

- model:

  Model digest or model name.

- task:

  Modeling task.

## Value

A `list`, `tibble`, or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
create_task(list(
  ModelName = "RiskPaths",
  ModelDigest = "d976aa2fb999f097468bb2ea098c4daf",
  Name = "NewTask",
  Set = list("Default")
))
delete_task("RiskPaths", "NewTask")
} # }
```
