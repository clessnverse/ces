# CRAN Submission Checklist

## Essential Checks
- [x] Package passes `R CMD check` with **0 errors, 0 warnings, 0 notes**
- [x] Package has been tested on Linux
- [x] Package has been tested on Windows (via check_win_devel)
- [ ] Package has been tested on macOS (skip if not critical)
- [x] DESCRIPTION file is complete and correct
- [x] Title is in title case and doesn't end with a period
- [x] Description field includes `<https://...>` format for URLs
- [x] Author information is complete and accurate
- [x] License field and LICENSE file match and are valid
- [x] Version number follows semantic versioning (0.1.0 for first submission)
- [x] All exports are documented with examples
- [x] Package has at least one test
- [x] Package has at least one vignette
- [x] All examples that download external resources are wrapped in `\dontrun{}`
- [x] Package needs accurate README.md
- [x] Package has no hidden files or empty directories

## Documentation
- [x] Package-level documentation is comprehensive
- [x] All exported functions have documentation
- [x] All function parameters are documented
- [x] All functions have examples
- [x] Examples that need internet access use `\dontrun{}`
- [x] Vignette provides an overview of the package
- [x] NEWS.md documents changes

## Cross-platform Compatibility
- [x] All file paths use `file.path()` not manual string concatenation
- [x] Directory creation is handled properly (`dir.create()` with error checks)
- [x] File permissions are handled appropriately
- [x] Temporary directories are used safely with `tempdir()`
- [x] Network downloads have proper error handling
- [x] Handles file not found errors appropriately

## CRAN Notes
- [x] cran-comments.md file includes:
  - [x] Description of the package
  - [x] Test environments section (Linux, Windows, etc.)
  - [x] R CMD check results
  - [x] Downstream dependencies (or note that there are none)
  - [x] Any responses to CRAN team feedback (if resubmission)

## Functions That Handle External Resources
- [x] `download_pdf_codebook()` - Has proper error handling for network issues
- [x] `download_ces_dataset()` - Has proper error handling for network issues 
- [x] `download_all_ces_datasets()` - Has proper error handling for network issues
- [x] `get_ces()` - Has proper error handling for network issues

## Final Checks
- [x] Run `devtools::spell_check()` to find spelling errors
- [x] Run `devtools::check(cran = TRUE)` for final verification
- [x] Run `devtools::check_win_devel()` for Windows testing
- [x] Use `Sys.setenv("_R_CHECK_SYSTEM_CLOCK_" = "0")` for time verification issues