
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sparkxgb

**sparkxgb** is a [sparklyr](https://spark.rstudio.com/) extension that
provides an interface to [XGBoost](https://github.com/dmlc/xgboost) on
Spark.

## Installation

You can install the development version of sparkxgb with:

``` r
# sparkxgb requires the development version of sparklyr
devtools::install_github("rstudio/sparklyr")
devtools::install_github("kevinykuo/sparkxgb")
```

## Example

``` r
library(sparkxgb)
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local")
iris_tbl <- sdf_copy_to(sc, iris)

xgb_model <- xgboost_classifier(
  iris_tbl, 
  Species ~ .,
  objective = "multi:softprob",
  num_class = 3,
  num_round = 50, 
  max_depth = 4
)

xgb_model %>%
  ml_predict(iris_tbl) %>%
  select(Species, predicted_label, starts_with("probability_")) %>%
  glimpse()
#> Observations: ??
#> Variables: 5
#> $ Species                <chr> "setosa", "setosa", "setosa", "setosa",...
#> $ predicted_label        <chr> "setosa", "setosa", "setosa", "setosa",...
#> $ probability_versicolor <dbl> 0.003566429, 0.003564076, 0.003566429, ...
#> $ probability_virginica  <dbl> 0.001423170, 0.002082058, 0.001423170, ...
#> $ probability_setosa     <dbl> 0.9950104, 0.9943539, 0.9950104, 0.9950...
```
