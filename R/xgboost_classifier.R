#' XGBoost Classifier
#'
#' XGBoost classifier for Spark.
#'
#' @inheritParams xgboost_regressor
#' @param num_class Number of classes.
#' @template roxlate-ml-probabilistic-classifier-params
#' @export
xgboost_classifier <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
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
                               objective = "multi:softprob", base_score = 0.5, train_test_ratio = 1,
                               num_early_stopping_rounds = 0, objective_type = "classification",
                               eval_metric = NULL, maximize_evaluation_metrics = FALSE, num_class = NULL,
                               base_margin_col = NULL,
                               thresholds = NULL, weight_col = NULL, features_col = "features", label_col = "label",
                               prediction_col = "prediction", probability_col = "probability",
                               raw_prediction_col = "rawPrediction",
                               uid = random_string("xgboost_classifier_"), ...) {
  UseMethod("xgboost_classifier")
}

#' @export
xgboost_classifier.spark_connection <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
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
                                                objective = "multi:softprob", base_score = 0.5, train_test_ratio = 1,
                                                num_early_stopping_rounds = 0, objective_type = "classification",
                                                eval_metric = NULL, maximize_evaluation_metrics = FALSE, num_class = NULL,
                                                base_margin_col = NULL,
                                                thresholds = NULL, weight_col = NULL, features_col = "features", label_col = "label",
                                                prediction_col = "prediction", probability_col = "probability",
                                                raw_prediction_col = "rawPrediction",
                                                uid = random_string("xgboost_classifier_"), ...) {

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
    num_class = num_class,
    base_margin_col = base_margin_col,
    thresholds = thresholds,
    weight_col = weight_col,
    features_col = features_col,
    label_col = label_col,
    prediction_col = prediction_col,
    probability_col = probability_col,
    raw_prediction_col = raw_prediction_col,
    ...
  )

  args <- validator_xgboost_classifier(args)

  stage_class <- "ml.dmlc.xgboost4j.scala.spark.XGBoostClassifier"

  jobj <- sparklyr::spark_pipeline_stage(
    x,
    class = stage_class,
    uid = uid,
    features_col = args[["features_col"]],
    label_col = args[["label_col"]],
    prediction_col = args[["prediction_col"]],
    probability_col = args[["probability_col"]],
    raw_prediction_col = args[["raw_prediction_col"]]
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
    sparklyr::jobj_set_param("setNumClass", args[["num_class"]]) %>%
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
    sparklyr::jobj_set_param("setThresholds", args[["thresholds"]]) %>%
    invoke("setTimeoutRequestWorkers", args[["timeout_request_workers"]]) %>%
    invoke("setTrainTestRatio", args[["train_test_ratio"]]) %>%
    invoke("setTreeMethod", args[["tree_method"]]) %>%
    invoke("setUseExternalMemory", args[["use_external_memory"]]) %>%
    sparklyr::jobj_set_param("setWeightCol", args[["weight_col"]])

  if (!is.nan(args[["missing"]])) {
    jobj <- sparklyr::invoke_static(x, "sparkxgb.Utils", "setMissingParam", jobj, args[["missing"]])
  }

  new_xgboost_classifier(jobj)
}

#' @export
xgboost_classifier.ml_pipeline <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
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
                                           objective = "multi:softprob", base_score = 0.5, train_test_ratio = 1,
                                           num_early_stopping_rounds = 0, objective_type = "classification",
                                           eval_metric = NULL, maximize_evaluation_metrics = FALSE, num_class = NULL,
                                           base_margin_col = NULL,
                                           thresholds = NULL, weight_col = NULL, features_col = "features", label_col = "label",
                                           prediction_col = "prediction", probability_col = "probability",
                                           raw_prediction_col = "rawPrediction",
                                           uid = random_string("xgboost_classifier_"), ...) {
  stage <- xgboost_classifier.spark_connection(
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
    num_class = num_class,
    base_margin_col = base_margin_col,
    thresholds = thresholds,
    weight_col = weight_col,
    features_col = features_col,
    label_col = label_col,
    prediction_col = prediction_col,
    probability_col = probability_col,
    raw_prediction_col = raw_prediction_col,
    uid = uid,
    ...
  )
  sparklyr::ml_add_stage(x, stage)
}

