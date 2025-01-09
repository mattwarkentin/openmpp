local_install_openmpp <- function() {
  latest <- gh::gh("https://api.github.com/repos/openmpp/main/releases/latest")
  info <- Sys.info()
  os <- info['sysname']
  type <- info['machine']

  url <- find_latest_binary(latest$assets, os, type)

  file <- basename(url)

  dir <- tempdir()

  path <- paste0(dir, '/', file)
  withr::defer(unlink(path))

  download.file(url, path, quiet = TRUE)

  if (os == 'Windows') {
    unzip(path, exdir = dir)
    new_path <- dirname(path)
  } else {
    untar(path, exdir = dir)
    new_path <- tools::file_path_sans_ext(path, compression = TRUE)
  }

  new_path
}

find_latest_binary <- function(assets, os, type) {
  asset_names <- purrr::map_chr(assets, \(x) x$name)

  if (os == 'Darwin' & type == 'arm64') {
    idx <- which(grepl('openmpp_mac_arm64_\\d{8}.tar.gz', asset_names))
    url <- assets[[idx]]$browser_download_url
  } else if (os == 'Darwin' & type == 'x86_64') {
    idx <- which(grepl('openmpp_mac_x86_64_\\d{8}.tar.gz', asset_names))
    url <- assets[[idx]]$browser_download_url
  } else if (os == 'Linux') {
    idx <- which(grepl('openmpp_debian-11_\\d{8}.tar.gz', asset_names))
    url <- assets[[idx]]$browser_download_url
  } else if (os == 'Windows') {
    idx <- which(grepl('openmpp_win_\\d{8}.zip', asset_names))
    url <- assets[[idx]]$browser_download_url
  } else {
    rlang::abort('No compatible OS detected.')
  }

  url
}

oms_path <- local_install_openmpp()
