spark_dependencies <- function(spark_version, scala_version, ...) {
  sparklyr::spark_dependency(
    jars = system.file("java/sparkxgb-3.0-2.12.jar", package = "sparkxgb"),
    packages = (
      if (scala_version == "2.12") {
        "ml.dmlc:xgboost4j-spark_2.12:2.0.3"
      } else {
        stop(sprintf("Unsupported Scala version '%s'.", scala_version))
      }
    )
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
