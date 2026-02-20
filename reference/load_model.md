# OpenM++ Model Class

OpenM++ Model Class

## Usage

``` r
load_model(model)
```

## Arguments

- model:

  Model digest or model name.

## Value

An `OpenMppModel` instance.

## Public fields

- `OpenMppType`:

  OpenM++ object type (used for
  [`print()`](https://rdrr.io/r/base/print.html) method).

- `ModelDigest`:

  Model digest.

- `ModelName`:

  Model name.

- `ModelVersion`:

  Model version.

- `ModelMetadata`:

  Model metadata.

- `ParamsInfo`:

  Input parameter information.

- `TablesInfo`:

  Output table information.

## Active bindings

- `ModelWorksets`:

  Data frame of worksets.

- `ModelScenarios`:

  Data frame of scenarios.

- `ModelRuns`:

  Data frame of model runs.

- `ModelTasks`:

  Data frame of model tasks.

## Methods

### Public methods

- [`OpenMppModel$new()`](#method-OpenMppModel-new)

- [`OpenMppModel$print()`](#method-OpenMppModel-print)

------------------------------------------------------------------------

### Method `new()`

Create a new OpenMppModel object.

#### Usage

    OpenMppModel$new(model)

#### Arguments

- `model`:

  Model digest or name.

#### Returns

A new `OpenMppModel` object.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print a OpenMppModel object.

#### Usage

    OpenMppModel$print(...)

#### Arguments

- `...`:

  Not currently used.

#### Returns

Self, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
load_model("RiskPaths")
} # }
```
