# OpenM++ Workset Class

OpenM++ Workset Class

## Usage

``` r
load_workset(model, set)

load_scenario(model, set)
```

## Arguments

- model:

  Model digest or model name.

- set:

  Name of workset (input set of model parameters).

## Value

An `OpenMppWorkset` instance.

## Details

`load_scenario()` is an alias for `load_workset()`.

## Super class

[`openmpp::OpenMppModel`](https://mattwarkentin.github.io/openmpp/reference/load_model.md)
-\> `OpenMppWorkset`

## Public fields

- `WorksetName`:

  Workset name.

- `WorksetMetadata`:

  Workset metadata.

- `OpenMppType`:

  OpenM++ object type (used for
  [`print()`](https://rdrr.io/r/base/print.html)).

- `Parameters`:

  Workset parameters.

## Active bindings

- `ReadOnly`:

  Workset read-only status.

- `BaseRunDigest`:

  Base run digest for input parameters.

## Methods

### Public methods

- [`OpenMppWorkset$new()`](#method-OpenMppWorkset-new)

- [`OpenMppWorkset$print()`](#method-OpenMppWorkset-print)

- [`OpenMppWorkset$set_base_digest()`](#method-OpenMppWorkset-set_base_digest)

- [`OpenMppWorkset$delete_base_digest()`](#method-OpenMppWorkset-delete_base_digest)

- [`OpenMppWorkset$copy_params()`](#method-OpenMppWorkset-copy_params)

- [`OpenMppWorkset$delete_params()`](#method-OpenMppWorkset-delete_params)

- [`OpenMppWorkset$get_param()`](#method-OpenMppWorkset-get_param)

- [`OpenMppWorkset$set_param()`](#method-OpenMppWorkset-set_param)

- [`OpenMppWorkset$run()`](#method-OpenMppWorkset-run)

------------------------------------------------------------------------

### Method `new()`

Create a new OpenMppWorkset object.

#### Usage

    OpenMppWorkset$new(model, set)

#### Arguments

- `model`:

  Model digest or name.

- `set`:

  Workset name.

#### Returns

A new `OpenMppWorkset` object.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print a `OpenMppWorkset` object.

#### Usage

    OpenMppWorkset$print(...)

#### Arguments

- `...`:

  Not currently used.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `set_base_digest()`

Set the base run digest.

#### Usage

    OpenMppWorkset$set_base_digest(base)

#### Arguments

- `base`:

  Base run digest.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `delete_base_digest()`

Delete the base run digest.

#### Usage

    OpenMppWorkset$delete_base_digest()

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `copy_params()`

Copy parameters from a base scenario.

#### Usage

    OpenMppWorkset$copy_params(names)

#### Arguments

- `names`:

  Character vector of parameter names.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `delete_params()`

Delete parameters from scenario.

#### Usage

    OpenMppWorkset$delete_params(names)

#### Arguments

- `names`:

  Character vector of parameter names.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `get_param()`

Retrieve a parameter.

#### Usage

    OpenMppWorkset$get_param(name)

#### Arguments

- `name`:

  Parameter name.

#### Returns

A `tibble`.

------------------------------------------------------------------------

### Method `set_param()`

Set a parameter.

#### Usage

    OpenMppWorkset$set_param(name, data)

#### Arguments

- `name`:

  Parameter name.

- `data`:

  New parameter data.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `run()`

Initiate a model run for the model workset/scenario.

#### Usage

    OpenMppWorkset$run(
      name,
      opts = opts_run(),
      wait = FALSE,
      wait_time = 0.2,
      progress = TRUE
    )

#### Arguments

- `name`:

  Run name.

- `opts`:

  Run options. See
  [`opts_run()`](https://mattwarkentin.github.io/openmpp/reference/opts_run.md)
  for more details.

- `wait`:

  Logical. Should we wait until the model run is done?

- `wait_time`:

  Number of seconds to wait between status checks.

- `progress`:

  Logical. Should a progress bar be shown?

#### Returns

Self, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
load_workset("RiskPaths", "Default")
load_scenario("RiskPaths", "Default")
} # }

```
