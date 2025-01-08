local_install_openmpp <- function() {
  info <- Sys.info()
  os <- info['sysname']
  type <- info['machine']

  if (os == 'Darwin' & type == 'arm64') {
    url <- 'https://github.com/openmpp/main/releases/latest/download/openmpp_mac_arm64_20241226.tar.gz'
  } else if (os == 'Darwin' & type == 'intel') {
    url <- 'https://github.com/openmpp/main/releases/latest/download/openmpp_mac_x86_64_20241226.tar.gz'
  } else if (os == 'Linux') {
    url <- 'https://github.com/openmpp/main/releases/latest/download/openmpp_debian_20241226.tar.gz'
  } else if (os == 'Windows') {
    url <- 'https://github.com/openmpp/main/releases/latest/download/openmpp_win_20241226.zip'
  } else {
    rlang::abort('No compatible OS detected.')
  }
  file <- basename(url)
  dir <- tempdir()
  path <- paste0(dir, '/', file)
  download.file(url, path, quiet = TRUE)

  if (os == 'Windows') {
    unzip(path, exdir = dir)
  } else {
    untar(path, exdir = dir)
  }

  unlink(path)
  new_path <- tools::file_path_sans_ext(path, compression = TRUE)
  new_path
}

oms_path <- local_install_openmpp()
