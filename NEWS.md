# sparkxgb 0.2.1

###  Fixes

- Addresses notes from CRAN

# sparkxgb 0.2

###  Fixes

- Avoids sending two deprecated parameters to XGBoost. The default arguments in
the R function are NULL, and it will return an error message if the call intends
to use them:

  - Sketch EPS - No longer supported since XGBoost version 1.6
  
  - Timeout Request Updates - No long supported since XGBoost version 1.7

- Adds setMissing param handler for XGBoostRegressor in the Scala code. The
`missing` parameter in `xgboost_regressor()` was not working.

- Creates the JAR for Scala version 2.12 only. The code is simple enough that
it does not seem to need multiple Spark version compiling. This also means that
Scala 2.11 is not supported at this time. 

### Internal improvements

- Modernizes the entire `testthat` suite, it also expands it to provide more
coverage

- Modernizes and expands CI testing. The single CI job is now expanded to three:
  - R package check, with no testing against the three major OS's
  - `testthat` tests against Spark version 3.5 
  - Coverage testing, also against Spark version 3.5
  
- Removes `forge` dependency 

- Improves download, preparation and building of the JAR

- Improves and cleans up the code that selects the JAR and Maven package to use.
It now depends on a text file created by the script the updates the JARS.

- Updates Roxygen and `testthat` versions

- Edgar Ruiz (https://github.com/edgararuiz) will be the new maintainer of this
  package moving forward.

# sparkxgb 0.1.1

- `sparkxgb` is a sparklyr extension that provides an interface to XGBoost on Spark.
