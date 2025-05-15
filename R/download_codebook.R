#' Download Canadian Election Study Codebook PDF
#'
#' This function downloads the official PDF codebook for a specified year of the Canadian
#' Election Study. The codebook contains detailed information about all variables,
#' question wording, response codes, and methodological details.
#'
#' @param year A character string indicating the year of the CES data. 
#'   Available years include "1965", "1968", "1974-1980", "1984", "1988", "1993", 
#'   "1997", "2000", "2004", "2006", "2008", "2011", "2015", "2019", "2021".
#' @param path A character string indicating the directory where the codebook should
#'   be saved. If NULL (default), the codebook will be saved to the current
#'   working directory or the system's Downloads folder if it exists.
#' @param overwrite Logical indicating whether to overwrite existing files.
#'   Default is FALSE.
#' @param verbose Logical indicating whether to display detailed progress messages
#'   during download. Default is TRUE.
#'
#' @return Invisibly returns the file path of the downloaded codebook.
#'
#' @examples
#' \dontrun{
#' # Download the 2019 CES codebook to the default location
#' download_codebook("2019")
#'
#' # Download to a specific directory
#' download_codebook("2015", path = "~/Documents/CES_codebooks")
#' 
#' # Overwrite existing file
#' download_codebook("2021", overwrite = TRUE)
#' }
#'
#' @export
download_codebook <- function(year, path = NULL, overwrite = FALSE, verbose = TRUE) {
  # Input validation
  valid_years <- c("1965", "1968", "1974-1980", "1984", "1988", "1993", 
                   "1997", "2000", "2004", "2006", "2008", "2011", 
                   "2015", "2019", "2021")
  
  if (!year %in% valid_years) {
    stop("Invalid year. Available years are: ", paste(valid_years, collapse = ", "))
  }
  
  # Get dataset information from internal data
  dataset_info <- ces_datasets[ces_datasets$year == year, ]
  
  if (nrow(dataset_info) == 0) {
    stop("Could not find information for year: ", year)
  }
  
  # Get the codebook URL for the requested year
  codebook_url <- dataset_info$codebook_url
  
  # If path is NULL, use a sensible default
  if (is.null(path)) {
    # Try to find the Downloads folder
    downloads_dir <- file.path(Sys.getenv("HOME"), "Downloads")
    
    if (dir.exists(downloads_dir)) {
      path <- downloads_dir
    } else {
      # Fall back to current working directory
      path <- getwd()
    }
  }
  
  # Create the directory if it doesn't exist
  if (!dir.exists(path)) {
    if (verbose) message("Creating directory: ", path)
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  
  # Define the full file path
  file_name <- paste0("CES_", year, "_codebook.pdf")
  file_path <- file.path(path, file_name)
  
  # Check if file already exists
  if (file.exists(file_path) && !overwrite) {
    stop("File already exists: ", file_path, 
         "\nUse overwrite = TRUE to overwrite the existing file.")
  }
  
  # Create a helper function for conditional messaging
  msg <- function(text) {
    if (verbose) message(text)
  }
  
  # Download the codebook
  msg(paste0("Downloading CES ", year, " codebook from ", codebook_url))
  msg(paste0("Saving to: ", file_path))
  
  # Use utils::download.file with progress bar
  tryCatch({
    utils::download.file(
      url = codebook_url,
      destfile = file_path,
      mode = "wb",       # Binary mode for PDF files
      quiet = !verbose,  # Show progress based on verbose setting
      method = NULL      # Auto-select the best method
    )
    
    msg(paste0("Successfully downloaded codebook to: ", file_path))
    
    # Check that the file exists and has content
    if (file.exists(file_path) && file.size(file_path) > 0) {
      msg("Codebook download completed successfully.")
    } else {
      stop("Downloaded file has no content or does not exist.")
    }
  },
  error = function(e) {
    # If download fails, provide a helpful error message
    stop("Failed to download codebook: ", e$message, 
         "\nPlease check your internet connection and try again.")
  })
  
  # Return the file path invisibly
  return(invisible(file_path))
}