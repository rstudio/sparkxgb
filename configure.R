#!/usr/bin/env Rscript

library(purrr)

if (!dir.exists("internal")) dir.create("internal")
if (!dir.exists("internal/xgboost4j-spark")) dir.create("internal/xgboost4j-spark")
if (!file.exists("internal/xgboost4j-spark/xgboost4j-spark-0.81.jar")) download.file(
  "http://central.maven.org/maven2/ml/dmlc/xgboost4j-spark/0.81/xgboost4j-spark-0.81.jar",
  "internal/xgboost4j-spark/xgboost4j-spark-0.81.jar"
)

spec <- sparklyr::spark_default_compilation_spec() %>%
  map(function(x) {
    x$jar_dep <- list.files("internal/xgboost4j-spark", full.names = TRUE) %>% 
      map_chr(normalizePath)
    x
  }) %>%
  keep(~ .x$spark_version >= "2.3.0")

sparklyr::compile_package_jars(spec = spec)
