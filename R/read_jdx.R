#' @title JCAMP-DX Import for Shimadzu Library Spectra.
#'
#' @description
#' This is a first rough import function for JCAMP-DX spectra.
#'
#'
#' @note JCAMP-DX support is incomplete and the functions may change without notice. See
#' `vignette ("fileio")`  and the details section.
#'
#' @param file Character. The file name to import. See more in "file" argument in readJDX::readJDX [here](https://github.com/bryanhanson/readJDX/blob/master/R/readJDX.R)
#' @param SOFC Logical. Stop on Failed Check. See more in "SOFC" argument in readJDX::readJDX [here](https://github.com/bryanhanson/readJDX/blob/master/R/readJDX.R)
#' @param debug Integer. The level of debug reporting desired. See more in "debug" argument in readJDX::readJDX [here](https://github.com/bryanhanson/readJDX/blob/master/R/readJDX.R)
#'
#' @return A list, as follows:
#' \itemize{
#'  \item The first element is the file meta data
#'  \item The second element is a hyperSpec object
#'}
#' @author C. Beleites with contributions by Bryan Hanson
#'
#' @export
#' @concept io
#'
#' @importFrom utils head modifyList maintainer
#' @importFrom methods new
#' @import hyperSpec
#' @import hySpc.testthat
#' @import readJDX
#' @importFrom dplyr bind_rows

read_jdx <- function(file = stop("filename is needed"), SOFC = TRUE, debug = 0) {
  list_jdx <- readJDX(file = file, SOFC = SOFC, debug=debug)
  if (length(list_jdx) == 4) {
    # Case 1: A single spectrum (IR, Raman, UV, processed/real 1D NMR, etc)
    spc <- new("hyperSpec", spc = list_jdx[[4]][['y']], wavelength=list_jdx[[4]][['x']])
    spc@data$filename <- file
    spc@label$filename <- file
    return(list(metadata = list_jdx[[2]], hyperSpec = spc))
  }
  else if (length(list_jdx) == 5) {
    # Case 2: Includes spectrum and the real and imaginary parts of 1D NMR spectrum
    temp_spc <- bind_rows(list(list_jdx[[4]], list_jdx[[5]]))
    spc <- new("hyperSpec", spc = temp_spc[['y']], wavelength = temp_spc[['x']])
    spc@data$filename <- file
    spc@label$filename <- file
    return(list(metadata = list_jdx[[2]], hyperSpec = spc))
  }
}


file <- paste0(getwd(),"/inst/fileio/jcamp-dx/SBO.JDX")

hySpc.testthat::test(read_jdx) <- function() {
  context("read_jdx")

  # tmpdir <- paste0(tempdir(), "/read_jdx")
  # untar("read_jdx.tar.gz",
  #       files = c("SBO.JDX"),
  #       exdir = tmpdir)
  #
  # on.exit(unlink(tmpdir))


  test_that("JCAMP-DX example file", {
    # spc <- read_jdx(paste0(tmpdir, "/SBO.JDX"))[[2]]
    # spc <- read_jdx("D:/Github/hySpc.read.jdx/inst/fileio/jcamp-dx/SBO.JDX")[[2]]
    # spc <- read_jdx(paste0(tmpdir,"/SBO.JDX"))[[2]]
    spc <- read_jdx(file)[[2]]
    expect_equal(dim(spc), c(nrow = 1L, ncol = length(colnames(spc)), nwl = 1868L))
    expect_equal(round(spc[[1]][[4]],5), 0.95863)
    expect_equal(round(spc[[1]][[6]],5), 0.94606)
    # expect_output(print(paste0(tmpdir,"/SBO.JDX")), "100")
    # expect_output(print(paste0(getwd(),"/inst/fileio/jcamp-dx/SBO.JDX")), "100")

  })
}
