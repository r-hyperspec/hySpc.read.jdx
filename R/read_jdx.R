#'
#' Import JCAMP-DX Files to hyperSpec
#'
#' Import JCAMP-DX files to `hyperSpec` objects.  Uses the `readJDX` function in package `readJDX`.
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
#' @concept io
#'
#' @export
#'
#' @importFrom methods new
#' @import hyperSpec
#' @import hySpc.testthat
#' @import readJDX
#' @importFrom utils packageDescription
#'
#' @examples
#'
#' sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")
#' spc <- read_jdx(sbo)
#' plot(spc[[2]]) # the hyperSpec object is in the 2nd list element
#' head(spc[[1]], n = 40) # metadata is available in the 1st list element
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
  # Not sure this next option will be of great interest to most hyperSpec users, but it works
  else if (length(list_jdx) == 5) {
    # Case 2: Includes spectrum and the real and imaginary parts of 1D NMR spectrum
    temp_spc <- rbind(list_jdx[[4]]$y, list_jdx[[5]]$y)
    spc <- new("hyperSpec", spc = temp_spc, wavelength = list_jdx[[4]]$x)
    spc@data$filename <- file
    spc@label$filename <- file
    return(list(metadata = list_jdx[[2]], hyperSpec = spc))
  }
  else {
    stop(
      "read_jdx() cannot process all types of JCAMP-DX files.",
      "You may wish to look at readJDX::readJDX for more information.",
      "If you have a file you think should work, or wish to suggest an enhancement",
      "Please create an issue at", packageDescription("hyperSpc.read.jdx")$BugReports
    )
  }
}

hySpc.testthat::test(read_jdx) <- function() {
  context("read_jdx")

  # get data files
  sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")
  pcrf <- system.file("extdata", "PCRF.jdx", package = "readJDX")

  test_that("SBO.jdx (IR spectrum) can be imported", {
    expect_silent(spc <- read_jdx(sbo)[[2]])
    expect_equal(dim(spc), c(nrow = 1L, ncol = length(colnames(spc)), nwl = 1868L))
  })

  test_that("PCRF.jdx (real & imaginary 1H NMR spectrum) can be imported", {
    expect_silent(spc <- read_jdx(pcrf)[[2]])
    expect_equal(dim(spc), c(nrow = 2L, ncol = length(colnames(spc)), nwl = 7014L))
  })
}
