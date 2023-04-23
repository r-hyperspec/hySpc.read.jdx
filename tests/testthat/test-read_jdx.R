# File created by roxut; edit the function definition file, not this file

# test found in read_jdx.R:35 (file:line)


sbo <- system.file("extdata", "SBO.jdx", package = "readJDX")

test_that("SBO.jdx (IR spectrum) can be imported", {
  expect_silent(spc <- read_jdx(sbo))
})

test_that("SBO.jdx (IR spectrum) dimensions are correct", {
  spc <- read_jdx(sbo)
  expect_equal(nwl(spc), 1868L)
  expect_equal(nrow(spc), 1L)
  expect_equal(ncol(spc), 2L)
})

test_that("SBO.jdx (IR spectrum) labels are correct", {
  spc <- read_jdx(sbo)
  expect_equal(spc@label$.wavelength, expression("1/CM"))
  expect_equal(spc@label$spc, expression("TRANSMITTANCE"))
  expect_equal(spc@label$filename, "filename")
})

pcrf <- system.file("extdata", "PCRF.jdx", package = "readJDX")

test_that("PCRF.jdx (real & imaginary 1H NMR spectrum) can be imported", {
  expect_silent(spc <- read_jdx(pcrf))
})

test_that("PCRF.jdx (real & imaginary 1H NMR spectrum) dimensions are correct", {
  spc <- read_jdx(pcrf)
  expect_equal(nwl(spc), 7014L)
  expect_equal(nrow(spc), 2L)
  expect_equal(ncol(spc), 2L)
})

test_that("PCRF.jdx (real & imaginary 1H NMR spectrum) labels are correct", {
  spc <- read_jdx(pcrf)
  expect_equal(spc@label$.wavelength, expression())
  expect_equal(spc@label$spc, expression())
  expect_equal(spc@label$filename, "filename")
})

# next test is for a corrupted file, which on readJDX throws an error

pcrf_265 <- system.file("extdata", "PCRF_line265.jdx", package = "readJDX")

test_that("Error is thrown when corrupt file is imported", {
  expect_output(
    expect_error(spc <- read_jdx(pcrf_265)),
    "Attempting to sum DIFs"
  )
})

# next test is a 2D NMR file which readJDX imports fine, but
# length(list_jdx) != 4 or 5, which is error condition for read_jdx
# readJDX will issue a warning first, and then read_jdx throws an error

isasspc1 <- system.file("extdata", "isasspc1.dx", package = "readJDX")

test_that("Error is thrown when 2D NMR file is imported", {
  expect_warning(
    expect_error(spc <- read_jdx(isasspc1)),
    "Looks like 2D NMR but could not identify vendor"
  )
})
