# OpenM++ Administrative Tasks

Functions for performing administrative tasks. More information about
the administrative API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#administrative-manage-web-service-state).

## Usage

``` r
admin_models_refresh()

admin_models_close()

admin_database_close(model)

admin_model_delete(model)

admin_database_open(path)

admin_database_cleanup(path, name = NULL, digest = NULL)

admin_cleanup_logs()

admin_cleanup_log(name)

admin_jobs_pause(pause)

admin_jobs_pause_all(pause)

admin_service_shutdown()
```

## Arguments

- model:

  Model digest or model name.

- path:

  Path to model database file relative to the `models/bin` folder. For
  example, the name of the model with a `".sqlite"` extension.

- name:

  Model name. Optional for `admin_database_cleanup()`.

- digest:

  Model digest. Optional for `admin_database_cleanup()`.

- pause:

  Logical. Whether to pause or resume model runs queue processing.

## Value

A `list` or nothing, invisibly.

## Details

To find the relative `path` to a database file for cleanup with
`admin_database_cleanup(path)` or opening a database file with
`admin_database_open(path)`, users can run the
[`get_models_list()`](https://mattwarkentin.github.io/openmpp/reference/get_model.md)
function to retrieve the list of model information and find the `DbPath`
list item. `DbPath` is the relative path to the database file. You must
replace the forward-slashes in the relative path with asterisks.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
admin_models_refresh()
} # }

```
