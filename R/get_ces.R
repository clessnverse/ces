#' Get Canadian Election Study Dataset
#'
#' This function downloads and processes a Canadian Election Study dataset for the specified year.
#'
#' @param year A character string indicating the year of the CES data. 
#'   Available years include "1965", "1968", "1974-1980", "1984", "1988", "1993", 
#'   "1997", "2000", "2004", "2006", "2008", "2011", "2015", "2019", "2021".
#' @param format A character string indicating the format to return the data in. 
#'   Default is "tibble". Options include "tibble", "data.frame", or "raw".
#' @param language A character string indicating the language of the survey questions.
#'   Default is "en" (English). Alternative is "fr" (French).
#' @param clean Logical indicating whether to clean the data (recode variables,
#'   convert factors, etc.). Default is TRUE.
#' @param use_cache Logical indicating whether to use cached data if available.
#'   Default is TRUE.
#'
#' @return A tibble or data.frame containing the requested CES data.
#'
#' @examples
#' \dontrun{
#' # Get the 2019 CES data
#' ces_2019 <- get_ces("2019")
#'
#' # Get the 1993 CES data, unprocessed
#' ces_1993_raw <- get_ces("1993", clean = FALSE)
#' }
#'
#' @export
get_ces <- function(year, format = "tibble", language = "en", clean = TRUE, use_cache = TRUE) {
  # Input validation
  valid_years <- ces_datasets$year
  
  if (!year %in% valid_years) {
    stop("Invalid year. Available years are: ", paste(valid_years, collapse = ", "))
  }
  
  valid_formats <- c("tibble", "data.frame", "raw")
  if (!format %in% valid_formats) {
    stop("Invalid format. Available formats are: ", paste(valid_formats, collapse = ", "))
  }
  
  if (!language %in% c("en", "fr")) {
    stop("Invalid language. Available languages are: en, fr")
  }
  
  # Get dataset information
  dataset_info <- ces_datasets[ces_datasets$year == year, ]
  
  if (nrow(dataset_info) == 0) {
    stop("Could not find information for year: ", year)
  }
  
  # Check if data is already cached
  cache_dir <- file.path(tempdir(), "ces")
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }
  
  cache_file <- file.path(cache_dir, paste0("ces_", year, ".rds"))
  
  if (use_cache && file.exists(cache_file)) {
    data <- readRDS(cache_file)
  } else {
    # Download the data
    message("Downloading CES ", year, " data...")
    temp_file <- tempfile(fileext = ".dat")
    utils::download.file(dataset_info$url, temp_file, mode = "wb", quiet = TRUE)
    
    # Read the data based on format and encoding
    if (!requireNamespace("haven", quietly = TRUE)) {
      stop("Package 'haven' is required to read this data. Please install it.")
    }
    
    if (dataset_info$format == "stata") {
      data <- haven::read_dta(temp_file, encoding = dataset_info$encoding)
    } else {
      # Default to SPSS format
      if (dataset_info$encoding == "default") {
        data <- haven::read_sav(temp_file)
      } else {
        data <- haven::read_sav(temp_file, encoding = dataset_info$encoding)
      }
    }
    
    # Save to cache
    if (use_cache) {
      saveRDS(data, cache_file)
    }
    
    # Clean up temporary files
    unlink(temp_file)
  }
  
  # Clean the data if requested
  if (clean) {
    data <- clean_ces_data(data, year, language)
  }
  
  # Convert to requested format
  if (format == "tibble") {
    if (!requireNamespace("tibble", quietly = TRUE)) {
      warning("Package 'tibble' is required to return a tibble. Returning a data.frame instead.")
      data <- as.data.frame(data)
    } else {
      data <- tibble::as_tibble(data)
    }
  } else if (format == "data.frame") {
    data <- as.data.frame(data)
  }
  
  return(data)
}

#' Clean Canadian Election Study Dataset
#'
#' This function performs cleaning operations on CES data, including recoding variables,
#' converting factors, and standardizing column names.
#'
#' @param data A tibble or data.frame containing raw CES data.
#' @param year A character string indicating the year of the CES data.
#' @param language A character string indicating the language for labels ("en" or "fr").
#'
#' @return A cleaned tibble with standardized variables.
#'
#' @keywords internal
clean_ces_data <- function(data, year, language = "en") {
  # Common cleaning operations across all datasets
  
  # 1. Convert haven_labelled class to factors with proper labels
  if (requireNamespace("haven", quietly = TRUE)) {
    labelled_cols <- sapply(data, function(x) inherits(x, "haven_labelled"))
    
    if (any(labelled_cols)) {
      for (col in names(data)[labelled_cols]) {
        # Get the labels
        labels <- attr(data[[col]], "labels")
        
        if (length(labels) > 0) {
          # Create a named vector for the labels
          label_names <- names(labels)
          
          # If no names, use the values themselves
          if (is.null(label_names)) {
            label_names <- as.character(labels)
          }
          
          # Create the factor
          data[[col]] <- factor(haven::as_factor(data[[col]]))
        }
      }
    }
  }
  
  # 2. Standardize variable names - lowercase and replace spaces with underscores
  names(data) <- tolower(names(data))
  names(data) <- gsub("\\s+", "_", names(data))
  
  # 3. Handle year-specific cleaning
  if (year == "2019") {
    # Example: Specific cleaning for 2019 dataset
  } else if (year == "2015") {
    # Example: Specific cleaning for 2015 dataset
  }
  
  return(data)
}