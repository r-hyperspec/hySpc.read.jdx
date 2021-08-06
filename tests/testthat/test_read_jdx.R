# File created by roxut; edit the function definition file, not this file
 

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
