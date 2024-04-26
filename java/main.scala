package sparkxgb

import ml.dmlc.xgboost4j.scala.spark.XGBoostClassifier
import ml.dmlc.xgboost4j.scala.spark.XGBoostRegressor

object Utils {
  def setMissingParamClass(xgb: XGBoostClassifier, missing: Double) : XGBoostClassifier = {
    xgb.setMissing(missing.toFloat)
  }
  def setMissingParamReg(xgb: XGBoostRegressor, missing: Double) : XGBoostRegressor = {
    xgb.setMissing(missing.toFloat)
  }
}
