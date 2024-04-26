spark_dependencies <- function(spark_version, scala_version, ...) {
  if (scala_version != "2.12") {
    stop(sprintf("Unsupported Scala version '%s'.", scala_version))
  }
  pkg <- "sparkxgb"
  sparklyr::spark_dependency(
    jars = system.file("java/sparkxgb-3.0-2.12.jar", package = pkg),
    packages = readLines(system.file("maven/scala_212.txt", package = pkg))
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
