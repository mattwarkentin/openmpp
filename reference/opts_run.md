# Run Configuration Options

Run Configuration Options

## Usage

``` r
opts_run(
  SimulationCases = 5000,
  SubValues = 12,
  RunStamp = TimeStamp(),
  Opts = list(),
  ...
)

# S3 method for class 'OpenMppRunOpts'
print(x, ...)
```

## Arguments

- SimulationCases:

  Number of cases to simulate. Default is 5000.

- SubValues:

  Number of sub values. Default is 12.

- RunStamp:

  Run stamp. Default is generated based on the current time.

- Opts:

  Additional options to pass to the `Opts` list component.

- ...:

  Any other run options.

- x:

  Object to print.

## Details

The default number of `SimulationCases` is low to enable rapid iteration
but should be increased when running a model where the results are
expected to be robust.

## Examples

``` r
opts <- opts_run()
print(opts)
#> OpenM++ Run Options
#> {
#>   "RunStamp": "2026_02_20_19_58_43_553",
#>   "Opts": {
#>     "Parameter.SimulationCases": "5000",
#>     "OpenM.SubValues": "12",
#>     "OpenM.RunStamp": "2026_02_20_19_58_43_553",
#>     "OpenM.LogToConsole": "true"
#>   }
#> } 
```
