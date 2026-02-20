# OpenM++ Model Run Jobs and Service State

Functions for retrieving or deleting service information. More
information about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#model-run-jobs-and-service-state).

## Usage

``` r
get_service_config()

get_service_state()

get_disk_use()

refresh_disk_use()

get_active_job_state(job)

get_queue_job_state(job)

get_hist_job_state(job)

set_queue_job_pos(pos, job)

delete_job_hist(job)
```

## Arguments

- job:

  Model run submission time stamp.

- pos:

  Position.

## Value

A `list` from a JSON response object, or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_service_config()
get_service_state()
get_disk_use()
} # }
```
