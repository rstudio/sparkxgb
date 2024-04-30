# IMPORTAT - To Run locally:
# Make sure that when Spark/XGBoost calls 'python' directly.
# If calling 'python3' works, but 'python' does not, consider using a link
# service, such as 'python-is-python3' in Ubuntu. Also, make sure that when inside
# the default 'python', 'import xgboost' can be called without issues. This
# is due the a tracker system (called Rabbit) NEEDS a Python implementation
# in order for it to work, regardless if you're using Scala.  The documentation
# says that you can change it to Scala, but I did not find any example where
# that was successful. I found that there is a way to set the "path" of a
# local Python path, but I was not able to get it to work via sparklyr.
# One more thing, the Rabbit code does not use any fall-back, other than 'python'
# if the argument is not passed, this means that the spark.options that set the
# Python path, or even the environment variables that do so as well are ignored.
# Error you will get if the above is not setup properly:
# java.lang.IllegalArgumentException: requirement failed: FAULT: Failed to start tracker

if (identical(Sys.getenv("CODE_COVERAGE"), "true")) {
  library(testthat)
  library(sparklyr)
  library(sparkxgb)
  test_check("sparkxgb")
}
