cosine_dist_mat <- function(tdm) {
    slam::crossprod_simple_triplet_matrix(tdm)/(sqrt(slam::col_sums(tdm^2) %*% t(slam::col_sums(tdm^2))))
}

approx_k <- function(x, verbose = TRUE) {
    m <- round(do.call("*", as.list(dim(x)))/length(x[["i"]]))
    if (verbose) cat(sprintf("\nk approximated to: %s\n", m))
    m
}


pn <- function(x, y) {
    m <- prettyNum(x, big.mark = ",", scientific = FALSE)
    paste0(paste(rep(" ", y - nchar(m)), collapse = ""), m)
}
