anonymize <- NULL
extract <- NULL
complement <- NULL

env_name <- "eac-text-env"
python_version <- "3.9.6"

.onLoad <- function(library, package) {
    if(!reticulate::virtualenv_exists(env_name)){
        install <- utils::askYesNo("Python environment not initialized. Would you like to do so now?")
        if(install) {
            setup_environment()
            load_environment(package)
        }
    } else {
        load_environment(package)
    }
}

load_environment <- function(package) {
    reticulate::use_virtualenv(env_name, TRUE)
    anonymize <<- reticulate::import_from_path("anonymize", system.file("python", package = package))
    extract <<- reticulate::import_from_path("extract", system.file("python", package = package), delay_load = TRUE)
    complement <<- reticulate::import_from_path("complement", system.file("python", package = package), delay_load = TRUE)
}

setup_environment <- function() {
    reticulate::install_python(python_version)
    reticulate::use_python_version(python_version)
    reticulate::virtualenv_create(env_name, version = python_version)
    reticulate::use_virtualenv(env_name, TRUE)
    reticulate::virtualenv_install(env_name, c(
        "spacy",
        "tika",
        "fuzzysearch",
        "fuzzywuzzy",
        "python-levenshtein",
        "pymupdf",
        "docx2pdf"))
    if(!reticulate::py_module_available("en_core_web_md")){
        shell("python -m spacy download en_core_web_md", intern = TRUE)
    }
}
