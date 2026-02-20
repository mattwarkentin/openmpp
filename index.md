# openmpp

The goal of `openmpp` is to provide a programmatic interface to the
OpenM++ API directly from R to simplify creating scenarios, running
models, and gathering results for further processing.

## Installation (R Package)

You can install the CRAN version of `openmpp` with:

``` r
install.packages("openmpp")
```

Or, you can install the development version of `openmpp` from
[GitHub](https://github.com/mattwarkentin/openmpp) with:

``` r
# install.packages("remotes")
remotes::install_github("mattwarkentin/openmpp")
```

## Installation (OpenM++)

If you do not have access to an existing OpenM++ server, you can
download and install OpenM++ locally and run a local server on your
workstation. The `openmpp` package can then connect to this local server
instance.

### Download

For most users, the best way to install OpenM++ locally is to download
the pre-compiled binaries. To install OpenM++, download and unzip the
“Source code and binaries” appropriate for your operating system. The
latest release of OpenM++ can be found here:
<https://github.com/openmpp/main/releases/latest>. Pre-compiled binaries
are available for Mac (Intel and Arm), Windows, and several common Linux
distributions (Debian, Ubuntu, RedHat).

NOTE: Windows may allow you to view the contents of the zip directory
without extracting, however, the files must be extracted for the
installation to function properly.

### Running OpenM++ on Windows

Enter the OpenM++ directory using the File Explorer. Right-click
anywhere inside the folder and select “Open in Terminal”.

In the Windows Terminal, enter the following command:

``` cmd
.\bin\oms.exe
```

This will start the process responsible for running the OpenM++ web
service (OMS). Note that the local host address will be printed in the
console and is the address used by the `openmpp` R package to
communicate with the API. This local host address will be set as the
`OPENMPP_LOCAL_URL`. See the Usage section for more details.

### Running OpenM++ on MacOS

Open a new MacOS Terminal window (either by using Spotlight Search or by
navigating to “Applications” and then “Utilities” in Finder).

After unzipping the downloaded directory in Finder, drag the folder into
the terminal and press Enter. This will change your active directory to
the OpenM++ folder.

Enter the following command into the terminal:

``` bash
bin/oms
```

Similar to the Windows installation, the web service (OMS) will initiate
and the local host address will be shared with the R package for API
communication.

## Usage

The `openmpp` package contains many functions that provide access to
nearly every OpenM++ REST API endpoint. However, users of this package
will typically only use a smaller set of functions for most common
tasks.

### User Authentication

Each user is suggested to set their local or remote host address (i.e.,
URL) for the OpenM++ API in their global or project-specific `.Renviron`
file in order for the `openmpp` package to authenticate and communicate
with the API on behalf of the user. You can pass the URL directly to the
functions that create the connections but it is our suggestion to
declare the URL in the `.Renviron` file alongside other credentials
described below.

If you are working in an IDE (e.g., Positron, RStudio), you may consider
using the following function `usethis::edit_r_environ()` to open your
`.Renviron` file for editing. Note that you will need to restart your R
session after editing the file for the effect to take place.

#### Local API

For an API running locally, set the following environment variable in
your `.Renviron` file:

``` R
OPENMPP_LOCAL_URL=http://localhost:XXXX
```

Where `XXXX` is the four digits corresponding to your specific local
host address for this service (typically 4040 is used by default). The
local host address is printed to the console when starting the OpenM++
web service in the terminal.

Once the environment variable is set, users may register a local API
connection in their R scripts with:

``` r
library(openmpp)
use_OpenMpp_local()
```

#### Custom API

The methods for building a connection to a remote or custom API has
changed as of version `0.0.2` of this package. This internal rewrite was
done to enable more flexibility to define custom connections where the
user provides the tooling to build requests and authenticate (if
required).

This new interface for custom API connections is through the use of
[`use_OpenMpp_custom()`](https://mattwarkentin.github.io/openmpp/reference/use_OpenMpp_custom.md).
This function has a single argument, `req`, which should be a function
that, when called, returns a `httr2_request` object. At a minimum, this
function should build the start of the request (with
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html)).

Once a user defines this custom function, they can provide it to
[`use_OpenMpp_custom()`](https://mattwarkentin.github.io/openmpp/reference/use_OpenMpp_custom.md).
For example, the following code would replicate the local API
connection:

``` r
library(openmpp)

custom_req <- function(url = Sys.getenv('OPENMPP_LOCAL_URL')) {
  httr2::request(url)
}

use_OpenMpp_custom(custom_req)
```

The simple example presented above could be extended to handle user
authentication or to add headers, cookies, or other data to the request.

See
[`?use_OpenMpp_custom`](https://mattwarkentin.github.io/openmpp/reference/use_OpenMpp_custom.md)
for more information.

### Main Functions

- Functions for accessing tables of models, worksets, or model runs

  - [`get_models()`](https://mattwarkentin.github.io/openmpp/reference/get_model.md)

  - [`get_worksets()`](https://mattwarkentin.github.io/openmpp/reference/get_workset.md)
    /
    [`get_scenarios()`](https://mattwarkentin.github.io/openmpp/reference/get_workset.md)

  - [`get_model_runs()`](https://mattwarkentin.github.io/openmpp/reference/get_model_run.md)
    /
    [`get_runs()`](https://mattwarkentin.github.io/openmpp/reference/get_model_run.md)

- Functions for creating new worksets or scenarios

  - [`create_scenario()`](https://mattwarkentin.github.io/openmpp/reference/create_scenario.md)
    /
    [`create_workset()`](https://mattwarkentin.github.io/openmpp/reference/create_scenario.md)

- Functions for loading models, worksets, or model runs

  - [`load_model()`](https://mattwarkentin.github.io/openmpp/reference/load_model.md)

  - [`load_workset()`](https://mattwarkentin.github.io/openmpp/reference/load_workset.md)
    /
    [`load_scenario()`](https://mattwarkentin.github.io/openmpp/reference/load_workset.md)

  - [`load_model_run()`](https://mattwarkentin.github.io/openmpp/reference/load_model_run.md)
    /
    [`load_run()`](https://mattwarkentin.github.io/openmpp/reference/load_model_run.md)

  - [`load_model_runs()`](https://mattwarkentin.github.io/openmpp/reference/load_model_runs.md)
    /
    [`load_runs()`](https://mattwarkentin.github.io/openmpp/reference/load_model_runs.md)

- Functions for deleting worksets or model runs

  - [`delete_workset()`](https://mattwarkentin.github.io/openmpp/reference/set_workset_readonly.md)
    /
    [`delete_scenario()`](https://mattwarkentin.github.io/openmpp/reference/set_workset_readonly.md)

  - [`delete_model_run()`](https://mattwarkentin.github.io/openmpp/reference/delete_model_run.md)
    /
    [`delete_run()`](https://mattwarkentin.github.io/openmpp/reference/delete_model_run.md)

### Models, Scenarios, Runs, and RunSets

There are 4 main classes you will work with when using the `openmpp`
package: `OpenMppModel`, `OpenMppWorkset`, `OpenMppModelRun`, and
`OpenMppModelRunSet`. Each of these are `R6` classes. `R6` is an
encapsulated object-oriented programming (OOP) system for R. Use the
`load_*()` set of functions to load a model, workset/scenario, model
run, or set of model runs into memory.

Instances of each of these 4 classes have methods (i.e., functions) and
fields (i.e., data) associated with them. You can access these functions
and data using the standard `$` subset operator (e.g., `obj$function()`
or `obj$data`).

**Why use R6?** We chose to use the R6 OOP as we believe it can simplify
the ability for the R package to communicate with OpenM++ to ensure that
all changes made to the microsimulation objects in the R session are
propagated and synchronized with the OpenM++ database. Encapsulated OOP
allows the internal state of the object (i.e., the connection to the
actual object in the OpenM++ database) to be accessed and modified
through well-defined and high-level methods, rather than directly
manipulating the data with low-level function calls. This approach
enforces data integrity, improves code readability, and simplifies
maintenance by abstracting away the implementation details of an object
and preventing unintended modifications to its state. More information
about `R6` can be found
[here](https://r6.r-lib.org/articles/Introduction.html).

### Developing New Models

Developing new microsimulation or agent-based models in OpenM++ is
beyond the scope of this package. In-depth information on model
development can be found here:
<https://github.com/openmpp/openmpp.github.io/wiki/Model-Development-Topics>.

## Contributor Guidelines

Contributions to this package are welcome. The preferred method of
contribution is through a GitHub pull request. Before contributing,
please file an issue to discuss the idea with the project team. More
details on contributing can be found in the
[CONTRIBUTING](https://github.com/mattwarkentin/openmpp/blob/main/CONTRIBUTING.md)
document.

## Acknowledgments

We gratefully acknowledge the authors and maintainers of OpenM++ for
developing and sustaining the open-source modeling platform that makes
this work possible. Their efforts to build, document, and support
OpenM++ have provided a robust foundation for microsimulation research
and for the development of tools such as this package.

## Code of Conduct

Please note that the `openmpp` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
