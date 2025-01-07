
# CONTRIBUTING

All contributions to the `openmpp` package are welcome and greatly appreciated.

## Bugs

If you’ve found a bug, please create a minimal reproducible example. Spend some time trying to make it as minimal as possible, this will facilitate the task and speed up the entire process. Next, submit an issue on the [Issues page](https://github.com/mattwarkentin/openmpp/issues).

## Contributions

### Improving Doucmentation

You can fix typos, spelling mistakes, or grammatical errors in the documentation.
We use [roxygen2](https://roxygen2.r-lib.org/), so the documentation should be generated using `.R` files, not by editing the `.Rd` files directly.

### Larger Contributions

If you want to make a larger change, it's a good idea to file an issue first and make sure someone from the team agrees that it is needed. We do not want you to spend a bunch of time on something that we don’t think is a suitable contribution for this package.

Once accepted, you can follow the pull request process:

1. Fork this repository to your GitHub account.

2. Clone your version to your machine, e.g., `git clone https://github.com/mattwarkentin/openmpp.git`.

3. Make sure to track progress upstream (i.e., our version of `openmpp` at `mattwarkentin/openmpp`) by doing `git remote add upstream https://github.com/mattwarkentin/openmpp.git`. Before making any changes, make sure to pull changes in from upstream by either doing `git fetch upstream` then merge later, or `git pull upstream` to fetch and merge in one step.

4. Make your changes to a new branch.

5. If you alter package functionality at all (e.g., the code itself, not just documentation) please do write some tests to cover the new functionality.

6. Push changes to your GitHub account.

7. Submit a pull request to the main branch at `mattwarkentin/openmpp`.

We use [testthat](https://testthat.r-lib.org/) for unit tests. Contributions with test cases included are prioritized for review. Please make sure that your new code and documentation matches the existing style.

## Questions

Questions are welcomed on the [Issues page](https://github.com/mattwarkentin/openmpp/issues).
Adding a reproducible example may make it easier for us to answer.

## Thanks for contributing!
