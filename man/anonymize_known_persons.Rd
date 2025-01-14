% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anonymize.R
\name{anonymize_known_persons}
\alias{anonymize_known_persons}
\title{Remove or replace references to a known list of persons.}
\usage{
anonymize_known_persons(text, persons, replace = FALSE)
}
\arguments{
\item{text}{text to remove references from}

\item{persons}{character vector of known persons to remove}

\item{replace}{either a boolean value to remove references (FALSE), replace
references with a generic token (TRUE), or a character vector of the same
length as \code{persons} to replace references with.}
}
\value{
anonymized text
}
\description{
Uses fuzzy matching to find near references and alternate spellings. Allows
removal, replacement with a generic token, or replacement with a given string.
}
\examples{

anonymize_known_persons("Jan-Peter Balkenende was jarenlang de minister-president van Nederland. Hij was ook wel bekend als Harry Potter. Meneer Balkenende is ondertussen uit het publieke leven verdwenen.", c("Jan-Peter Balkenende"), TRUE)
}
