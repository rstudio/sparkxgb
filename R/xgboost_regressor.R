#' XGBoost Regressor
#' 
#' XGBoost regressor for Spark.
#' 
#' @param alpha L1 regularization term on weights, increase this value will make model more conservative, defaults to 0.
#' @param base_margin_col Param for initial prediction (aka base margin) column name.
#' @param base_score Param for initial prediction (aka base margin) column name. Defaults to 0.5.
#' @param checkpoint_interval Param for set checkpoint interval (>= 1) or disable checkpoint (-1). E.g. 10 means that the trained model will get checkpointed every 10 iterations. Note: checkpoint_path must also be set if the checkpoint interval is greater than 0.
#' @param checkpoint_path The hdfs folder to load and save checkpoint boosters.
#' @param colsample_bylevel Subsample ratio of columns for each split, in each level. [default=1] range: (0,1]
#' @param colsample_bytree Subsample ratio of columns when constructing each tree. [default=1] range: (0,1]
#' @param custom_eval Customized evaluation function provided by user. Currently unsupported.
#' @param custom_obj Customized objective function provided by user. Currently unsupported.
#' @param eta Step size shrinkage used in update to prevents overfitting. After each boosting step, we can directly get the weights of new features and eta actually shrinks the feature weights to make the boosting process more conservative. [default=0.3] range: [0,1]
#' @param eval_metric Evaluation metrics for validation data, a default metric will be assigned according to objective(rmse for regression, and error for classification, mean average precision for ranking). options: rmse, mae, logloss, error, merror, mlogloss, auc, aucpr, ndcg, map, gamma-deviance
#' @param gamma Minimum loss reduction required to make a further partition on a leaf node of the tree. the larger, the more conservative the algorithm will be. [default=0]
#' @param grow_policy Growth policy for fast histogram algorithm.
#' @param lambda L2 regularization term on weights, increase this value will make model more conservative. [default=1]
#' @param lambda_bias Parameter of linear booster L2 regularization term on bias, default 0 (no L1 reg on bias because it is not important.)
#' @param max_bins Maximum number of bins in histogram.
#' @param max_delta_step Maximum delta step we allow each tree's weight estimation to be. If the value is set to 0, it means there is no constraint. If it is set to a positive value, it can help making the update step more conservative. Usually this parameter is not needed, but it might help in logistic regression when class is extremely imbalanced. Set it to value of 1-10 might help control the update. [default=0]
#' @param max_depth Maximum depth of a tree, increase this value will make model more complex / likely to be overfitting. [default=6]
#' @param maximize_evaluation_metrics Whether to maximize evaluation metrics. Defaults to FALSE (for minization.)
#' @param min_child_weight Minimum sum of instance weight(hessian) needed in a child. If the tree partition step results in a leaf node with the sum of instance weight less than min_child_weight, then the building process will give up further partitioning. In linear regression mode, this simply corresponds to minimum number of instances needed to be in each node. The larger, the more conservative the algorithm will be. [default=1]
#' @param normalize_type Parameter of Dart booster. type of normalization algorithm, options: {'tree', 'forest'}. [default="tree"]
#' @param nthread Number of threads used by per worker. Defaults to 1.
#' @param num_early_stopping_rounds If non-zero, the training will be stopped after a specified number of consecutive increases in any evaluation metric.
#' @param num_round The number of rounds for boosting.
#' @param num_workers number of workers used to train xgboost model. Defaults to 1.
#' @param objective Specify the learning task and the corresponding learning objective. options: reg:linear, reg:logistic, binary:logistic, binary:logitraw, count:poisson, multi:softmax, multi:softprob, rank:pairwise, reg:gamma. default: reg:linear.
#' @param objective_type The learning objective type of the specified custom objective and eval. Corresponding type will be assigned if custom objective is defined options: regression, classification.
#' @param rate_drop Parameter of Dart booster. dropout rate. [default=0.0] range: [0.0, 1.0]
#' @param sample_type Parameter for Dart booster. Type of sampling algorithm. "uniform": dropped trees are selected uniformly. "weighted": dropped trees are selected in proportion to weight. [default="uniform"]
#' @param scale_pos_weight Control the balance of positive and negative weights, useful for unbalanced classes. A typical value to consider: sum(negative cases) / sum(positive cases). [default=1]
#' @param seed Random seed for the C++ part of XGBoost and train/test splitting.
#' @param silent 0 means printing running messages, 1 means silent mode. default: 0
#' @param sketch_eps This is only used for approximate greedy algorithm. This roughly translated into O(1 / sketch_eps) number of bins. Compared to directly select number of bins, this comes with theoretical guarantee with sketch accuracy. [default=0.03] range: (0, 1)
#' @param skip_drop Parameter of Dart booster. probability of skip dropout. If a dropout is skipped, new trees are added in the same manner as gbtree. [default=0.0] range: [0.0, 1.0]
#' @param subsample Subsample ratio of the training instance. Setting it to 0.5 means that XGBoost randomly collected half of the data instances to grow trees and this will prevent overfitting. [default=1] range:(0,1]
#' @param timeout_request_workers the maximum time to wait for the job requesting new workers. default: 30 minutes
#' @param train_test_ratio Fraction of training points to use for testing.
#' @param tree_method The tree construction algorithm used in XGBoost. options: {'auto', 'exact', 'approx'} [default='auto']
#' @param use_external_memory The tree construction algorithm used in XGBoost. options: {'auto', 'exact', 'approx'} [default='auto']
#' @param weight_col Weight column.
#' @param tree_limit Limit number of trees in the prediction; defaults to 0 (use all trees.)
#' @param missing The value treated as missing. default: Float.NaN
#' @template roxlate-ml-algo
#' @template roxlate-ml-formula-params
#' @template roxlate-ml-predictor-params
#' 
#' @export
xgboost_regressor <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
                              min_child_weight = 1, max_delta_step = 0,
                              grow_policy = "depthwise", max_bins = 16, subsample = 1,
                              colsample_bytree = 1, colsample_bylevel = 1, lambda = 1,
                              alpha = 0, tree_method = "auto", sketch_eps = 0.03,
                              scale_pos_weight = 1, sample_type = "uniform",
                              normalize_type = "tree", rate_drop = 0, skip_drop = 0,
                              lambda_bias = 0, tree_limit = 0, num_round = 1,
                              num_workers = 1, nthread = 1, use_external_memory = FALSE,
                              silent = 0, custom_obj = NULL, custom_eval = NULL,
                              missing = NaN, seed = 0, timeout_request_workers = 30 * 60 * 1000,
                              checkpoint_path = "", checkpoint_interval = -1,
                              objective = "reg:linear", base_score = 0.5, train_test_ratio = 1,
                              num_early_stopping_rounds = 0, objective_type = "regression",
                              eval_metric = NULL, maximize_evaluation_metrics = FALSE,
                              base_margin_col = NULL,
                              weight_col = NULL, features_col = "features", label_col = "label",
                              prediction_col = "prediction",
                              uid = random_string("xgboost_regressor_"), ...) {
  UseMethod("xgboost_regressor")
}

