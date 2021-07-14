#' Extract text from a formatted document
#'
#' Extracts text from a variety of popular document formats, including docx, pdf,
#' powerpoint, excel, open office, etc. Uses the `tika`, `pymupdf` and `docx2pdf`
#' python libraries to obtain a reasonably uniform output.
#'
#' @param path [string] path to the document
#' @param page [number] for pdf documents, extracts the given page only. Will
#' attempt to automatically convert to pdf for other formats.
#'
#' @export
extract_text <- function(path, page = -1L) {
  if(!file.exists(path)) rlang::abort(paste(path, "does not exist"))
  extract$extract_text(
    path = path,
    page = page
  )
}
