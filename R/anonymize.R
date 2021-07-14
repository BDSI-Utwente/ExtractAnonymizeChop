#' Replace or remove dates and times from a character string
#'
#' @param text text to remove dates and times from
#' @param replace logical Should dates and times be replaced with a generic token?
#'
#' @return text without dates and times
#' @export
#'
#' @examples
#' anonymize_dates("last friday, I took my friends fishing. That was the 13th of august. I'll never forget it, my first child was born the next year.", TRUE)
#'
#' # it's not perfect...
#' anonymize_dates("2021-12-31, that's the day the year ends. We usually celebrate around midnight, or 12PM if you will - or if you're European, 00:00", TRUE)
anonymize_dates <- function(text, replace = FALSE) {
  anonymize$anonymize_dates(
    text = text,
    replace = replace
  )
}

#' Remove or replace references to a known list of persons.
#'
#' Uses fuzzy matching to find near references and alternate spellings. Allows
#' removal, replacement with a generic token, or replacement with a given string.
#'
#' @param text text to remove references from
#' @param persons character vector of known persons to remove
#' @param replace either a boolean value to remove references (FALSE), replace
#' references with a generic token (TRUE), or a character vector of the same
#' length as `persons` to replace references with.
#'
#' @return anonymized text
#' @export
#'
#' @examples
#'
#' anonymize_known_persons("Jan-Peter Balkenende was jarenlang de minister-president van Nederland. Hij was ook wel bekend als Harry Potter. Meneer Balkenende is ondertussen uit het publieke leven verdwenen.", c("Jan-Peter Balkenende"), TRUE)
anonymize_known_persons <- function(text, persons, replace = FALSE) {
  if (!is.list(persons)) rlang::abort("persons must be a list of persons to replace")
  anonymize$anonymize_known_persons(
    text = text,
    persons = persons,
    replace = replace
  )
}


#' Removes or replaces all detected references to named persons in text
#'
#' @param text text to anonymize
#' @param replace if TRUE, replace reference with generic tokens. If FALSE (the
#' default), removes references completely.
#'
#' @return anonymized text
#' @export
#'
#' @examples
#'
#' anonymize_unknown_persons("Hi, my name is John Doe. My favourite superhero is Deadpool. My dog, Fido, loves watching Spongebob Squarepants")
anonymize_unknown_persons <- function(text, replace = FALSE) {
  anonymize$anonymize_unknown_persons(
    text = text,
    replace = replace
  )
}

#' Remove or replace regular expression patterns
#'
#' @param text text to anonymize
#' @param patterns list of regular expressions to match
#' @param replace either a boolean value to remove references (FALSE), replace
#' references with a generic token (TRUE), or a list of replacement strings of the same
#' length as `patterns`.
#'
#' @return anonymized text
#' @export
#'
#' @examples
#' # a simple email and student/employee/guest id pattern
#' anonymize_patterns("my email address is k.a.kroeze@utwente.nl, my employee number is m1234567",
#'   list("[a-z0-9\\-_\\.]+@[a-z0-9\\-_\\.]+\\.[a-z]{2,}", "[msx][0-9]{7}"),
#'   list("EMAIL", "ID_NUMBER"))
anonymize_patterns <- function(text, patterns, replace = FALSE) {
  if (!is.list(patterns)) rlang::abort("patterns must be a list of persons to replace")
  if (!is.list(replace) & !is.logical(replace)) rlang::abort("replace must be logical or a list of replacement string")
  if (is.list(replace) & length(replace) != length(patterns)) rlang::abort("patterns and replacements must be of the same length")
  anonymize$anonymize_patterns(
    text = text,
    patterns = patterns,
    replace = replace
  )
}


#' Extract references to named persons from a text
#'
#' Uses the default english model (en_core_web_md) available in spacy to extract
#' named entities.
#'
#' @param text
#'
#' @return list of named entities recognized as persons
#' @export
#'
#' @examples
#'
#' get_person_entities("John, Jane and Peter walked down the road to Mr. Blueberry")
get_person_entities <- function(text) {
  anonymize$get_person_entities(
    text = text
  )
}