#' @export
xgboost_classifier.tbl_spark <- function(x, formula = NULL, eta = 0.3, gamma = 0, max_depth = 6,
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
                                         objective = "multi:softprob", base_score = 0.5, train_test_ratio = 1,
                                         num_early_stopping_rounds = 0, objective_type = "classification",
                                         eval_metric = NULL, maximize_evaluation_metrics = FALSE, num_class = NULL,
                                         base_margin_col = NULL,
                                         thresholds = NULL, weight_col = NULL, features_col = "features", label_col = "label",
                                         prediction_col = "prediction", probability_col = "probability",
                                         raw_prediction_col = "rawPrediction",
                                         uid = random_string("xgboost_classifier_"),
                                         response = NULL, features = NULL,
                                         predicted_label_col = "predicted_label", ...) {

  stage <- xgboost_classifier.spark_connection(
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
    num_class = num_class,
    base_margin_col = base_margin_col,
    thresholds = thresholds,
    weight_col = weight_col,
    features_col = features_col,
    label_col = label_col,
    prediction_col = prediction_col,
    probability_col = probability_col,
    raw_prediction_col = raw_prediction_col,
    uid = uid,
    ...
  )

  formula <- sparklyr::ml_standardize_formula(formula, response, features)

  if (is.null(formula)) {
    stage %>%
      sparklyr::ml_fit(x)
  } else {
    sparklyr::ml_construct_model_supervised(
      new_ml_model_xgboost_classification,
      predictor = stage,
      formula = formula,
      dataset = x,
      features_col = features_col,
      label_col = label_col,
      predicted_label_col = predicted_label_col
    )
  }
}

# Validator
validator_xgboost_classifier <- function(args) {
  args <- validator_xgboost_regressor(args)
  args[["thresholds"]] <- cast_nullable_double_list(args[["thresholds"]], id = "thresholds") %>%
    certify(bounded(0, 1), allow_null = TRUE, id = "thresholds")
  args[["num_class"]] <- cast_nullable_scalar_integer(args[["num_class"]], id = "num_class") %>%
    certify(gte(2), allow_null = TRUE, id = "num_class")
  args[["objective"]] <- cast_choice(args[["objective"]], "multi:softprob")

  args
}

new_xgboost_classifier <- function(jobj) {
  sparklyr::new_ml_probabilistic_classifier(jobj, class = "xgboost_classifier")
}

new_xgboost_classification_model <- function(jobj) {
  sparklyr::new_ml_probabilistic_classification_model(
    jobj,
    class = "xgboost_classification_model"
  )
}

new_ml_model_xgboost_classification <- function(pipeline_model, formula, dataset, label_col,
                                                features_col, predicted_label_col) {
  sparklyr::new_ml_model_classification(
    pipeline_model, formula, dataset = dataset,
    label_col = label_col, features_col = features_col,
    predicted_label_col = predicted_label_col,
    class = "ml_model_xgboost_classification"
  )
}

#' @importFrom sparklyr ml_feature_importances
#' @export
ml_feature_importances.ml_model_xgboost_classification <- function(model, ...) {
  gains <- model$model$.jobj %>%
    invoke("nativeBooster") %>%
    invoke(
      "getScore",
      cast_string_list(model$feature_names),
      cast_string("gain")
    )

  feature <- names(gains)
  gains <- as.numeric(gains)

  result <- data.frame(
    feature = feature,
    importance = gains / sum(gains),
    stringsAsFactors = FALSE
  )

  result[order(result$importance, decreasing = TRUE), ]
}
