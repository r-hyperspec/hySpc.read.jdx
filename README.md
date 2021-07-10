<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version-last-release/hySpc.read.jdx)](https://cran.r-project.org/package=hySpc.read.jdx)
[![R-CMD-check](https://github.com/r-hyperspec/hySpc.read.jdx/workflows/R-CMD-check/badge.svg)](https://github.com/r-hyperspec/hySpc.read.jdx/actions)
![Website (pkgdown)](https://github.com/r-hyperspec/hySpc.read.jdx/workflows/Website%20(pkgdown)/badge.svg)
[![Codecov](https://codecov.io/gh/r-hyperspec/hySpc.read.jdx/branch/develop/graph/badge.svg)](https://codecov.io/gh/r-hyperspec/hySpc.read.jdx?branch=develop)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!--[![metacran downloads](https://cranlogs.r-pkg.org/badges/grand-total/hySpc.read.jdx)](https://cran.r-project.org/package=hySpc.read.jdx)-->
<!--[![metacran downloads](https://cranlogs.r-pkg.org/badges/hySpc.read.jdx)](https://cran.r-project.org/package=hySpc.read.jdx)-->
<!-- badges: end -->



# R Package **hySpc.read.jdx**

[**R**](https://www.r-project.org/) package **hySpc.read.jdx** is a member of the [**`r-hyperspec`**](https://r-hyperspec.github.io/) packages family, which imports
 files in the Joint Committee on Atomic and Molecular Physical Data Data Exchange format (JCAMP-DX). The imported data are returned as hyperSpec objects.  This is a
  wrapper for the readJDX package. 

<!-- ---------------------------------------------------------------------- -->

## Documentation

There are two versions of **hySpc.read.jdx** online documentation:

a. for the [released version](https://r-hyperspec.github.io/hySpc.read.jdx/) of package,  
b. for the [development version](https://r-hyperspec.github.io/hySpc.read.jdx/dev/) of package.

The documentation of the other **`r-hyperspec`** family packages can be found at [r-hyperspec.github.io](https://r-hyperspec.github.io/).

<!-- ---------------------------------------------------------------------- -->

## Installation

### Install from CRAN

You can install the released version of **hySpc.read.jdx** from [CRAN](https://cran.r-project.org/package=hySpc.read.jdx) with:

```r
install.packages("hySpc.read.jdx")
```


### Install from GitHub

You can install the development version of the package from [GitHub](https://github.com/r-hyperspec/hySpc.read.jdx):

```r
if (!require(remotes)) {install.packages("remotes")}
remotes::install_github("r-hyperspec/hySpc.read.jdx")
```

**NOTE 1:**
Usually, "Windows" users need to download, install and properly configure **Rtools** (see [these instructions](https://cran.r-project.org/bin/windows/Rtools/)) to make the code above work.

**NOTE 2:**
This method will **not** install package's documentation (help pages and vignettes) into your computer.
So you can either use the [online documentation](https://r-hyperspec.github.io/) or build the package from source (see the next section).


### Install from Source

1. From the **hySpc.read.jdx**'s GitHub [repository](https://github.com/r-hyperspec/hySpc.read.jdx):
    - If you use Git, `git clone` the branch of interest.
      You may need to fork it before cloning.
    - Or just chose the branch of interest (1 in Figure below), download a ZIP archive with the code (2, 3) and unzip it on your computer.  
![image](https://user-images.githubusercontent.com/12725868/89338263-ffa1dd00-d6a4-11ea-94c2-fa36ee026691.png)

2. Open the downloaded directory in RStudio (preferably, as an RStudio project).
    - The code below works correctly only if your current working directory coincides with the root of the repository, i.e., if it is in the directory that contains file `README.md`.
    - If you open RStudio project correctly (e.g., by clicking `project.Rproj` icon ![image](https://user-images.githubusercontent.com/12725868/89340903-26621280-d6a9-11ea-8299-0ec5e9cf7e3e.png) in the directory), then the working directory is set correctly by default.

3. In RStudio 'Console' window, run the code (provided below) to:
    a. Install packages **remotes** and **devtools**.
    b. Install **hySpc.read.jdx**'s dependencies.
    c. Create **hySpc.read.jdx**'s documentation.
    d. Install package **hySpc.read.jdx**.

```r
# Do not abort installation even if some packages are not available
Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS = "true")

# Install packages remotes and devtools
install.packages(c("remotes", "devtools"))

# Install hySpc.read.jdx's dependencies
remotes::install_deps(dependencies = TRUE)

# Create hySpc.read.jdx's documentation
devtools::document()

# Install package hySpc.read.jdx
devtools::install(build_vignettes = TRUE)
```

**NOTE 1:**
Usually, "Windows" users need to download, install and properly configure **Rtools** (see [these instructions](https://cran.r-project.org/bin/windows/Rtools/)) to make the code above work.
