
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggsegBrainnetome <img src='man/figures/logo.png' align="right" height="138.5" />

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/LCBC-UiO/ggsegBrainnetome/branch/master/graph/badge.svg)](https://codecov.io/gh/LCBC-UiO/ggsegBrainnetome?branch=master)
[![R build
status](https://github.com/LCBC-UiO/ggsegBrainnetome/workflows/R-CMD-check/badge.svg)](https://github.com/LCBC-UiO/ggsegBrainnetome/actions)
[![DOI](https://zenodo.org/badge/250281064.svg)](https://zenodo.org/badge/latestdoi/250281064)
<!-- badges: end -->

This package contains dataset for plotting the Tracula white matter
tracts with ggseg and ggseg3d.

Yendiki et al. (2011) *Automated probabilistic reconstruction of
white-matter pathways in health and disease using an atlas of the
underlying anatomy*. Front. Neuroinform. 5:23. [doi:
10.3389/fninf.2011.00023](https://www.ncbi.nlm.nih.gov/pubmed/22016733)

## Installation

We recommend installing the ggseg-atlases through the ggseg
[r-universe](https://ggseg.r-universe.dev/ui#builds):

``` r
# Enable this universe
options(repos = c(
    ggseg = 'https://ggseg.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

# Install some packages
install.packages('ggsegBrainnetome')
```

You can install the released version of ggsegBrainnetome from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("LCBC-UiO/ggsegBrainnetome")
```

``` r
library(ggseg)
library(ggplot2)
library(ggseg3d)
library(ggsegBrainnetome)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

plot(brainnetome) +
  theme(legend.position = "bottom", 
        legend.text = element_text(size = 9)) +
  guides(fill = guide_legend(ncol = 3))
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
ggseg3d(atlas = brainnetome_3d) %>% 
  add_glassbrain() %>% 
  pan_camera("right lateral")
```

<img src="man/figures/README-3d-plot.png" width="100%" />

Please note that the ‘ggsegBrainnetome’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
