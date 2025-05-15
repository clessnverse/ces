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
devtools::install_github("username/ces")
```

## Example

```r
library(ces)

# Get the 2019 CES data
ces_2019 <- get_ces("2019")

# View available datasets
list_ces_datasets()
```

## Features

- Easy access to CES datasets from various years
- Consistent data format across years
- Simple filtering and subsetting functions
- Documentation of variables and codebooks

## License

This project is licensed under the MIT License - see the LICENSE file for details.
