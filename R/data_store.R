#' Data Structure for \pkg{hclust}
#'
#' A data structure which stores the text, DocumentTermMatrix, and information
#' regarding removed text elements which can not be handled by the
#' \code{hierarchical_cluster} function.  This structure is required because it
#' documents important meta information, including removed elements, required by
#' other \pkg{hclustext} functions.  If the user wishes to combine documents
#' (say by a common grouping variable) it is recomended this be handled by
#' \code{\link[textshape]{combine}} prior to using \code{data_store}.
#'
#' @param text A character vector.
#' @param min.term.freq The minimum times a term must appear to be included in
#' the DocumentTermMatrix.
#' @param min.doc.len The minimum words a document must contain to be included
#' in the data structure (other wise it is stored as a \code{removed} element).
#' @return Returns a list containing:
#' \describe{
#'   \item{dtm}{A DocumentTermMatrix of the class \code{"dgCMatrix"}}
#'   \item{text}{The text vector with unanalyzable elements removed}
#'   \item{removed}{The indices of the removed text elements}
#'   \item{n.nonsparse}{The length of the non-zero elements}
#' }
#' @keywords data structure
#' @export
#' @examples
#' data_store(presidential_debates_2012[["dialogue"]])
#'
#' ## Use `combine` to merge text prior to `data_stare`
#' library(textshape)
#' library(dplyr)
#'
#' dat <- presidential_debates_2012 %>%
#'     dplyr::select(person, time, dialogue) %>%
#'     textshape::combine()
#'
#' ## Elements in `ds` correspond to `dat` grouping vars
#' (ds <- with(dat, data_store(dialogue)))
#' dplyr::select(dat, -3)
data_store <- function(text, min.term.freq = 1, min.doc.len = 1){

    stopifnot(is.atomic(text))
    dtm <- gofastr:::q_dtm(text)

    names(text) <- text_seq <- seq_len(length(text))

    # remove terms
    dtm <- dtm[, slam::col_sums(dtm) >= min.term.freq]

    # remove short docs
    long_docs <- slam::row_sums(dtm) >= min.doc.len
    text <- text[long_docs]
    dtm <- dtm[long_docs,]

    # remove terms/docs again (ensure no zero lengths)
    # Eventually determine which elements were kept removed
    dtm <- dtm[, slam::col_sums(dtm) >= 1]

    long_docs <- slam::row_sums(dtm) >= 1
    text <- text[long_docs]
    dtm <- dtm[long_docs,]

    ## Add tf-idf
    dtm <- tm::weightTfIdf(dtm)

    ## Convert DTM to Matrix sparse matrix
    Z <- Matrix::sparseMatrix(dtm$i, dtm$j, x=dtm$v)
    colnames(Z) <- colnames(dtm)
    rownames(Z) <- rownames(dtm)

    out <- list(dtm = Z, text = unname(text),
        removed = setdiff(text_seq, names(text)), n.nonsparse = length(dtm$v))

    class(out) <- "data_store"
    out
}

pn2 <- function(x) prettyNum(x, big.mark = ",", scientific = FALSE)

#' Prints a data_store Object
#'
#' Prints a data_store object
#'
#' @param x A data_store object.
#' @param \ldots ignored.
#' @method print data_store
#' @export
print.data_store <- function(x, ...){
    cat(sprintf("Text Elements      : %s\n", pn2(length(x[["text"]]))  ))
    cat(sprintf("Elements Removed   : %s\n", pn2(length(x[["removed"]])) ))
    cat(sprintf("Documents          : %s\n", pn2(nrow(x[["dtm"]]))  ))
    cat(sprintf("Terms              : %s\n", pn2(ncol(x[["dtm"]]))  ))
    cat(sprintf("Non-/sparse entries: %d/%.0f\n", x[["n.nonsparse"]],
        prod(dim(x[["dtm"]])) - x[["n.nonsparse"]]))
    if (!prod(dim(x))) {
        sparsity <- 100
    } else {
        sparsity <- round((1 - x[["n.nonsparse"]]/prod(dim(x[["dtm"]]))) * 100)
    }
    cat(sprintf("Sparsity           : %s%%\n", sparsity))
    cat(sprintf("Maximal term length: %s\n", max(nchar(colnames(x[["dtm"]])))))
}




