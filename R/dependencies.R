spark_dependencies <- function(spark_version, scala_version, ...) {
  if (spark_version > "2.3") spark_version <- "2.3"
    
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        sprintf("java/sparkxgb-%s-%s.jar", spark_version, scala_version),
        package = "sparkxgb"
      )
    ),
    packages = "ml.dmlc:xgboost4j-spark:0.81"
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
