
# oncosimx

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/oncology-outcomes/oncosimx/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/oncology-outcomes/oncosimx/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `oncosimx` is to provide a programmatic interface to the
OncoSimX web-based platform directly from R to simplify creating
scenarios, running models, and gathering results for further processing.

## Installation

You can install the development version of `oncosimx` from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("oncology-outcomes/oncosimx")
```

## Usage

The `oncosimx` package contains many functions that provide access to
nearly every OpenM++ API endpoint. However, users will typically only
use a smaller set of functions for most tasks.

### User Authentication

Each user is required to set their local host address for the OpenM++
API in their global or project-specific `.Renviron` file in order for
the `oncosimx` package to communicate with the API on behalf of the
user. To do this, set the `ONCOSIMX_HOST` environment variable in your
`.Renviron` file as follows:

    ONCOSIMX_HOST=http://localhost:XXXX

Where `XXXX` is the four digits corresponding to your specific local
host address. If you aren’t sure of your host address, you may contact
the OpenM++ administrator to retrieve this information.

### Main Functions

- Functions for accessing tables of models, worksets, or model runs

  - `get_models()`

  - `get_worksets()` / `get_scenarios()`

  - `get_model_runs()` / `get_runs()`

- Functions for creating new worksets or scenarios

  - `create_scenario()` / `create_workset()`

- Functions for loading models, worksets, or model runs

  - `load_model()`

  - `load_workset()` / `load_scenario()`

  - `load_model_run()` / `load_run()`

  - `load_model_runs()` / `load_runs()`

- Functions for deleting worksets or model runs

  - `delete_workset()` / `delete_scenario()`

  - `delete_model_run()` / `delete_run()`

### Models, Scenarios, Runs, and RunSets

There are 4 main classes you will work with when using the `oncosimx`
package: `OncoSimXModel`, `OncoSimXWorkset`, `OncoSimXModelRun`, and
`OncoSimXModelRunSet`. Each of these are `R6` classes. `R6` is an
encapsulated object-oriented programming system for R. Use the
`load_*()` set of functions to load a model, workset/scenario, model
run, or set of model runs into memory.

Instances of each of these 4 classes have methods and fields associated
with them. You can access public methods and fields using the standard
`$` subset operator (e.g., `obj$action()` or `obj$field`)

### Example

Here we will work through a very simple example of creating a new
scenario, extracting parameters to change, running the model, and
extracting results. In this example we do not actually change any
parameters, but users can edit the extracted CSV files and use
`workset$upload_params()` to upload changed parameters.

``` r
library(oncosimx)
library(tidyverse)
library(ggplot2)
```

Let’s see what models are available:

``` r
get_models()
#> # A tibble: 16 × 7
#>    ModelId Name              Digest  Type Version CreateDateTime DefaultLangCode
#>      <int> <chr>             <chr>  <int> <chr>   <chr>          <chr>          
#>  1     101 OncoSimX-allcanc… 41146…     0 3.6.2.4 2023-09-20 18… EN             
#>  2     101 OncoSimX-breast   55c8b…     0 3.6.2.4 2023-09-20 17… EN             
#>  3     101 OncoSimX-cervical bb3b5…     0 3.6.2.4 2023-09-20 18… EN             
#>  4     101 OncoSimX-colorec… 36999…     0 3.6.2.4 2023-09-20 18… EN             
#>  5     101 OncoSimX-gmm      baa35…     0 3.6.2.4 2023-09-20 18… EN             
#>  6     101 OncoSimX-lung     bb4e0…     0 3.6.2.4 2023-09-20 18… EN             
#>  7     101 OncoSimX-allcanc… 8dc92…     0 3.6.1.6 2023-09-01 14… EN             
#>  8     101 OncoSimX-allcanc… ce674…     0 3.6.1.5 2023-06-13 16… EN             
#>  9     101 OncoSimX-breast   528f9…     0 3.6.1.5 2023-06-13 15… EN             
#> 10     101 OncoSimX-cervical 30246…     0 3.6.1.5 2023-06-13 16… EN             
#> 11     101 OncoSimX-colorec… b275d…     0 3.6.1.5 2023-06-13 16… EN             
#> 12     101 OncoSimX-gmm      e83b4…     0 3.6.1.5 2023-06-13 16… EN             
#> 13     101 OncoSimX-lung     eeb24…     0 3.6.1.5 2023-06-13 16… EN             
#> 14     101 GMM               02614…     1 1.1.2.0 2022-03-23 10… EN             
#> 15     101 HPVMM             0636a…     1 1.9.2.0 2023-03-20 11… EN             
#> 16     101 RiskPaths         d90e1…     0 3.0.0.0 2022-03-07 23… EN
```

We can now see what worksets and model runs exist for a given model.

``` r
get_worksets('OncoSimX-breast')
#> # A tibble: 2 × 11
#>   ModelName     ModelDigest ModelVersion ModelCreateDateTime Name  BaseRunDigest
#>   <chr>         <chr>       <chr>        <chr>               <chr> <chr>        
#> 1 OncoSimX-bre… 55c8b4118b… 3.6.2.4      2023-09-20 17:58:4… Defa… ""           
#> 2 OncoSimX-bre… 55c8b4118b… 3.6.2.4      2023-09-20 17:58:4… MyNe… "b02ca21b49c…
#> # ℹ 5 more variables: IsReadonly <lgl>, UpdateDateTime <chr>,
#> #   IsCleanBaseRun <lgl>, Txt <list<tibble[,3]>>, Param <list>
```

``` r
get_runs('OncoSimX-breast')
#> # A tibble: 2 × 20
#>   ModelName       ModelDigest    ModelVersion ModelCreateDateTime Name  SubCount
#>   <chr>           <chr>          <chr>        <chr>               <chr>    <int>
#> 1 OncoSimX-breast 55c8b4118b002… 3.6.2.4      2023-09-20 17:58:4… Defa…       12
#> 2 OncoSimX-breast 55c8b4118b002… 3.6.2.4      2023-09-20 17:58:4… Exam…       12
#> # ℹ 14 more variables: SubStarted <int>, SubCompleted <int>,
#> #   CreateDateTime <chr>, Status <chr>, UpdateDateTime <chr>, RunDigest <chr>,
#> #   ValueDigest <chr>, RunStamp <chr>, Txt <list>, Opts <list>, Param <list>,
#> #   Table <list>, Entity <list>, Progress <list>
```

Now we can load the `OncoSimX-breast` model to inspect.

``` r
breast <- load_model('OncoSimX-breast')
breast
#> ── OncoSimX Model ──────────────────────────────────────────────────────────────
#> → ModelName: OncoSimX-breast
#> → ModelVersion: 3.6.2.4
#> → ModelDigest: 55c8b4118b0024c4170bb6af274cfade
```

We will now load the `Default` set of input parameters for the Breast
model.

``` r
breast_default <- load_scenario('OncoSimX-breast', 'Default')
breast_default
#> ── OncoSimX Workset ────────────────────────────────────────────────────────────
#> → ModelName: OncoSimX-breast
#> → ModelVersion: 3.6.2.4
#> → ModelDigest: 55c8b4118b0024c4170bb6af274cfade
#> → WorksetName: Default
#> → BaseRunDigest:
```

Finally, we will load the base run for the Breast model.

``` r
baserun_digest <- breast$run_list$RunDigest[[1]]
breast_baserun <- load_run('OncoSimX-breast', baserun_digest)
breast_baserun
#> ── OncoSimX ModelRun ───────────────────────────────────────────────────────────
#> → ModelName: OncoSimX-breast
#> → ModelVersion: 3.6.2.4
#> → ModelDigest: 55c8b4118b0024c4170bb6af274cfade
#> → RunName: Default_first_run_32M_cases_12_subs
#> → RunDigest: b02ca21b49c13d067d253c477dce6fb2
```

We will create a new scenario based on the parameters from the
`Default_first_run_32M_cases_12_subs` model run.

``` r
create_scenario('OncoSimX-breast', 'MyNewScenario', baserun_digest)
```

We will load the new scenario, copy over the `ProvincesOfInterest`
parameter from the base run and extract it to a CSV file for editing.

``` r
my_scenario <- load_scenario('OncoSimX-breast', 'MyNewScenario')
```

Let’s only run the simulation for Alberta…

``` r
my_scenario$copy_params('ProvincesOfInterest')
```

``` r
alberta_only <- my_scenario$ProvincesOfInterest
alberta_only <- 
  alberta_only |> 
  mutate(
    across(Newfoundland_and_Labrador:NT, \(x) FALSE),
    Alberta = TRUE
  )

