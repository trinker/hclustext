#' Title
#'
#' Description
#'
#' @param x
#' @param verbose
#' @return
#' @references
#' @keywords
#' @export
#' @seealso
#' @examples
approx_k <- function(x, verbose = TRUE) {
    m <- round(do.call("*", as.list(dim(x)))/length(x[["i"]]))
    if (verbose) cat(sprintf("\nk approximated to: %s\n", m))
    m
}

