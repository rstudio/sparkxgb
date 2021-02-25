context("xgboost classifier")

sc <- testthat_spark_connection()

test_that("xgboost_classifier() default params", {
  test_default_args(sc, xgboost_classifier)
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
  test_param_setting(sc, xgboost_classifier, test_args)
})

test_that("ml_feature_importances() works as expected", {
  skip_if(spark_version(sc) < "2.4")

  iris_tbl <- sparklyr::copy_to(sc, iris, overwrite = TRUE)

  xgb_model <- xgboost_classifier(
    iris_tbl,
    Species ~ .,
    objective = "multi:softprob",
    num_class = 3,
    num_round = 50,
    max_depth = 4
  )

  expect_equivalent(
    ml_feature_importances(xgb_model),
    data.frame(
      feature = c("Petal_Length", "Petal_Width", "Sepal_Width", "Sepal_Length"),
      importance = c(
        0.61188768978835550,
        0.34706520994955187,
        0.02978168609216137,
        0.01126541416993130
      )
    )
  )
})
