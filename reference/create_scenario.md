# Manage Model Scenarios

Manage Model Scenarios

## Usage

``` r
create_scenario(model, name, base = NULL)

create_workset(model, name, base = NULL)
```

## Arguments

- model:

  Model name or digest.

- name:

  New scenario name.

- base:

  Base run digest (optional).

## Value

Nothing, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
create_scenario("RiskPaths", "NewScenario")
} # }

```
