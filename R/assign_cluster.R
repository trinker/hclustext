#' Assign Clusters to Documents/Text Elements
#'
#' Assign clusters to documents/text elements.
#'
#' @param x a \code{hierarchical_cluster} object.
#' @param k The number of clusters (can supply \code{h} instead).  Defaults to
#' use \code{approx_k} of the \code{\link[tm]{DocumentTermMatrix}} produced
#' by \code{data_storage}.
#' @param h The height at which to cut the dendrograms (determines number of
#' clusters).  If this argument is supplied \code{k} is ignored.
#' @param \ldots ignored.
#' @return Returns an \code{assign_cluster} object; a named vector of cluster
#' assignments with documents as names.  The object also contains the original
#' \code{data_storage} object.
#' @rdname assign_cluster
#' @export
#' @examples
#' library(dplyr)
#'
#' x <- with(
#'     presidential_debates_2012,
#'     data_store(dialogue, paste(person, time, sep = "_"))
#' )
#'
#' hierarchical_cluster(x) %>%
#'     plot(h=.7, lwd=2)
#'
#' hierarchical_cluster(x) %>%
#'     assign_cluster(h=.7)
#'
#' hierarchical_cluster(x, method="complete") %>%
#'     plot(k=6)
#'
#' hierarchical_cluster(x) %>%
#'     assign_cluster(k=6)
#'
#'
#' x2 <- presidential_debates_2012 %>%
#'     with(data_store(dialogue)) %>%
#'     hierarchical_cluster()
#'
#' ca <- assign_cluster(x2, k = 55)
#' summary(ca)
#'
#' ## split text into clusters
#' get_text(ca)
assign_cluster <- function(x, k = approx_k(get_dtm(x)), h = NULL, ...){
     UseMethod("assign_cluster")
}


#' @export
#' @rdname assign_cluster
#' @method assign_cluster hierarchical_cluster
assign_cluster.hierarchical_cluster <- function(x, k = approx_k(get_dtm(x)), h = NULL, ...){

#     tv <- length(get_text(x))
#     fl <- (length(x[["height"]]) + 1)
#     ed <- length(get_removed(x))
#     nc <- nchar(pn2(max(tv, fl+ed)))
#
#     if(tv != (fl + ed)) {
#         stop(
#             "The `x` does not match `text.var` length:\n", "\n",
#             paste0("N text.var          :  ", pn(tv, nc)), "\n",
#             paste0("N fit + removed     :  ", pn(fl + ed, nc)), "\n",
#             paste0("N fit               :  ", pn(fl, nc)), "\n",
#             paste0("N removed documents :  ", pn(ed, nc))
#         )
#     }
#
#     dassign <- rep(NA_integer_, length(get_text(x)))
    if (!is.null(h)){
        out <- stats::cutree(x, h=h)
    } else {
        out <- stats::cutree(x, k=k)
    }

    class(out) <- c("assign_cluster", class(out))

    attributes(out)[["data_store"]] <- attributes(x)[["text_data_store"]]
    out

}


#' Prints an assign_cluster Object
#'
#' Prints an assign_cluster object
#'
#' @param x An assign_cluster object.
#' @param \ldots ignored.
#' @method print assign_cluster
#' @export
print.assign_cluster <- function(x, ...){
    print(stats::setNames(as.integer(x), names(x)))
}


#' Summary of an assign_cluster Object
#'
#' Summary of an assign_cluster object
#'
#' @param object An assign_cluster object.
#' @param plot logical.  If \code{TRUE} an accompanying bar plot is produced a
#' well.
#' @param \ldots ignored.
#' @method summary assign_cluster
#' @export
summary.assign_cluster <- function(object, plot = TRUE, ...){
    count <- NULL
    out <- textshape::bind_table(table(as.integer(object)), "cluster", "count")
    if (isTRUE(plot)) print(termco::plot_counts(as.integer(object), item.name = "Cluster"))
    dplyr::arrange(as.data.frame(out), dplyr::desc(count))
}





