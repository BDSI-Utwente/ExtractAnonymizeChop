#' Obtain the relative complement of string a in string b
#'
#' Uses libdiff to determine a set of changes necessary to obtain a from b,
#' and returns new content only present in a.
#'
#' Can be used to extract new content from an iterative set of documents, for
#' example logbooks created over time.
#'
#'
#' @param a text to obtain new content from
#' @param b previous version of text b
#'
#' @export
extract_complement <- function(a, b) {
  if (!is.character(a) | !is.character(b)) {
    rlang::abort("both a and b must be atomic character vectors")
  }
  complement$complement(
    a = b,
    b = a
  )
}
