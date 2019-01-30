context("save/load")

test_that("we can save/load xgboost models", {
  sc <- testthat_spark_connection()
  iris_tbl <- testthat_tbl("iris")
  
  pipeline <- ml_pipeline(sc) %>%
    ft_r_formula(Petal_Length ~ Petal_Width + Sepal_Length) %>%
    xgboost_regressor()
  
  pipeline_model <- pipeline %>%
    ml_fit(iris_tbl)
  
  preds1 <- pipeline_model %>%
    ml_transform(iris_tbl) %>%
    dplyr::pull(prediction)
  
  path <- tempfile()
  
  ml_save(pipeline_model, path)
  loaded_model <- ml_load(sc, path)
  
  preds2 <- loaded_model %>%
    ml_transform(iris_tbl) %>%
    dplyr::pull(prediction)
  
  expect_equal(preds1, preds2)
})