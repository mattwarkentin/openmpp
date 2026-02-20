# OpenM++ Local API Connection

Register a local connection to the OpenM++ Web Services (OMS)
Application Programming Interface (API). Currently, two different API
connections "local" and "remote" are available. Note that "local" and
"remote" describe where the API is running relative to the machine
running the R session. Those who use a machine running on their local
network may use a remote connection to connect with a cloud-based API,
for example. Users running OpenM++ locally or who are logged into a
remote virtual machine running OpenM++ will use the local API
connection.

## Usage

``` r
use_OpenMpp_local(url = Sys.getenv("OPENMPP_LOCAL_URL"), ...)
```

## Arguments

- url:

  URL for making API requests. See `Details` for more instructions.

- ...:

  Not currently used.

## Value

Nothing, invisibly. Behind-the-scenes, an instance of the `OpenMppLocal`
R6 class is created. These objects should not be accessed directly by
the user, instead, the package internally uses these connections to
communicate with the OpenM++ API.

## Details

We recommend declaring the API URL in your global or project-specific
`.Renviron` file. For local and remote API connections, set the
following environment variable in your `.Renviron` files:

- `OPENMPP_LOCAL_URL`: URL for a local API connection. Default is to use
  http://localhost:4040.

## Examples

``` r
if (FALSE) { # \dontrun{
use_OpenMpp_local()
} # }
```
