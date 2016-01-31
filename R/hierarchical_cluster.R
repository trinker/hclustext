#' Title
#'
#' Description
#'
#' @param x
#' @param method
#' @param \ldots
#' @return
#' @references
#' @keywords
#' @export
#' @seealso
#' @examples
#' library(gofastr)
#' library(textshape)
#' library(dplyr)
#'
#' x <- with(presidential_debates_2012, q_tdm(dialogue, paste0(person, "_", time)))
#' y <- presidential_debates_2012 %>%
#'     dplyr::select_('person', 'time', 'dialogue') %>%
#'     textshape::combine()  %>%
#'     dplyr::tbl_df() %>%
#'     dplyr::mutate(
#'         person_time = paste(person, time, sep="_") %>%
#'             factor(levels = colnames(x))
#'     ) %>%
#'     dplyr::arrange(as.numeric(person_time))
#'
#' hierarchical_cluster(x) %>%
#'     plot(k=6)
#'
#' hierarchical_cluster(x) %>%
#'     plot(h=.7, lwd=2)
#'
#' hierarchical_cluster(x) %>%
#'     assign_cluster(y[["dialogue"]], h=.7)
#'
#' hierarchical_cluster(x, method="complete") %>%
#'     plot(k=4)
#'
#' hierarchical_cluster(x) %>%
#'     assign_cluster(y[["dialogue"]], k=6)
hierarchical_cluster <- function(x, method = "ward.D", ...){

    UseMethod("hierarchical_cluster")

}

hierarchical_cluster.TermDocumentMatrix <- function(x, method = "ward.D", ...){

    x <- t(x)
    hierarchical_cluster(x, method = method, ...)
}

hierarchical_cluster.DocumentTermMatrix <- function(x, method = "ward.D", ...){

    removes <- slam::row_sums(x) == 0
    if (sum(removes) == 0){
        removes <- NULL
    } else {
        x <- x[!removes,]
    }

    if ("term frequency" %in% attributes(x)[["weighting"]]) x <- tm::weightTfIdf(x)
    stopifnot("tf-idf" %in% attributes(x)[["weighting"]])

    mat <- proxy::dist(as.matrix(x), method="cosine")
    fit <- stats::hclust(mat, method = method)

    dtm <- new.env(FALSE)
    dtm[["dtm"]] <- x

    class(fit) <- c("hierarchical_cluster", class(fit))
    attributes(fit)[["removed"]] <- if(!is.null(removes)) unname(which(removes)) else NULL
    attributes(fit)[["dtm"]] <- dtm
    fit
}



## Added h here
## for h add a line instead
plot.hierarchical_cluster <- function(x, k = approx_k(get_dtm(x)), h = NULL, color = "red", ...){

    y <- k
    class(x) <- "hclust"
    graphics::plot(x)
    if (!is.null(k) & is.null(h)) stats::rect.hclust(x, k = y, border = color, ...)
    if (!is.null(h)) graphics::abline(h = h, col = color, ...)
}




