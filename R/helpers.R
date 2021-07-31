
#' Extract value from string of JDX metadata
#'
#' Extract a value from string of JDX metadata when a key is given.
#'
#' @param metadata (character): Vector of strings with meadata.
#' @param key (character): Key to extract.
#'
#' @return (character): value corresponding to the key.
#'
#' @noRd
#'
#' @examples
#' jdx_extract_value("##TIME=10:16:17", key = "TIME")
#'
#'
#' metadata <-
#'   c("##TITLE=Smart Balance Original Spread", "##JCAMP-DX=5.01  $$ Nicolet v. 1",
#'     "##DATATYPE=INFRARED SPECTRUM", "##ORIGIN=Lab", "##OWNER= Public Domain",
#'     "##LONGDATE=2016/11/22", "##TIME=10:16:17", "##DATA PROCESSING=",
#'     "Ratio against background", "Truncated", "ElementMultiply or ElementDivide",
#'     "##XUNITS=1/CM", "##YUNITS=TRANSMITTANCE", "##FIRSTX=399.212341",
#'     "##LASTX=3999.837646", "##FIRSTY=0.944539", "##MAXX=3999.837646",
#'     "##MINX=399.212341", "##MAXY=1.059585", "##MINY=0.523075", "##XFACTOR=1.000000",
#'     "##YFACTOR=1.000000E-008", "##NPOINTS=1868", "##DELTAX=1.928562"
#'   )
#' jdx_extract_value(metadata, key = "XUNITS")
#'
#' jdx_extract_value(metadata, key = c("XUNITS", "YUNITS"))
#'
#'
#' file <- system.file("extdata", "SBO.jdx", package = "readJDX")
#' list_jdx <- readJDX::readJDX(file)
#' jdx_extract_value(list_jdx$metadata, key = "TITLE")
#'

jdx_extract_value <- function(metadata, key) {
  one_of_keys <- paste(key, collapse = "|")
  key_pattern <- paste0("##\\$?(", one_of_keys, ")=\\s*")
  rows_with_key <- grepl(key_pattern, metadata)
  value <- trimws(sub("^.*=", "", metadata[rows_with_key]))
  names(value) <- key
  value
}
