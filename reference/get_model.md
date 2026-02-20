# Model Metadata

Functions to get the list of models and load a specific model
definition. More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#get-model-metadata).

## Usage

``` r
get_model(model)

get_models()

get_models_list()
```

## Arguments

- model:

  Model digest or model name.

## Value

A `list` or `tibble`.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_models()
get_models_list()
get_model("RiskPaths")
} # }
```
