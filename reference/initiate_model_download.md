# Download Model, Model Run Results, or Input Parameters

Functions to download model, model run results, or input parameters.
More information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#download-model-model-run-results-or-input-parameters).

## Usage

``` r
initiate_model_download(model)

initiate_run_download(model, run)

initiate_workset_download(model, set)

delete_download_files(folder)

delete_download_files_async(folder)

get_download_log(name)

get_download_logs_model(model)

get_download_logs_all()

get_download_filetree(folder)
```

## Arguments

- model:

  Model digest or model name.

- run:

  Model run digest, run stamp or run name, modeling task run stamp or
  task run name.

- set:

  Name of workset (input set of model parameters).

- folder:

  Download folder file name.

- name:

  Output table name.

## Value

Nothing, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_download_logs_model('RiskPaths')
} # }

```
