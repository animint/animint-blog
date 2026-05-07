pkgs <- c("animint2")
ins.mat <- installed.packages()
missing.pkgs <- setdiff(pkgs, rownames(ins.mat))
install.packages(missing.pkgs)
remotes::install_github("animint/animint2", dep=TRUE)
unlink(c("_freeze","_site"), recursive = TRUE)
out <- capture.output(te <- try(quarto::quarto_render()))
print(te)
cat(out, sep="\n")
if(is(te, "try-error"))stop("error in quarto_render")
## copy data viz to site.
gvec <- file.path("posts/*/*/animint.js")
for(glob in gvec){
  animint_js_vec <- Sys.glob(glob)
  from_dir_vec <- dirname(animint_js_vec)
  to_dir_vec <- dirname(file.path("_site",from_dir_vec))
  from_to_list <- split(from_dir_vec, to_dir_vec)
  for(to_dir in names(from_to_list)){
    from_dir <- from_to_list[[to_dir]]
    print(to_dir)
    file.copy(from_dir, to_dir, recursive=TRUE)
    ##file.rename does not work for directories on windows.
    unlink(from_dir, recursive = TRUE)
  }
}
## preview site.
if(interactive())servr::httd("_site")
