# OpenM++ ModelRun Class

OpenM++ ModelRun Class

## Usage

``` r
load_model_run(model, run)

load_run(model, run)
```

## Arguments

- model:

  Model digest or model name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

## Value

An `OpenMppModelRun` instance.

## Details

`load_run()` is an alias for `load_model_run()`.

## Super class

[`openmpp::OpenMppModel`](https://mattwarkentin.github.io/openmpp/reference/load_model.md)
-\> `OpenMppModelRun`

## Public fields

- `RunName`:

  Run name.

- `RunDigest`:

  Run digest.

- `RunStamp`:

  Run stamp.

- `RunMetadata`:

  Run metadata.

- `Parameters`:

  Model run parameters.

- `Tables`:

  Model run output tables

- `OpenMppType`:

  OpenM++ object type (used for
  [`print()`](https://rdrr.io/r/base/print.html)).

## Active bindings

- `RunStatusInfo`:

  Run status information.

- `RunStatus`:

  Run status.

## Methods

### Public methods

- [`OpenMppModelRun$new()`](#method-OpenMppModelRun-new)

- [`OpenMppModelRun$print()`](#method-OpenMppModelRun-print)

- [`OpenMppModelRun$get_table()`](#method-OpenMppModelRun-get_table)

- [`OpenMppModelRun$get_table_acc()`](#method-OpenMppModelRun-get_table_acc)

- [`OpenMppModelRun$get_table_calc()`](#method-OpenMppModelRun-get_table_calc)

- [`OpenMppModelRun$get_table_comparison()`](#method-OpenMppModelRun-get_table_comparison)

- [`OpenMppModelRun$write_table()`](#method-OpenMppModelRun-write_table)

- [`OpenMppModelRun$write_tables()`](#method-OpenMppModelRun-write_tables)

- [`OpenMppModelRun$get_log()`](#method-OpenMppModelRun-get_log)

- [`OpenMppModelRun$write_log()`](#method-OpenMppModelRun-write_log)

------------------------------------------------------------------------

### Method `new()`

Create a new OpenMppModelRun object.

#### Usage

    OpenMppModelRun$new(model, run)

#### Arguments

- `model`:

  Model digest or name.

- `run`:

  Run digest, run stamp, or run name.

#### Returns

A new `OpenMppModelRun` object.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print a `OpenMppModelRun` object.

#### Usage

    OpenMppModelRun$print(...)

#### Arguments

- `...`:

  Not currently used.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `get_table()`

Retrieve a table.

#### Usage

    OpenMppModelRun$get_table(name)

#### Arguments

- `name`:

  Table name.

#### Returns

A `tibble`.

------------------------------------------------------------------------

### Method `get_table_acc()`

Retrieve a table with all accumulator values.

#### Usage

    OpenMppModelRun$get_table_acc(name)

#### Arguments

- `name`:

  Table name.

#### Returns

A `tibble`.

------------------------------------------------------------------------

### Method `get_table_calc()`

Retrieve a table calculation.

#### Usage

    OpenMppModelRun$get_table_calc(name, calc)

#### Arguments

- `name`:

  Table name.

- `calc`:

  Name of calculation. One of `"avg"`, `"sum"`, `"count"`, `"max"`,
  `"min"`, `"var"`, `"sd"`, `"se"`, or `"cv"`.

#### Returns

A `tibble`.

------------------------------------------------------------------------

### Method `get_table_comparison()`

Retrieve a table comparison.

#### Usage

    OpenMppModelRun$get_table_comparison(name, compare, variant)

#### Arguments

- `name`:

  Table name.

- `compare`:

  Comparison to calculate. One of `"diff"`, `"ratio"`, or `"percent"`.

- `variant`:

  Run digest, name, or stamp for the variant model run.

#### Returns

A `tibble`.

------------------------------------------------------------------------

### Method `write_table()`

Write an output table to disk (CSV).

#### Usage

    OpenMppModelRun$write_table(name, file)

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

    OpenMppModelRun$write_tables(dir)

#### Arguments

- `dir`:

  Directory path.

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `get_log()`

Get console log for model run.

#### Usage

    OpenMppModelRun$get_log()

#### Returns

Self, invisibly.

------------------------------------------------------------------------

### Method `write_log()`

Write console log for model run to disk.

#### Usage

    OpenMppModelRun$write_log(dir)

#### Arguments

- `dir`:

  Directory to save log file.

#### Returns

Self, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
load_model_run("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137")
load_run("RiskPaths", "53300e8b56eabdf5e5fb112059e8c137")
} # }
```
