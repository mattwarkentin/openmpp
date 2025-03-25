local_install_openmpp <- function() {
  all_releases <- gh::gh("https://api.github.com/repos/openmpp/main/releases")
  all_releases <- all_releases[order(sapply(all_releases, \(x) x$published_at), decreasing = TRUE)]

  info <- Sys.info()
  os <- info['sysname']
  type <- info['machine']

  url <- search_releases(all_releases, os, type)

  if (is.null(url)) {
    rlang::abort('No compatible binary found.')
  }

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

search_releases <- function(releases, os, type) {
  binary <- NULL
  for (release in releases) {
    tryCatch({
      binary <- find_latest_binary(release$assets, os, type)
    },
    error = function(e) {
    })
    if (!is.null(binary)) {
      break
    }
  }
  binary
}

oms_path <- local_install_openmpp()
