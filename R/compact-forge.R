cast_string <- function(x, ...) {
  vctrs::vec_check_size(x, 1, arg = rlang::caller_arg(x), call = rlang::caller_env())
  vctrs::vec_cast(x, character())
}

cast_scalar_logical <- function(x, ...) {
  vctrs::vec_check_size(x, 1, arg = rlang::caller_arg(x), call = rlang::caller_env())
  vctrs::vec_cast(x, logical())
}

cast_scalar_double <- function(x, ...) {
  vctrs::vec_check_size(x, 1, arg = rlang::caller_arg(x), call = rlang::caller_env())
  vctrs::vec_cast(x, numeric())
}

cast_scalar_integer <- function(x, ...) {
  vctrs::vec_check_size(x, 1, arg = rlang::caller_arg(x), call = rlang::caller_env())
  vctrs::vec_cast(x, integer())
}

cast_nullable_scalar_integer <- function(x, ...) {
  if (is.null(x)) {
    return(NULL)
  }

  cast_scalar_integer(x)
}

cast_list <- function(x, ptype, allow_null = FALSE, ...) {
  if (is.null(x)) {
    if (allow_null) {
      return(NULL)
    } else {
      rlang::abort("{.arg x} must not be `NULL`.")
    }
  }

  if (is.list(x)) {
    x <- vctrs::list_unchop(x)
  }
  x <- vctrs::vec_cast(x, to = ptype)
  vctrs::vec_chop(x)
}

cast_string_list <- function(x, allow_null = FALSE, ...) {
  cast_list(x, character(), allow_null = allow_null)
}

cast_choice <- function(x, choices, error_arg = rlang::caller_arg(x),
                        error_call = rlang::caller_env(), ...) {
  rlang::arg_match(x, choices, error_arg = error_arg, error_call = error_call)
}

# TODO: Real processing needed
certify <- function(x, ..., allow_null = FALSE, id = NULL, return_id = FALSE) {
  x
}

gt <- function(l) {
  force(l)
  function(x) all(x > l)
}

gte <- function(l) {
  force(l)
  function(x) all(x >= l)
}

bounded <- function(l = NULL, u = NULL, incl_lower = TRUE, incl_upper = TRUE) {
  if (is.null(l) && is.null(u)) stop("At least one of `l` or `u` must be specified.", call. = FALSE)

  lower_bound <- if (!is.null(l)) {
    if (incl_lower) gte(l) else gt(l)
  } else {
    function() TRUE
  }

  upper_bound <- if (!is.null(u)) {
    if (incl_upper) lte(u) else lt(u)
  } else {
    function() TRUE
  }

  function(x) lower_bound(x) && upper_bound(x)
}

lt <- function(u) {
  force(u)
  function(x) all(x < u)
}

lte <- function(u) {
  force(u)
  function(x) all(x <= u)
}
