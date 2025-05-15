# ces: Canadian Election Study Data Package

This R package provides easy access to Canadian Election Study (CES) datasets for analysis in R.

## Installation

You can install the released version of ces from CRAN with:

```r
install.packages("ces")
```

And the development version from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("laurenceomfoisy/ces")
```

## Example

```r
library(ces)

# Get the 2019 CES data (metadata is preserved by default)
ces_2019 <- get_ces("2019")

# If you need to disable metadata preservation (uncommon)
# ces_2019_minimal <- get_ces("2019", preserve_metadata = FALSE)

# View available datasets
list_ces_datasets()

# Create a codebook for the dataset
codebook <- create_codebook(ces_2019)

# Examine variable metadata
metadata <- examine_metadata(ces_2019, variable_pattern = "vote")

# Get subset of variables about voting behavior
voting_data <- get_ces_subset("2019", variables = c("vote_choice", "turnout"))
```

## Features

- Easy access to CES datasets from various years (1965-2021)
- Consistent data format across years
- Simple filtering and subsetting functions
- Automatic generation of variable codebooks
- Complete preservation of variable metadata (labels, value labels)
- Metadata examination tools
- Export capabilities for sharing dataset documentation

## License

This project is licensed under the MIT License - see the LICENSE file for details.
