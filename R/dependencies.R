spark_dependencies <- function(spark_version, scala_version, ...) {
  if (scala_version != "2.12") {
    stop(sprintf("Unsupported Scala version '%s'.", scala_version))
  }
  sparklyr::spark_dependency(
    jars = package_file("java/sparkxgb-3.0-2.12.jar"),
    packages = readLines(package_file("maven/scala_212.txt"))
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
