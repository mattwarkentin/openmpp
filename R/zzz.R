# zzz.R
.onLoad <- function(libname, pkgname) {
  assign('OpenMpp', new.env(), rlang::env_parent())
  assign('API', OpenMppConnection$new(), OpenMpp)
}
