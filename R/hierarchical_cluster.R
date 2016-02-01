#' Fit a Hierarchical Cluster
#'
#' Fit a hierarchical cluster to text data.  Uses cosine dissimilarity to generate
#' the distance matrix used in \code{\link[fastcluster]{hclust}}.  \code{method}
#' defaults to \code{"ward.D2"}.  A faster cosine dissimilarity calculation is used
#' under the hood (see \code{\link[hclustext]{cosine_distance}}).  Additionally,
#' \code{\link[fastcluster]{hclust}} is used to quickly calculate the fit.
#' Essentially, this is a wrapper function optimized for clustering text data.
#'
#' @param x A data type (e.g., \code{\link[tm]{DocumentTermMatrix}} or
#' \code{\link[tm]{TermDocumentMatrix}}).
#' @param method The agglomeration method to be used. This must be (an
#' unambiguous abbreviation of) one of \code{"single"}, \code{"complete"},
#' \code{"average"}, \code{"mcquitty"}, \code{"ward.D"}, \code{"ward.D2"},
#' \code{"centroid"}, or \code{"median"}.
#' @param \ldots ignored.
#' @return Returns an object of class \code{"hclust"}.
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
#'
#' x2 <- presidential_debates_2012 %>%
#'     with(q_dtm(dialogue))
#'
#' myfit2 <- hierarchical_cluster(x2)
#'
#' plot(myfit2)
#' plot(myfit2, 55)
hierarchical_cluster <- function(x, method = "ward.D2", ...){

    UseMethod("hierarchical_cluster")

}

#' @export
#' @rdname hierarchical_cluster
#' @method hierarchical_cluster TermDocumentMatrix
hierarchical_cluster.TermDocumentMatrix <- function(x, method = "ward.D", ...){

    x <- t(x)
    hierarchical_cluster(x, method = method, ...)
}

#' @export
#' @rdname hierarchical_cluster
#' @method hierarchical_cluster DocumentTermMatrix
hierarchical_cluster.DocumentTermMatrix <- function(x, method = "ward.D", ...){

    removes <- slam::row_sums(x) == 0
    if (sum(removes) == 0){
        removes <- NULL
    } else {
        x <- x[!removes,]
    }

    if ("term frequency" %in% attributes(x)[["weighting"]]) x <- tm::weightTfIdf(x)
    stopifnot("tf-idf" %in% attributes(x)[["weighting"]])

    #mat <- proxy::dist(as.matrix(x), method="cosine")
    mat <- cosine_distance(x)
    #fit <- stats::hclust(mat, method = method)
    fit <- fastcluster::hclust(mat, method = method)

    dtm <- new.env(FALSE)
    dtm[["dtm"]] <- x

    class(fit) <- c("hierarchical_cluster", class(fit))
    attributes(fit)[["removed"]] <- if(!is.null(removes)) unname(which(removes)) else NULL
    attributes(fit)[["dtm"]] <- dtm
    fit
}



#' Plots a hierarchical_cluster Object
#'
#' Plots a hierarchical_cluster object
#'
#' @param x A hierarchical_cluster object.
#' @param k The number of clusters (can supply \code{h} instead).  Defaults to
#' use \code{approx_k} of the \code{\link[tm]{DocumentTermMatrix}} used/produced
#' in \code{hierarchical_cluster}.  Boxes are drawn around the clusters.
#' @param h The height at which to cut the dendrograms (determines number of
#' clusters).  If this argument is supplied \code{k} is ignored. A line is drawn
#' showing the cut point on the dendrogram.
#' @param color The color to make the cluster boxes (\code{k}) or line (\code{h}).
#' @param \ldots
#' @method plot hierarchical_cluster
#' @export
plot.hierarchical_cluster <- function(x, k = approx_k(get_dtm(x)), h = NULL,
    color = "red", ...){

    y <- k
    class(x) <- "hclust"
    graphics::plot(x)
    if (!is.null(k) & is.null(h)) stats::rect.hclust(x, k = y, border = color, ...)
    if (!is.null(h)) graphics::abline(h = h, col = color, ...)
}




