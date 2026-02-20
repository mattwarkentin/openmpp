# Update Model Profile

Functions for creating, modifying, and deleting profiles and profile
options. More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#update-model-profile-set-of-key-value-options).

## Usage

``` r
touch_model_profile(model, data)

delete_model_profile(model, profile)

set_model_profile_opt(model, profile, key, value)

delete_model_profile_opt(model, profile, key)
```

## Arguments

- model:

  Model digest or model name.

- data:

  Data used for the body of the request.

- profile:

  Profile name.

- key:

  Option key.

- value:

  Option value.

## Value

A `list` from a JSON response object or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
touch_model_profile(
  "RiskPaths",
  list(Name = "profile1", Opts = list(Parameter.StartingSeed = "192"))
)
delete_model_profile("RiskPaths", "profile1")
} # }
```
