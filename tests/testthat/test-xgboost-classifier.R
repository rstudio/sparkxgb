context("xgboost classifier")

test_that("xgboost_classifier() default params", {
  sc <- testthat_spark_connection()
  test_default_args(sc, xgboost_classifier)
})

test_that("xgboost_classifier() param setting", {
  sc <- testthat_spark_connection()
  test_args <- list(
    max_depth = 6,
    seed = 42,
    thresholds = c(0.3, 0.6),
    checkpoint_interval = 15,
    features_col = "fcol",
    label_col = "lcol",
    prediction_col = "pcol",
    probability_col = "prcol",
    raw_prediction_col = "rpcol"
  )
  test_param_setting(sc, xgboost_classifier, test_args)
})
