test_that("create_codebook works with basic data.frame", {
  # Create a simple data.frame with attributes
  test_df <- data.frame(
    q1 = c(1, 2, 3),
    q2 = c("A", "B", "C"),
    q3 = factor(c("Low", "Medium", "High"))
  )
  
  # Add attributes to mimic haven-style labelling
  attr(test_df$q1, "label") <- "Numeric question"
  attr(test_df$q2, "label") <- "Text question"
  
  # Add value labels
  val_labels <- c("One" = 1, "Two" = 2, "Three" = 3)
  attr(test_df$q1, "labels") <- val_labels
  
  # Create codebook
  codebook <- create_codebook(test_df, format = "data.frame")
  
  # Tests
  expect_equal(nrow(codebook), 3)
  expect_equal(ncol(codebook), 3)
  expect_equal(codebook$variable, c("q1", "q2", "q3"))
  expect_equal(codebook$question, c("Numeric question", "Text question", NA))
  
  # Test function validates inputs
  expect_error(create_codebook("not a data.frame"), "Input must be a data.frame")
  expect_error(create_codebook(test_df, format = "invalid"), "Invalid format")
})

test_that("export_codebook validates inputs", {
  test_df <- data.frame(var = 1:3)
  codebook <- create_codebook(test_df)
  
  expect_error(export_codebook("not a data.frame", "file.csv"), "Codebook must be a data.frame")
  expect_error(export_codebook(codebook, 123), "File path must be provided")
  expect_error(export_codebook(codebook, "file.txt"), "Unsupported file extension")
})