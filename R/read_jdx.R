#'
#' @title Import JCAMP-DX Files to hyperSpec
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
#'
#' @export
#' @concept io
#'
#' @importFrom methods new
#' @import hyperSpec
#' @import hySpc.testthat
#' @import readJDX
#' @importFrom dplyr bind_rows
#'
#' @examples
#'
#' sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")
#' spc <- read_jdx(sbo)[[2]]
#' plot(spc)
#'
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
}

hySpc.testthat::test(read_jdx) <- function() {
  context("read_jdx")
  sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")
  test_that("Can import JCAMP-DX file", {
    expect_silent(spc <- read_jdx(sbo)[[2]])
    expect_equal(dim(spc), c(nrow = 1L, ncol = length(colnames(spc)), nwl = 1868L))
  })
}
