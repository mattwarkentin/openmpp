local_install_openmpp <- function() {
  url <- 'https://github.com/openmpp/main/releases/latest/download/openmpp_mac_arm64_20241226.tar.gz'
  file <- basename(url)
  dir <- tempdir()
  path <- paste0(dir, '/', file)
  download.file(url, path, quiet = TRUE)
  untar(path, exdir = dir)
  unlink(path)
  new_path <- tools::file_path_sans_ext(path, compression = TRUE)
  new_path
}

oms_path <- local_install_openmpp()
