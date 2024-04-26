test_that("xgboost_classifier() default params", {
  test_default_args(testthat_spark_connection(), xgboost_classifier)
})

test_that("xgboost_classifier() param setting", {
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
  test_param_setting(
    testthat_spark_connection(),
    xgboost_classifier,
    test_args
  )
})

test_that("ml_feature_importances() works as expected", {
  xgb_model <- xgboost_classifier(
    testthat_tbl("iris"),
    Species ~ .,
    objective = "multi:softprob",
    num_class = 3,
    num_round = 50,
    max_depth = 4
  )
  importances <- ml_feature_importances(xgb_model)
  expect_equal(
    sort(importances$feature),
    c("Petal_Length", "Petal_Width", "Sepal_Length", "Sepal_Width")
  )
  expect_equal(
    sort(importances$importance, decreasing = TRUE),
    c(
      0.61188768978835550,
      0.34706520994955187,
      0.02978168609216137,
      0.01126541416993130
    ),
    tolerance = 0.1
  )
})

test_that("setMissing scala code works", {
  expect_s3_class(
    xgboost_classifier(
      testthat_tbl("iris"),
      Species ~ .,
      objective = "multi:softprob",
      num_class = 3,
      num_round = 50,
      max_depth = 4,
      missing = 0
    ),
    "ml_model"
  )
})
