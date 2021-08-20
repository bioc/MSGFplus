# from http://stackoverflow.com/a/34031214/470769
Sys.which2 <- function(cmd) {
    stopifnot(length(cmd) == 1)
    if (.Platform$OS.type == "windows") {
        path <- Sys.getenv("JAVA_HOME")
        if (path == "" || !dir.exists(path)) {
            suppressWarnings({
                path <- shell(sprintf("where %s 2> NUL", cmd), intern=TRUE)[1]
            })
        }
        if (!is.na(path)) return(stats::setNames(path, cmd))
    }
    Sys.which(cmd)
}

.javaExecutable <- function() Sys.which2("java")



.onLoad <- function(libname, pkgname) {
    javaVersion <- system2(.javaExecutable(), '-version', stderr=TRUE, stdout=TRUE)
    if(length(javaVersion) == 0) {
        warning('Java was not found on your system. Java is required for MS-GF+ to work.')
    } else {
        major <- as.numeric(sub('.*\"(\\d+)\\.\\d+.*', '\\1', javaVersion[1]))
        minor <- as.numeric(sub('.*\"\\d+\\.(\\d+).*', '\\1', javaVersion[1]))
        if((major == 1 && minor < 8) || major < 1) {
            warning('Java need to be at least version 1.7 for MS-GF+ to work. Please upgrade.')
        }
    }
}

.onAttach <- function(libname, pkgname) {
    msg <- sprintf(
        "Package '%s' is deprecated and will be removed from Bioconductor
         version %s", pkgname, "3.15")
    .Deprecated(msg=paste(strwrap(msg, exdent=2), collapse="\n"))
}
