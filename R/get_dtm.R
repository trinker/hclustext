#' Title
#'
#' Description
#'
#' @param x
#' @param \ldots
#' @return
#' @references
#' @keywords
#' @export
#' @seealso
#' @examples
get_dtm <- function(x, ...){
    UseMethod("get_dtm")
}


get_dtm.hierarchical_cluster <- function(x, ...){
    attributes(x)[["dtm"]][["dtm"]]
}

