test_that("xgboost_regressor() default params", {
  test_default_args(testthat_spark_connection(), xgboost_regressor)
})

test_that("xgboost_regressor() param setting", {
  test_args <- list(
    max_depth = 6,
    seed = 42,
    checkpoint_interval = 15,
    features_col = "fcol",
    label_col = "lcol",
    prediction_col = "pcol"
  )
  test_param_setting(
    testthat_spark_connection(),
    xgboost_regressor,
    test_args
  )
})

test_that("ml_feature_importances() works as expected", {
  mtcars_tbl <- testthat_tbl("mtcars")

  xgb_model <- xgboost_regressor(mtcars_tbl, mpg ~ wt + am + gear)

  expect_s3_class(sparklyr::ml_predict(xgb_model, mtcars_tbl), "tbl")
  expect_s3_class(xgb_model, "ml_model")
})

test_that("setMissing scala code works", {
  expect_s3_class(
    xgboost_regressor(testthat_tbl("mtcars"), mpg ~ wt + am + gear, missing = 0),
    "ml_model"
  )
})
