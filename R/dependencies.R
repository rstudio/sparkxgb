spark_dependencies <- function(spark_version, scala_version, ...) {
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        sprintf("java/sparkxgb-%s-%s.jar", spark_version, scala_version),
        package = "sparkxgb"
      )
    ),
    packages = (
      if (spark_version < "2.4") {
        "ml.dmlc:xgboost4j-spark:0.81"
      } else if (scala_version == "2.11") {
        # This is the last version of xgboost4j built with Scala 2.11.
        "ml.dmlc:xgboost4j-spark_2.11:1.1.2"
      } else if (scala_version == "2.12") {
        # This is the last known version of xgboost4j built with Scala 2.12.
        "ml.dmlc:xgboost4j-spark_2.12:1.3.1"
      } else {
        # There is no known support for other versions of Scala at the moment.
        stop(sprintf("Unsupported Scala version '%s'.", scala_version))
      }
    )
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
