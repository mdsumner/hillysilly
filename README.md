
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hillysilly

<!-- badges: start -->
<!-- badges: end -->

The goal of hillysilly is to …

## Installation

You can install the development version of hillysilly like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## TODO

-   remove raster (but update anglr too)
-   cleanup messy code
-   cleanup bad use of rgl window control
-   fix spacing/offset when different tile dimensions or width/height
    are used!
-   provide colour control
-   expand on tile logic (and the matrix of inputs possible)
-   allow other input data, other raster sources
-   etc

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(hillysilly)
## basic example code
hillysilly(c("Auckland", "Murray Hill",  "Zurich", "Oxford"))
```

![alt text](man/figures/snapshot3d_01.png "Four cities")

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