my_scenario$ProvincesOfInterest <- alberta_only
```

We will now run the model anyway. We will give it the name
`'ExampleRun'`. We use the `wait = TRUE` flag to make sure we want for
the model run to finish before returning to our R session. Note that
model runs may take a long time when the number of simulation cases is
large.

``` r
my_scenario$ReadOnly <- TRUE
my_scenario$run('ExampleRun', wait = TRUE, progress = FALSE)
```

Note that we can use the `opts` argument and the `opts_run()` function
to configure our run. By default, models are run with 5,000 simulation
cases and 12 SubValues. This allows for quick model runs and faster
iteration, but users will want to increase the number of simulation
cases when performing a full model run.

Now that our model run is complete, let’s load it into memory.

``` r
example_run <- load_run('OncoSimX-breast', 'ExampleRun')
example_run
#> ── OncoSimX ModelRun ───────────────────────────────────────────────────────────
#> → ModelName: OncoSimX-breast
#> → ModelVersion: 3.6.2.4
#> → ModelDigest: 55c8b4118b0024c4170bb6af274cfade
#> → RunName: ExampleRun
#> → RunDigest: a999db2c6cc30d6c703b8f1189686e81
```

We can now extract an output table from this model run using
`$get_table()`.

``` r
example_run$Breast_Cancer_Cases_Table
#> # A tibble: 8,177 × 4
#>    expr_name                        Province                   Year expr_value
#>    <chr>                            <chr>                     <dbl>      <dbl>
#>  1 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2015          0
#>  2 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2016          0
#>  3 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2017          0
#>  4 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2018          0
#>  5 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2019          0
#>  6 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2020          0
#>  7 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2021          0
#>  8 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2022          0
#>  9 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2023          0
#> 10 Incidence_of_i_x_d_DCIS_combined Newfoundland_and_Labrador  2024          0
#> # ℹ 8,167 more rows
```

Great, we have created a new scenario, modified some parameters, ran the
model, and extracted output tables. In this last step, we will load
multiple model runs into memory to compare them.

``` r
breast_runs <- load_runs('OncoSimX-breast', breast$run_list$RunDigest)
breast_runs
#> ── OncoSimX ModelRunSet ────────────────────────────────────────────────────────
#> → ModelName: OncoSimX-breast
#> → ModelDigest: 55c8b4118b0024c4170bb6af274cfade
#> → RunNames: [Default_first_run_32M_cases_12_subs, ExampleRun]
#> → RunDigests: [b02ca21b49c13d067d253c477dce6fb2, a999db2c6cc30d6c703b8f1189686e81]
```

We will extract a new table from both models. Note that an extra column,
`RunName` is added to indicate which model run the output table data
corresponds to.

``` r
cost_bystage <- breast_runs$Breast_Cancer_Cost_ByStage_Table
cost_bystage
#> # A tibble: 80 × 4
#>    RunName                             expr_name            Stage     expr_value
#>    <chr>                               <chr>                <chr>          <dbl>
#>  1 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    4.95e 8
#>  2 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    3.17e 9
#>  3 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    3.17e 8
#>  4 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    2.59e 9
#>  5 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    2.06e 9
#>  6 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    1.54e 9
#>  7 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    2.77e 8
#>  8 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    7.54e 8
#>  9 Default_first_run_32M_cases_12_subs Total_treatment_cost Breast_c…    1.27e 9
#> 10 Default_first_run_32M_cases_12_subs Total_treatment_cost all          1.25e10
#> # ℹ 70 more rows
```

We can even plot this using `ggplot2`! Note that the number of
simulation cases for `ExampleRun` is very low so the results are not to
be trusted!

``` r
cost_bystage |> 
  ggplot(aes(Stage, expr_value, fill = RunName)) +
  geom_col(position = position_dodge()) +
  labs(x = NULL, y = 'Breast Cancer Costs ($)') +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = 'bottom')
```

<img src="man/figures/README-unnamed-chunk-18-1.png" width="100%" />

When we are sure we no longer need a scenario or model run, we can use
`delete_scenario()` or `delete_run()` to clean things up!

## Code of Conduct

Please note that the `oncosimx` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
