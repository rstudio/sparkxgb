spark_dependencies <- function(spark_version, scala_version, ...) {
  if (scala_version != "2.12") {
    stop(sprintf("Unsupported Scala version '%s'.", scala_version))
  }
  sparklyr::spark_dependency(
    jars = system.file("java/sparkxgb-3.0-2.12.jar", package = "sparkxgb"),
    packages = "ml.dmlc:xgboost4j-spark_2.12:2.0.3"
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}

package_file <- function(...) {
  default_file <- path(...)
  inst_file <- path("inst", default_file)
  pkg_file <- NULL
  if (file_exists(inst_file)) {
    pkg_file <- inst_file
  } else {
    pkg_file <- system.file(default_file, package = "sparkxgb")
  }
  if (!file_exists(pkg_file)) {
    stop(paste0("'", default_file, "' not found"))
  }
  pkg_file
}
