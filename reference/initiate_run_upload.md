# Upload Model Runs or Worksets

Functions to upload model run results or input parameters (worksets).
More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#upload-model-runs-or-worksets).

## Usage

``` r
initiate_run_upload(model, run, data)

initiate_workset_upload(model, set, data)

delete_upload_files(folder)

delete_upload_files_async(folder)

get_upload_log(name)

get_upload_logs_model(model)

get_upload_logs_all()

get_upload_filetree(folder)
```

## Arguments

- model:

  Model digest or model name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

- data:

  Data used for the body of the request.

- set:

  Name of workset (input set of model parameters).

- folder:

  Upload folder file name.

- name:

  Output table name.

## Value

Nothing, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_upload_logs_all()
} # }
```
