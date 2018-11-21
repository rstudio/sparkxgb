package sparkxgb

import ml.dmlc.xgboost4j.scala.spark.XGBoostClassifier

object Utils {
  def setMissingParam(xgb: XGBoostClassifier, missing: Double) : XGBoostClassifier = {
    xgb.setMissing(missing.toFloat)
  }
}
