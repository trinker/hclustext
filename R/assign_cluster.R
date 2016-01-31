#' Title
#'
#' Description
#'
#' @param x
#' @param text.var
#' @param k
#' @param h
#' @param \ldots
#' @return
#' @references
#' @keywords
#' @export
#' @seealso
#' @examples
assign_cluster <- function(x, text.var, k = approx_k(get_dtm(x)), h = NULL, ...){
    stopifnot(methods::is(x, "hierarchical_cluster"))

    tv <- length(text.var)
    fl <- (length(x[["height"]]) + 1)
    ed <- length(attributes(x)[["removed"]])
    if (is.null(ed)) ed <- 0
    nc <- nchar(prettyNum(max(tv, fl+ed), big.mark = ",", scientific = FALSE))

    if(tv != (fl + ed)) {
        stop(
            "The `x` does not match `text.var` length:\n", "\n",
            paste0("N text.var          :  ", pn(tv, nc)), "\n",
            paste0("N fit + removed     :  ", pn(fl + ed, nc)), "\n",
            paste0("N fit               :  ", pn(fl, nc)), "\n",
            paste0("N removed documents :  ", pn(ed, nc))
        )
    }

    dassign <- rep(NA_integer_, length(text.var))
    if (is.null(attributes(x)[["removed"]])){
        if (!is.null(h)){
            dassign <- stats::cutree(x, h=h)
        } else {
            dassign <- stats::cutree(x, k=k)
        }
    } else {
        if (!is.null(h)){
            dassign[-c(attributes(x)[["removed"]])] <- stats::cutree(x, h=h)
        } else {
            dassign[-c(attributes(x)[["removed"]])] <- stats::cutree(x, k=k)
        }
    }
    dassign

}


