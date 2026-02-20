# OpenM++ ModelRunSet Class

OpenM++ ModelRunSet Class

## Usage

``` r
load_model_runs(model, runs)

load_runs(model, runs)
```

## Arguments

- model:

  Model name or digest.

- runs:

  Character vector of model run names, digests, or stamps.

## Value

An `OpenMppModelRunSet` instance.

## Details

`load_runs()` is an alias for `load_model_runs()`.

## Public fields

- `ModelDigest`:

  Model digest.

- `ModelName`:

  Model name.

- `ModelVersion`:

  Model version.

- `OpenMppType`:

  OpenM++ object type (used for
  [`print()`](https://rdrr.io/r/base/print.html)).

- `Tables`:

  Model run output tables

## Active bindings

- `RunNames`:

  Run names.

- `RunDigests`:

  Run digests.

- `RunStamps`:

  Run stamps.

- `RunStatuses`:

  Run statuses.

- `RunMetadatas`:

  Run metadatas.

## Methods

### Public methods

- [`OpenMppModelRunSet$new()`](#method-OpenMppModelRunSet-new)

- [`OpenMppModelRunSet$print()`](#method-OpenMppModelRunSet-print)

- [`OpenMppModelRunSet$get_table()`](#method-OpenMppModelRunSet-get_table)

- [`OpenMppModelRunSet$get_table_calc()`](#method-OpenMppModelRunSet-get_table_calc)

- [`OpenMppModelRunSet$write_table()`](#method-OpenMppModelRunSet-write_table)

- [`OpenMppModelRunSet$write_tables()`](#method-OpenMppModelRunSet-write_tables)

------------------------------------------------------------------------

### Method `new()`

Create a new OpenMppModelRunSet object.

#### Usage

    OpenMppModelRunSet$new(model, runs)

#### Arguments

- `model`:

  Model digest or name.

- `runs`:

  Run digests, run stamps, or run names.

#### Returns

A new `OpenMppModelRunSet` object.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print a `OpenMppModelRunSet` object.

#### Usage

    OpenMppModelRunSet$print(...)

#### Arguments

- `...`:

  Not currently used.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `get_table()`

Retrieve a table.

#### Usage

    OpenMppModelRunSet$get_table(name)

#### Arguments

- `name`:

  Table name.

#### Returns

A `tibble`.

------------------------------------------------------------------------

### Method `get_table_calc()`

Retrieve a table calculation.

#### Usage

    OpenMppModelRunSet$get_table_calc(name, calc)

#### Arguments

- `name`:

  Table name.

- `calc`:

  Name of calculation. One of `"avg"`, `"sum"`, `"count"`, `"max"`,
  `"min"`, `"var"`, `"sd"`, `"se"`, or `"cv"`.

#### Returns

A `tibble`.

------------------------------------------------------------------------

### Method `write_table()`

Write an output table to disk (CSV).

#### Usage

    OpenMppModelRunSet$write_table(name, file)

#### Arguments

- `name`:

  Table name.

- `file`:

  File path.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `write_tables()`

Write all output tables to disk (CSV).

#### Usage

    OpenMppModelRunSet$write_tables(dir)

#### Arguments

- `dir`:

  Directory path.

#### Returns

Self, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
load_model_runs("RiskPaths", rep("53300e8b56eabdf5e5fb112059e8c137", 2))
load_runs("RiskPaths", rep("53300e8b56eabdf5e5fb112059e8c137", 2))
} # }
```
