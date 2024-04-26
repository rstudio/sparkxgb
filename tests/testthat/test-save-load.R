test_that("we can save/load xgboost models", {
  sc <- testthat_spark_connection()
  iris_tbl <- testthat_tbl("iris")

  pipeline <- sparklyr::ml_pipeline(sc) %>%
    sparklyr::ft_r_formula(Petal_Length ~ Petal_Width + Sepal_Length) %>%
    xgboost_regressor()

  pipeline_model <- pipeline %>%
    sparklyr::ml_fit(iris_tbl)

  preds1 <- pipeline_model %>%
    sparklyr::ml_transform(iris_tbl) %>%
    dplyr::pull(prediction)

  path <- tempfile()

  sparklyr::ml_save(pipeline_model, path)
  loaded_model <- sparklyr::ml_load(sc, path)

  preds2 <- loaded_model %>%
    sparklyr::ml_transform(iris_tbl) %>%
    dplyr::pull(prediction)

  expect_equal(preds1, preds2)
})
