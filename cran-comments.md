## Package submission

### Maintainer

- The previous maintainer of the package is no longer at Posit (previously 
RStudio), so he does not have access to the email on record any longer. The
new maintainer, Edgar Ruiz, also maintains the sparklyr package. 

### In this version

- Updates and expands unit, and integrated, testing 

- Updates the versions of the Maven package, and the JAR used to communicate
with the Spark session

- Removes dependency on the `forge` package. It is no longer maintained, and its
returning warnings because it needs to be updated to accomodate the downstream
dependencies. 

- Avoids sending two parameters that are no longer supported by XGBoost. This 
was the main source of user errors. Matching arguments in the functions are 
still there but it will only return error if the user changes their default 
values.

- Adds setMissing param handler for XGBoostRegressor in the Scala code. The
`missing` parameter in `xgboost_regressor()` was not working.

## Test environments

- Ubuntu 22.04, R 4.3.3, Spark 3.5 (GH Actions)
- Ubuntu 22.04, R 4.3.3, Spark 3.4 (GH Actions)

## R CMD check environments

- Mac OS x86_64-apple-darwin20.0 (64-bit), R 4.3.3 (GH Actions)
- Windows  x86_64-w64-mingw32 (64-bit), R 4.3.3 (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), R 4.3.3 (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), R 4.4.0 (dev) (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), R 4.2.3 (old release) (GH Actions)


## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