pn <- function(x, y) {
    m <- prettyNum(x, big.mark = ",", scientific = FALSE)
    paste0(paste(rep(" ", y - nchar(m)), collapse = ""), m)
}
