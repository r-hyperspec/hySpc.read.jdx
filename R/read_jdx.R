#' @title JCAMP-DX Import for Shimadzu Library Spectra.
#'
#' @description
#' This is a first rough import function for JCAMP-DX spectra.
#'
#'
#' @note JCAMP-DX support is incomplete and the functions may change without notice. See
#'
#' @param file Character.  The file name to import.
#'
#' @param SOFC Logical.  "Stop on Failed Check"
#' @param debug Integer.  The level of debug reporting desired.  For those options giving
#'        a lot of output, you may wish to consider directing the output via \code{\link{sinkall}}
#'        and then search the results for the problematic lines.
#' If files contain multiple spectra, 1D NMR spectrum, or non-NMR spectrum, return a list of hyperSpec objects
#' Else return a hyperSpec object only
#' @return a hyperSpec object or list of hyperSpec objects
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
    return(spc)
  }
  else if (length(list_jdx) == 5) {
    # Case 2: Includes spectrum and the real and imaginary parts of 1D NMR spectrum
    temp_spc <- bind_rows(list(list_jdx[[4]], list_jdx[[5]]))
    spc <- new("hyperSpec", spc = temp_spc[['y']], wavelength = temp_spc[['x']])
    spc@data$filename <- file
    spc@label$filename <- file
    return(spc)
  }
  else if (length(list_jdx) == 6){
    # Case 3: Includes spectrum, the real and imaginary parts of 1D NMR spectrum, and one non-NMR spectrum
    spc1 <- new("hyperSpec", spc = list_jdx[[4]], wavelength = list_jdx[[4]])
    spc1@data$filename <- file
    spc1@label$filename <- file

    spc2 <- new("hyperSpec", spc = list_jdx[[5]], wavelength = list_jdx[[5]])
    spc2@data$filename <- file
    spc2@label$filename <- file

    spc3 <- new("hyperSpec", spc = list_jdx[[6]])
    spc3@data$filename <- file
    spc3@label$filename <- file

    return(list(spc1, spc2, spc3))
  }
}
