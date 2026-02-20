# Manage OpenM++ User Settings

Functions for getting, setting, and deleting user settings. More
information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#user-manage-user-settings).

## Usage

``` r
get_user_views(model)

set_user_views(model, data)

delete_user_views(model)
```

## Arguments

- model:

  Model digest or model name.

- data:

  Data used for the body of the request.

## Value

A `list` from JSON response object or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_user_views("RiskPaths")
} # }
```
