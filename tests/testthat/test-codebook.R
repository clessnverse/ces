test_that("download_codebook validates inputs correctly", {
  # Test that invalid year throws error
  expect_error(download_codebook("9999"), "Invalid year")
})