#' @export
xgboost_regressor.spark_connection <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
                                               min_child_weight = 1, max_delta_step = 0,
                                               grow_policy = "depthwise", max_bins = 16, subsample = 1,
                                               colsample_bytree = 1, colsample_bylevel = 1, lambda = 1,
                                               alpha = 0, tree_method = "auto", sketch_eps = 0.03,
                                               scale_pos_weight = 1, sample_type = "uniform",
                                               normalize_type = "tree", rate_drop = 0, skip_drop = 0,
                                               lambda_bias = 0, tree_limit = 0, num_round = 1,
                                               num_workers = 1, nthread = 1, use_external_memory = FALSE,
                                               silent = 0, custom_obj = NULL, custom_eval = NULL,
                                               missing = NaN, seed = 0, timeout_request_workers = 30 * 60 * 1000,
                                               checkpoint_path = "", checkpoint_interval = -1,
                                               objective = "reg:linear", base_score = 0.5, train_test_ratio = 1,
                                               num_early_stopping_rounds = 0, objective_type = "regression",
                                               eval_metric = NULL, maximize_evaluation_metrics = FALSE,
                                               base_margin_col = NULL,
                                               weight_col = NULL, features_col = "features", label_col = "label",
                                               prediction_col = "prediction",
                                               uid = random_string("xgboost_regressor_"), ...) {
  
  args <- list(
    eta = eta,
    gamma = gamma,
    max_depth = max_depth,
    min_child_weight = min_child_weight, 
    max_delta_step = max_delta_step,
    grow_policy = grow_policy,
    max_bins = max_bins, 
    subsample = subsample,
    colsample_bytree = colsample_bytree, 
    colsample_bylevel = colsample_bylevel, 
    lambda = lambda,
    alpha = alpha, 
    tree_method = tree_method, 
    sketch_eps = sketch_eps,
    scale_pos_weight = scale_pos_weight, 
    sample_type = sample_type,
    normalize_type = normalize_type, 
    rate_drop = rate_drop, 
    skip_drop = skip_drop,
    lambda_bias = lambda_bias, 
    tree_limit = tree_limit,
    num_round = num_round,
    num_workers = num_workers, 
    nthread = nthread, 
    use_external_memory = use_external_memory,
    silent = silent, 
    custom_obj = custom_obj,
    custom_eval = custom_eval,
    missing = missing,
    seed = seed, 
    timeout_request_workers = timeout_request_workers,
    checkpoint_path = checkpoint_path, 
    checkpoint_interval = checkpoint_interval,
    objective = objective, 
    base_score = base_score, 
    train_test_ratio = train_test_ratio,
    num_early_stopping_rounds = num_early_stopping_rounds,
    objective_type = objective_type,
    eval_metric = eval_metric,
    maximize_evaluation_metrics = maximize_evaluation_metrics,
    base_margin_col = base_margin_col,
    weight_col = weight_col,
    features_col = features_col, 
    label_col = label_col,
    prediction_col = prediction_col, 
    ...
  )
  
  args <- validator_xgboost_regressor(args)
  
  stage_class <- "ml.dmlc.xgboost4j.scala.spark.XGBoostRegressor"
  
  jobj <- sparklyr::spark_pipeline_stage(
    x, class = stage_class, 
    uid = uid, 
    features_col = args[["features_col"]], 
    label_col = args[["label_col"]],
    prediction_col = args[["prediction_col"]]
  ) %>%
    invoke("setAlpha", args[["alpha"]]) %>%
    sparklyr::jobj_set_param("setBaseMarginCol", args[["base_margin_col"]]) %>%
    invoke("setBaseScore", args[["base_score"]]) %>%
    invoke("setCheckpointInterval", args[["checkpoint_interval"]]) %>%
    invoke("setCheckpointPath", args[["checkpoint_path"]]) %>%
    invoke("setColsampleBylevel", args[["colsample_bylevel"]]) %>%
    invoke("setColsampleBytree", args[["colsample_bytree"]]) %>%
    sparklyr::jobj_set_param("setCustomEval", args[["custom_eval"]]) %>%
    sparklyr::jobj_set_param("setCustomObj", args[["custom_obj"]]) %>%
    invoke("setEta", args[["eta"]]) %>%
    sparklyr::jobj_set_param("setEvalMetric", args[["eval_metric"]]) %>%
    invoke("setGamma", args[["gamma"]]) %>%
    invoke("setGrowPolicy", args[["grow_policy"]]) %>%
    invoke("setLambda", args[["lambda"]]) %>%
    invoke("setLambdaBias", args[["lambda_bias"]]) %>%
    invoke("setMaxBins", args[["max_bins"]]) %>%
    invoke("setMaxDeltaStep", args[["max_delta_step"]]) %>%
    invoke("setMaxDepth", args[["max_depth"]]) %>%
    invoke("setMaximizeEvaluationMetrics", args[["maximize_evaluation_metrics"]]) %>%
    invoke("setMinChildWeight", args[["min_child_weight"]]) %>%
    invoke("setNormalizeType", args[["normalize_type"]]) %>%
    invoke("setNthread", args[["nthread"]]) %>%
    invoke("setNumEarlyStoppingRounds", args[["num_early_stopping_rounds"]]) %>%
    invoke("setNumRound", args[["num_round"]]) %>%
    invoke("setNumWorkers", args[["num_workers"]]) %>%
    sparklyr::jobj_set_param("setObjective", args[["objective"]]) %>%
    invoke("setObjectiveType", args[["objective_type"]]) %>%
    invoke("setRateDrop", args[["rate_drop"]]) %>%
    invoke("setSampleType", args[["sample_type"]]) %>%
    invoke("setScalePosWeight", args[["scale_pos_weight"]]) %>%
    invoke("setSeed", args[["seed"]]) %>%
    invoke("setSilent", args[["silent"]]) %>%
    invoke("setSketchEps", args[["sketch_eps"]]) %>%
    invoke("setSkipDrop", args[["skip_drop"]]) %>%
    invoke("setSubsample", args[["subsample"]]) %>%
    invoke("setTimeoutRequestWorkers", args[["timeout_request_workers"]]) %>%
    invoke("setTrainTestRatio", args[["train_test_ratio"]]) %>%
    invoke("setTreeMethod", args[["tree_method"]]) %>%
    invoke("setUseExternalMemory", args[["use_external_memory"]]) %>%
    sparklyr::jobj_set_param("setWeightCol", args[["weight_col"]])
  
  if (!is.nan(args[["missing"]])) {
    jobj <- sparklyr::invoke_static(x, "sparkxgb.Utils", "setMissingParam", jobj, args[["missing"]])
  }
  
  new_xgboost_regressor(jobj)
}

