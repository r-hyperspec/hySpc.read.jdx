
# Function -------------------------------------------------------------------

#' Import JCAMP-DX files to hyperSpec
#'
#' Import JCAMP-DX files to `hyperSpec` objects.
#' Uses the [readJDX()][readJDX::readJDX()] function in package \pkg{readJDX}.
#' See the vignettes there for much more information:
#' `browseVignettes("readJDX")`.
#'
#' @param file Character. The file name to import.
#'        See "file" argument in [readJDX::readJDX()].
#'
#' @param SOFC Logical. "Stop on Failed Check".
#'        See "SOFC" argument in [readJDX::readJDX()].
#'
#' @param debug Integer. The level of debug reporting desired.
#'        See "debug" argument in [readJDX::readJDX()].
#'
#'
#' @return [hyperSpec][hyperSpec::hyperSpec-class()] object.
#'
#'
#' @author Sang Truong
#'
#' @concept io
#'
#' @export
#'
#' @import hyperSpec
#' @import hySpc.testthat
#' @import readJDX
#' @importFrom methods new
#' @importFrom utils packageDescription
#'
#' @examples
#' file <- system.file("extdata", "SBO.jdx", package = "readJDX")
#' spc <- read_jdx(file)
#' plot(spc)
read_jdx <- function(file = stop("filename is needed"), SOFC = TRUE, debug = 0) {
  list_jdx <- readJDX(file = file, SOFC = SOFC, debug = debug)

  # Extract labels
  x_units <- jdx_extract_value(list_jdx$metadata, key = "XUNITS")
  y_units <- jdx_extract_value(list_jdx$metadata, key = "YUNITS")

  if (length(list_jdx) == 4) {
    # Case 1: A single spectrum (IR, Raman, UV, processed/real 1D NMR, etc)
    spc <- new("hyperSpec",
      spc = list_jdx[[4]][["y"]],
      wavelength = list_jdx[[4]][["x"]],
      labels = list(.wavelength = x_units, spc = y_units)
    )
  }

  # Not sure this next option will be of great interest to most hyperSpec users,
  # but it works
  else if (length(list_jdx) == 5) {
    # Case 2: Includes spectrum and the real and imaginary parts of
    #         1D NMR spectrum
    temp_spc <- rbind(list_jdx[[4]]$y, list_jdx[[5]]$y)
    spc <- new("hyperSpec",
      spc = temp_spc,
      wavelength = list_jdx[[4]]$x,
      labels = list(.wavelength = x_units, spc = y_units)
    )
  } else {
    stop(
      "read_jdx() cannot process all types of JCAMP-DX files.\n",
      "You may wish to look at readJDX::readJDX() for more information. \n",
      "If you have a file you think should work, or wish to suggest an ",
      "enhancement, please, create an issue at\n",
      packageDescription("hySpc.read.jdx")$BugReports
    )
  }

  # Output
  .spc_io_postprocess_optional(spc, filename = file)
}


# Unit tests -----------------------------------------------------------------

hySpc.testthat::test(read_jdx) <- function() {

  # get data files
  sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")
  pcrf <- system.file("extdata", "PCRF.jdx", package = "readJDX")
  pcrf_265 <- system.file("extdata", "PCRF_line265.jdx", package = "readJDX")
  isasspc1 <- system.file("extdata", "isasspc1.dx", package = "readJDX")

  test_that("SBO.jdx (IR spectrum) can be imported", {
    expect_silent(spc <- read_jdx(sbo))
    expect_equal(dim(spc), c(nrow = 1L, ncol = length(colnames(spc)), nwl = 1868L))
  })

  test_that("PCRF.jdx (real & imaginary 1H NMR spectrum) can be imported", {
    expect_silent(spc <- read_jdx(pcrf))
    expect_equal(dim(spc), c(nrow = 2L, ncol = length(colnames(spc)), nwl = 7014L))
  })

  # next test is for a corrupted file, which on readJDX throws an error
  test_that("Error is thrown when corrupt file is imported", {
    expect_output(
      expect_error(spc <- read_jdx(pcrf_265)),
      "Attempting to sum DIFs"
    )
  })

  # next test is a 2D NMR file which readJDX imports fine, but
  # length(list_jdx) != 4 or 5, which is error condition for read_jdx
  test_that("Error is thrown when 2D NMR file is imported", {
    expect_warning(
      expect_error(spc <- read_jdx(isasspc1)),
      "Looks like 2D NMR but could not identify vendor"
    )
  })

  test_that("Labels are correct", {
    expect_silent(spc <- read_jdx(sbo))
    expect_length(labels(spc), 3)
    expect_equal(labels(spc, "filename"), "filename")
    expect_equal(as.character(labels(spc, "spc")), "TRANSMITTANCE") # y units
    expect_equal(as.character(labels(spc, ".wavelength")), "1/CM") # x units
  })
}
