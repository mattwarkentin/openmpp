# Model Extras

Functions for retrieving extra model information, including language
lists, word lists, profiles, and profile lists. More information about
these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#get-model-extras).

## Usage

``` r
get_model_lang_list(model)

get_model_word_list(model)

get_model_profile(model, profile)

get_model_profile_list(model)
```

## Arguments

- model:

  Model digest or model name.

- profile:

  Profile name.

## Value

A `list` from a JSON response object.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_model_lang_list('RiskPaths')
} # }
```