#' @export
xgboost_regressor.ml_pipeline <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
                                          min_child_weight = 1, max_delta_step = 0,
                                          grow_policy = "depthwise", max_bins = 16, subsample = 1,
                                          colsample_bytree = 1, colsample_bylevel = 1, lambda = 1,
                                          alpha = 0, tree_method = "auto", sketch_eps = 0.03,
                                          scale_pos_weight = 1, sample_type = "uniform",
                                          normalize_type = "tree", rate_drop = 0, skip_drop = 0,
                                          lambda_bias = 0, tree_limit = 0, num_round = 1,
                                          num_workers = 1, nthread = 1, use_external_memory = FALSE,
                                          silent = 0, custom_obj = NULL, custom_eval = NULL,
                                          missing = NaN, seed = 0, timeout_request_workers = 30 * 60 * 1000,
                                          checkpoint_path = "", checkpoint_interval = -1,
                                          objective = "reg:linear", base_score = 0.5, train_test_ratio = 1,
                                          num_early_stopping_rounds = 0, objective_type = "regression",
                                          eval_metric = NULL, maximize_evaluation_metrics = FALSE,
                                          base_margin_col = NULL,
                                          weight_col = NULL, features_col = "features", label_col = "label",
                                          prediction_col = "prediction",
                                          uid = random_string("xgboost_regressor_"), ...) {
  stage <- xgboost_regressor.spark_connection(
    x = spark_connection(x),
    formula = formula,
    eta = eta,
    gamma = gamma,
    max_depth = max_depth,
    min_child_weight = min_child_weight, 
    max_delta_step = max_delta_step,
    grow_policy = grow_policy,
    max_bins = max_bins, 
    subsample = subsample,
    colsample_bytree = colsample_bytree, 
    colsample_bylevel = colsample_bylevel, 
    lambda = lambda,
    alpha = alpha, 
    tree_method = tree_method, 
    sketch_eps = sketch_eps,
    scale_pos_weight = scale_pos_weight, 
    sample_type = sample_type,
    normalize_type = normalize_type, 
    rate_drop = rate_drop, 
    skip_drop = skip_drop,
    lambda_bias = lambda_bias, 
    tree_limit = tree_limit,
    num_round = num_round,
    num_workers = num_workers, 
    nthread = nthread, 
    use_external_memory = use_external_memory,
    silent = silent, 
    custom_obj = custom_obj,
    custom_eval = custom_eval,
    missing = missing,
    seed = seed, 
    timeout_request_workers = timeout_request_workers,
    checkpoint_path = checkpoint_path, 
    checkpoint_interval = checkpoint_interval,
    objective = objective, 
    base_score = base_score, 
    train_test_ratio = train_test_ratio,
    num_early_stopping_rounds = num_early_stopping_rounds,
    objective_type = objective_type,
    eval_metric = eval_metric,
    maximize_evaluation_metrics = maximize_evaluation_metrics,
    base_margin_col = base_margin_col,
    weight_col = weight_col,
    features_col = features_col, 
    label_col = label_col,
    prediction_col = prediction_col, 
    uid = uid,
    ...
  )
  sparklyr::ml_add_stage(x, stage)
}

