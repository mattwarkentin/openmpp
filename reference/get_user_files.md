# Manage OpenM++ User Files

Functions for getting, setting, and deleting user file. More information
about these API endpoints can be found at
[here](https://github.com/openmpp/openmpp.github.io/wiki/Oms-web-service-API#download-and-upload-user-files).

## Usage

``` r
get_user_files(ext = "*", path = "")

upload_user_files(path)

create_user_files_folder(path)

delete_user_files(path)

delete_user_files_all()
```

## Arguments

- ext:

  Comma-separated string of file extensions. Default is `"*"` which
  returns all files.

- path:

  Optional file path. Default is `""` (empty) and returns the entire
  tree of user files.

## Value

A `list` from JSON response object or nothing (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
get_user_files()
} # }

```
