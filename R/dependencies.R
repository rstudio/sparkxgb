spark_dependencies <- function(spark_version, scala_version, ...) {
  if (spark_version > "2.3") spark_version <- "2.3"
    
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        sprintf(
          "java/sparkxgb-%s-%s.jar",
          sparklyr::spark_dependency_fallback(spark_version, "2.3"),
          scala_version
        ),
        package = "sparkxgb"
      )
    ),
    packages = c("ml.dmlc:xgboost4j-spark:0.81"),
    web_jars = "https://github.com/rstudio/sparkxgb/blob/master/inst/java/%s?raw=true"
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
