#'
#' Import JCAMP-DX Files to hyperSpec
#'
#' Import JCAMP-DX files to hyperSpec objects.  Uses the `readJDX` function in package `readJDX`.
#' See the vignettes there for much more information.
#'
#' @param file Character. The file name to import. See "file" argument in [readJDX::readJDX()].
#'
#' @param SOFC Logical. "Stop on Failed Check". See "SOFC" argument in [readJDX::readJDX()].
#'
#' @param debug Integer. The level of debug reporting desired. See "debug" argument in [readJDX::readJDX()].
#'
#' @return A list, as follows:
#' \itemize{
#'  \item The first element is the file metadata
#'  \item The second element is a hyperSpec object
#' }
#'
#' @author Sang Truong
#' Maintainer: Sang Truong <sttruong@stanford.edu>
#'
#' @export
#' @concept io
#'
#' @importFrom methods new
#' @import hyperSpec
#' @import hySpc.testthat
#' @import readJDX
#' @importFrom dplyr bind_rows
#' @importFrom utils maintainer packageDescription
#'
#' @examples
#'
#' sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")
#' spc <- read_jdx(sbo)[[2]] # grab the data
#' plot(spc)
#' head(sbo[[1]], n = 40) # metadata is available too

read_jdx <- function(file = stop("filename is needed"), SOFC = TRUE, debug = 0) {

  list_jdx <- readJDX(file = file, SOFC = SOFC, debug = debug)

  if (length(list_jdx) == 4) {
    # Case 1: A single spectrum (IR, Raman, UV, processed/real 1D NMR, etc)
    spc <- new("hyperSpec", spc = list_jdx[[4]][["y"]], wavelength = list_jdx[[4]][["x"]])
    spc@data$filename <- file
    spc@label$filename <- file
    return(list(metadata = list_jdx[[2]], hyperSpec = spc))
  }
  # not sure this next option will be of great interest to most hyperSpec users
  else if (length(list_jdx) == 5) {
    # Case 2: Includes spectrum and the real and imaginary parts of 1D NMR spectrum
    temp_spc <- bind_rows(list(list_jdx[[4]], list_jdx[[5]]))
    spc <- new("hyperSpec", spc = temp_spc[["y"]], wavelength = temp_spc[["x"]])
    spc@data$filename <- file
    spc@label$filename <- file
    return(list(metadata = list_jdx[[2]], hyperSpec = spc))
  }
  else {
    stop(
      "read_jdx() so far can only return a list of 4 or 5 elements from readJDX::readJDX.",
      " Please file an enhancement request at", packageDescription("hyperSpc.read.jdx")$BugReports,
      " with your file as an example or contact the maintainer (",
      maintainer("hySpc.read.jdx"), ")."
    )
  }
}

hySpc.testthat::test(read_jdx) <- function() {
  context("read_jdx")
  sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")
  pcrf <- system.file("extdata", "PCRF.jdx", package = "readJDX")
  isasspc <- system.file("extdata", "isasspc1.dx", package = "readJDX")

  test_that("JCAMP-DX file can be imported", {
    expect_silent(spc <- read_jdx(sbo)[[2]])
    expect_equal(dim(spc), c(nrow = 1L, ncol = length(colnames(spc)), nwl = 1868L))
  })

  test_that("readJDX::readJDX only return a list of 4 or 5 elements", {
    expect_equal(length(readJDX(sbo)), 4)

    expect_equal(length(readJDX(pcrf)), 5)

    expect_error(hyperSpc.read.jdx::read_jdx(isasspc))

    expect_warning(readJDX(isasspc))
  })
}