#' @export
xgboost_regressor.tbl_spark <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
                                        min_child_weight = 1, max_delta_step = 0,
                                        grow_policy = "depthwise", max_bins = 16, subsample = 1,
                                        colsample_bytree = 1, colsample_bylevel = 1, lambda = 1,
                                        alpha = 0, tree_method = "auto", sketch_eps = 0.03,
                                        scale_pos_weight = 1, sample_type = "uniform",
                                        normalize_type = "tree", rate_drop = 0, skip_drop = 0,
                                        lambda_bias = 0, tree_limit = 0, num_round = 1,
                                        num_workers = 1, nthread = 1, use_external_memory = FALSE,
                                        silent = 0, custom_obj = NULL, custom_eval = NULL,
                                        missing = NaN, seed = 0, timeout_request_workers = 30 * 60 * 1000,
                                        checkpoint_path = "", checkpoint_interval = -1,
                                        objective = "reg:linear", base_score = 0.5, train_test_ratio = 1,
                                        num_early_stopping_rounds = 0, objective_type = "regression",
                                        eval_metric = NULL, maximize_evaluation_metrics = FALSE,
                                        base_margin_col = NULL,
                                        weight_col = NULL, features_col = "features", label_col = "label",
                                        prediction_col = "prediction",
                                        uid = random_string("xgboost_regressor_"),
                                        response = NULL, features = NULL, ...) {
  
  stage <- xgboost_regressor.spark_connection(
    x = spark_connection(x),
    formula = NULL,
    eta = eta,
    gamma = gamma,
    max_depth = max_depth,
    min_child_weight = min_child_weight, 
    max_delta_step = max_delta_step,
    grow_policy = grow_policy,
    max_bins = max_bins, 
    subsample = subsample,
    colsample_bytree = colsample_bytree, 
    colsample_bylevel = colsample_bylevel, 
    lambda = lambda,
    alpha = alpha, 
    tree_method = tree_method, 
    sketch_eps = sketch_eps,
    scale_pos_weight = scale_pos_weight, 
    sample_type = sample_type,
    normalize_type = normalize_type, 
    rate_drop = rate_drop, 
    skip_drop = skip_drop,
    lambda_bias = lambda_bias, 
    tree_limit = tree_limit,
    num_round = num_round,
    num_workers = num_workers, 
    nthread = nthread, 
    use_external_memory = use_external_memory,
    silent = silent, 
    custom_obj = custom_obj,
    custom_eval = custom_eval,
    missing = missing,
    seed = seed, 
    timeout_request_workers = timeout_request_workers,
    checkpoint_path = checkpoint_path, 
    checkpoint_interval = checkpoint_interval,
    objective = objective, 
    base_score = base_score, 
    train_test_ratio = train_test_ratio,
    num_early_stopping_rounds = num_early_stopping_rounds,
    objective_type = objective_type,
    eval_metric = eval_metric,
    maximize_evaluation_metrics = maximize_evaluation_metrics,
    base_margin_col = base_margin_col,
    weight_col = weight_col,
    features_col = features_col, 
    label_col = label_col,
    prediction_col = prediction_col, 
    uid = uid,
    ...
  )
  
  formula <- sparklyr::ml_standardize_formula(formula, response, features)
  
  if (is.null(formula)) {
    stage %>%
      sparklyr::ml_fit(x)
  } else {
    sparklyr::ml_construct_model_supervised(
      new_ml_model_xgboost_regression, 
      predictor = stage, 
      formula = formula, 
      dataset = x,
      features_col = features_col, 
      label_col = label_col
    )
  }
}

