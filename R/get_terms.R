#' Get Terms Based on Cluster Assignment in \code{assign_cluster}
#'
#' Get the terms weighted and scaled by tf-idf + min/max scaling associated with
#' each of the k clusters .
#'
#' @param object A \code{\link[hclustext]{assign_cluster}} object.
#' @param term.cutoff The lowest min/max scaled tf-idf weighting to consider
#' as a document's salient term.
#' @param min.n The minimum number o terms a term must appear in a topic to be
#' displayed in the returned \code{\link[base]{data.frame}}s.
#' @param nrow The max number of rows to display in the returned
#' \code{\link[base]{data.frame}}s.
#' @param \ldots ignored.
#' @return Returns a list of \code{\link[base]{data.frame}}s of top weighted terms.
#' @export
#' @rdname get_terms
#' @examples
#' library(dplyr)
#' library(textshape)
#'
#' myterms <- presidential_debates_2012 %>%
#'     with(data_store(dialogue)) %>%
#'     hierarchical_cluster() %>%
#'     assign_cluster(k = 55) %>%
#'     get_terms()
#'
#' myterms
#' textshape::bind_list(myterms, "Topic")
#' \dontrun{
#' library(ggplot2)
#' library(gridExtra)
#' library(dplyr)
#' library(textshape)
#' library(wordcloud)
#'
#' max.n <- max(textshape::bind_list(myterms)[["n"]])
#'
#' myplots <- Map(function(x, y){
#'     x %>%
#'         mutate(term = factor(term, levels = rev(term))) %>%
#'         ggplot(aes(term, weight=n)) +
#'             geom_bar() +
#'             scale_y_continuous(expand = c(0, 0),limits=c(0, max.n)) +
#'             ggtitle(sprintf("Topic: %s", y)) +
#'             coord_flip()
#' }, myterms, names(myterms))
#'
#' myplots[["ncol"]] <- 10
#'
#' do.call(gridExtra::grid.arrange, myplots[!sapply(myplots, is.null)])
#'
#' ##wordclouds
#' par(mfrow=c(5, 11), mar=c(0, 4, 0, 0))
#' Map(function(x, y){
#'     wordcloud::wordcloud(x[[1]], x[[2]], scale=c(1,.25),min.freq=1)
#'     mtext(sprintf("Topic: %s", y), col = "blue", cex=.55, padj = 1.5)
#' }, myterms, names(myterms))
#' }
get_terms <- function(object, term.cutoff = .1, min.n = 2, nrow = NULL, ...){
    UseMethod("get_terms")
}

#' @export
#' @rdname get_terms
#' @method get_terms assign_cluster
get_terms.assign_cluster <- function(object, term.cutoff = .1, min.n = 2, nrow = NULL, ...){

    desc <- topic <- n <- NULL
    dat <- attributes(x)[["data_store"]][["data"]]

    term <- as.data.frame(textshape::bind_list(apply(min_max(as.matrix(dat[["dtm"]])), 1, function(x) {
        names(which(x > term.cutoff))
    }), "doc", "term"), stringsAsFactors = FALSE)
    doc_top_term <- dplyr::left_join(as.data.frame(textshape::bind_list(x, "doc", "topic"), stringsAsFactors = FALSE), term, by = "doc")
    out <- dplyr::tally(dplyr::group_by(dplyr::filter(doc_top_term, !is.na(term)), topic, term))
    out <- dplyr::arrange(dplyr::group_by(out, topic), desc(n))
    out <- dplyr::filter(out, n >= min.n)
    if (!is.null(nrow)) out <- dplyr::filter(dplyr::slice(dplyr::group_by(out, topic), 1:nrow), !is.na(n))
    out2 <- lapply(split(as.data.frame(out, stringsAsFactors = FALSE)[, 2:3], out[[1]]), function(x) {rownames(x) <- NULL;x})
    class(out2) <- c("get_terms", class(out2))
    out2
}

#' Prints a get_terms Object
#'
#' Prints a get_terms object
#'
#' @param x A get_terms object.
#' @param \ldots ignored.
#' @method print get_terms
#' @export
print.get_terms <- function(x, ...){
    class(x) <- "list"
    print(x)
}





