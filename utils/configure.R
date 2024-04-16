library(purrr)
library(rvest)
library(sparklyr)

# Install Scala version if missing
invisible(download_scalac())

# Get current compilation specs from `sparklyr`
sparklyr_comps <- sparklyr::spark_default_compilation_spec()

sparklyr_comps %>% 
  map(~.x$spark_version) %>% 
  walk(sparklyr::spark_install)

maven_url <- "https://repo1.maven.org/maven2/ml/dmlc/"

maven_links <- maven_url %>% 
  read_html() %>% 
  html_elements("a") %>% 
  html_attr("href") 

maven_links[
  grepl("xgboost4j-spark", maven_links) &
    !grepl("gpu", maven_links) &
    grepl("_", maven_links)
  ]




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
