cat("\n----- sparklyr test setup ----")
cat("\nSpark:", testthat_spark_version())
cat("\n--- Creating Spark session ---\n\n")
sc <- testthat_spark_connection()
cat("------------------------------\n\n")

## Disconnects all at the end
withr::defer(sparklyr::spark_disconnect_all(), teardown_env())
