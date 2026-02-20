# OpenM++ Custom API Connection

Register a custom connection to the OpenM++ Web Services (OMS)
Application Programming Interface (API). A custom conneciton is
typically comprised of two main tasks: (1) authentication and (2)
building the request. To create your own custom connection, you simply
need to create a function (`req`) that performs authentication (if
needed) and builds the initial portion the API request using the
authentication information.

## Usage

``` r
use_OpenMpp_custom(req, ...)
```

## Arguments

- req:

  A function that that performs any required user authentication with
  the API and builds the initial part of the API request including
  handling the authentication. Calling `req()` should return a
  `httr2_request` object.

- ...:

  Not currently used.

## Value

Nothing, invisibly. Behind-the-scenes, an instance of the
`OpenMppCustom` R6 class is created. These objects should not be
accessed directly by the user, instead, the package internally uses
these connections to communicate with the OpenM++ OMS API.
