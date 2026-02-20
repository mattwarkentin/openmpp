# openmpp 0.0.2

* New functionality has been added to allow users to specify their own custom connections to an OpenM++ OMS API (`use_OpenMpp_custom()`). This change should make the package more flexible and extensible to support different types of connections and user authentication methods. A consequence of this change is the removal of the `use_OpenMpp_remote()` function.

* New function (`get_run_table_acc_csv()`) and new method (`$get_table_acc()`) for the `OpenMppModelRun` class have been added to access output tables with accumulator values for a model run

# openmpp 0.0.1

* Initial public release.
