# Changelog

## openmpp 0.0.2

- New functionality has been added to allow users to specify their own
  custom connections to an OpenM++ OMS API
  ([`use_OpenMpp_custom()`](https://mattwarkentin.github.io/openmpp/reference/use_OpenMpp_custom.md)).
  This change should make the package more flexible and extensible to
  support different types of connections and user authentication
  methods. A consequence of this change is the removal of the
  `use_OpenMpp_remote()` function.

- New function
  ([`get_run_table_acc_csv()`](https://mattwarkentin.github.io/openmpp/reference/get_run_table.md))
  and new method (`$get_table_acc()`) for the `OpenMppModelRun` class
  have been added to access output tables with accumulator values for a
  model run

## openmpp 0.0.1

CRAN release: 2025-07-19

- Initial public release.