# Validator
validator_xgboost_regressor <- function(args) {
  args[["alpha"]] <- cast_scalar_double(args[["alpha"]], id = "alpha") %>%
    certify(gte(0))
  args[["base_score"]] <- cast_scalar_double(args[["base_score"]], id = "base_score")
  args[["checkpoint_interval"]] <- cast_scalar_integer(args[["checkpoint_interval"]], id = "checkpoint_interval")
  args[["colsample_bylevel"]] <- cast_scalar_double(args[["colsample_bylevel"]], id = "colsample_bylevel") %>%
    certify(bounded(0, 1, incl_lower = FALSE))
  args[["colsample_bytree"]] <- cast_scalar_double(args[["colsample_bytree"]], id = "colsample_bytree") %>%
    certify(bounded(0, 1, incl_lower = FALSE))
  args[["eta"]] <- cast_scalar_double(args[["eta"]], id = "eta") %>%
    certify(bounded(0, 1))
  args[["eval_metric"]] <- if (!is.null(args[["eval_metric"]])) cast_choice(
    args[["eval_metric"]], 
    choices = c("rmse", "mae", "logloss", "error", "merror", "mlogloss", "auc", "aucpr", "ndcg", "map", "gamma-variance"),
    id = "eval_metric"
  )
  args[["gamma"]] <- cast_scalar_double(args[["gamma"]], id = "gamma") %>%
    certify(gte(0))
  args[["lambda"]] <- cast_scalar_double(args[["lambda"]], id = "lambda") %>%
    certify(gte(0))
  args[["lambda_bias"]] <- cast_scalar_double(args[["lambda_bias"]], id = "lambda_bias")
  args[["max_bins"]] <- cast_scalar_integer(args[["max_bins"]], id = "max_bins") %>%
    certify(gte(1))
  args[["max_delta_step"]] <- cast_scalar_double(args[["max_delta_step"]], id = "max_delta_step") %>%
    certify(gte(0))
  args[["max_depth"]] <- cast_scalar_integer(args[["max_depth"]], id = "max_depth") %>%
    certify(gte(1))
  args[["maximize_evaluation_metrics"]] <- cast_scalar_logical(
    args[["maximize_evaluation_metrics"]],
    id = "maximize_evaluation_metrics"
  )
  args[["min_child_weight"]] <- cast_scalar_double(args[["min_child_weight"]], id = "min_child_weight") %>%
    certify(gte(0))
  args[["missing"]] <- cast_scalar_double(args[["missing"]], allow_na = TRUE, id = "missing")
  args[["normalize_type"]] <- cast_choice(args[["normalize_type"]], choices = c("tree", "forest"), id = "normalize_type")
  args[["nthread"]] <- cast_scalar_integer(args[["nthread"]], id = "nthread") %>%
    certify(gte(1))
  args[["num_early_stopping_rounds"]] <- cast_scalar_integer(
    args[["num_early_stopping_rounds"]],
    id = "num_early_stopping_rounds"
  ) %>%
    certify(gte(0))
  args[["num_round"]] <- cast_scalar_integer(args[["num_round"]], id = "num_round") %>%
    certify(gte(1))
  args[["num_workers"]] <- cast_scalar_integer(args[["num_workers"]], id = "num_workers") %>%
    certify(gte(1))
  args[["objective"]] <- cast_choice(
    args[["objective"]],
    choices = c(
      "reg:linear", "reg:logistic", "binary:logistic", "binary:logitraw",
      "count:poisson", "multi:softmax", "multi:softprob", "rank:pairwise",
      "reg:gamma"
    ),
    id = "objective"
  )
  args[["objective_type"]] <- cast_choice(
    args[["objective_type"]], choices = c("regression", "classification"),
    id = "objective_type"
  )
  args[["rate_drop"]] <- cast_scalar_double(args[["rate_drop"]], id = "rate_drop") %>%
    certify(bounded(0, 1))
  args[["sample_type"]] <- cast_choice(args[["sample_type"]], choices = c("uniform", "weighted"), id = "sample_type")
  args[["scale_pos_weight"]] <- cast_scalar_double(args[["scale_pos_weight"]], id = "scale_pos_weight") %>%
    certify(gt(0))
  args[["seed"]] <- cast_scalar_integer(args[["seed"]], id = "seed")
  args[["silent"]] <- cast_scalar_integer(args[["silent"]], id = "silent")
  args[["sketch_eps"]] <- cast_scalar_double(args[["sketch_eps"]], id = "sketch_eps") %>%
    certify(bounded(0, 1))
  args[["skip_drop"]] <- cast_scalar_double(args[["skip_drop"]], id = "skip_drop") %>%
    certify(bounded(0, 1))
  args[["subsample"]] <- cast_scalar_double(args[["subsample"]], id = "subsample") %>%
    certify(bounded(0, 1, incl_lower = FALSE))
  args[["timeout_request_workers"]] <- cast_scalar_integer(args[["timeout_request_workers"]], id = "timeout_request_workers") %>%
    certify(gte(1))
  args[["train_test_ratio"]] <- cast_scalar_double(args[["train_test_ratio"]], id = "train_test_ratio") %>%
    certify(bounded(0, 1))
  args[["tree_method"]] <- cast_choice(args[["tree_method"]], choices = c("auto", "exact", "approx"), id = "tree_method")
  args[["use_external_memory"]] <- cast_scalar_logical(args[["use_external_memory"]], id = "use_external_memory")
  args
}

new_xgboost_regressor <- function(jobj) {
  sparklyr::new_ml_predictor(jobj, class = "xgboost_regressor")
}

new_xgboost_regression_model <- function(jobj) {
  sparklyr::new_ml_prediction_model(
    jobj,
    class = "xgboost_regression_model"
  )
}

new_ml_model_xgboost_regression <- function(pipeline_model, formula, dataset, label_col,
                                            features_col) {
  sparklyr::new_ml_model_regression(
    pipeline_model, formula, dataset = dataset,
    label_col = label_col, features_col = features_col,
    class = "ml_model_xgboost_regression"
  )
}