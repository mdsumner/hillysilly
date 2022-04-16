local_extent <- function(x, width = 5000) {
  width <- rep(width, length.out = 2L)
  ## x is c(lon, lat) a 2-element numeric vector
  list(extent = c(-1, 1, -1, 1) * rep(width, each = 2L)/2, projection = sprintf("+proj=laea +lon_0=%f +lat_0=%f", x[1], x[2]))
}

mk_get_locs <- function() {
  fun <- function(x) tidygeocoder::geo(x)
  memoise::memoize(fun)
}
get_locs <- mk_get_locs()

.get_dem <- function(x, width = 5000, dimension = 512,
                    src = "/vsicurl/https://opentopography.s3.sdsc.edu/raster/NASADEM/NASADEM_be.vrt") {
  width <- rep(width, length.out = 2L)
  dimension <- rep(dimension, length.out = 2L)
  ex <- local_extent(x, width = width)
  v <- vapour::vapour_warp_raster_dbl(src, resample  = "bilinear", bands = 1L,
                                      extent = ex$extent, dimension = dimension, projection = ex$projection)
  #  gdalio::gdalio_set_default_grid(list(extent = ex$extent, dimension = dimension, projection = ex$projection))
#  gdalio::gdalio_matrix(src, resample = "bilinear")

  return(matrix(v, dimension[1L])[, dimension[2L]:1L, drop = FALSE])
}

get_dem <- memoise::memoise(.get_dem)

discrete_rainbow <- khroma::colour("discrete rainbow")


#' Plot silly hilly
#'
#' @param x place names, addresses to be geocoded
#' @param dimension size of tiles (number of pixels each side) 1 number (will be repeated) or 2
#' @param width width (and height) of tiles in metres, 1 number (will be repeated) or 2
#' @param ... ignored
#' @param triangles passed to [anglr::as.mesh3d] (means quads are used, a literal quad primitive for every tile pixel)
#' @param alpha value for transparency (0,1) passed to rgl
#'
#' @return nothing, use for side-effect of a 3D plot
#' @export
#' @importFrom raster raster
#' @importFrom rgl clear3d aspect3d plot3d bg3d
#' @importFrom tidygeocoder geo
#' @importFrom anglr as.mesh3d
#' @importFrom khroma colour
#' @importFrom memoise memoize
#' @importFrom vapour vapour_warp_raster_dbl
#' @examples
#' hillysilly(c("Hobart", "Melbourne", "Sydney", "Brisbane", "Darwin", "Perth", "Adelaide", "Canberra"))
hillysilly <- function(x = "Auckland",
                       dimension = 512,
                       width = 5000, ..., triangles = TRUE, alpha = 0.72) {

  locs <- get_locs(x)  ## we could pass this data.frame in, with colours and so forth

  dimension <- rep(dimension, length.out = 2L)
  width <- rep(width, length.out = 2L)
  matrixes <- lapply(split(locs, locs$address)[locs$address], function(x) get_dem(c(x$long[1], x$lat[1], width = width)))

  to_raster_i <- function(i, xmn, ymn) {
    mn <- min(matrixes[[i]])
    out <- to_raster(matrixes[[i]] - mn, xmn, ymn)

    out
  }
  ## tiles for them
  iii <- 0
  jjj <- 0
  to_raster <- function(x, xmn, ymn) {
       raster::raster(x, xmn = xmn, ymn = ymn, xmx = xmn + nrow(x), ymx = ymn + ncol(x))
}
  cols <- discrete_rainbow(nrow(locs))

  rgl::clear3d()
  ## counter for each location
  ii <- 0

  ## what's our tile arrangement (use a matrix for specifiying this)
  ij <- if (is.null(dim(x)))  grDevices::n2mfrow(nrow(locs)) else dim(x)

  max_triangles <- NULL
  if (triangles) max_triangles <- as.integer(prod(dimension)/10)
  for (i in seq_len(ij[1])) {

    for (j in seq_len(ij[2L])) {
      ii <- ii + 1
      if (ii > nrow(locs)) break;

      rgl::plot3d(anglr::as.mesh3d(to_raster_i(ii, iii, jjj), alpha = alpha, triangles = triangles, max_triangles = max_triangles), col = cols[ii], add = TRUE)
      jjj <- jjj + dimension[2L]

    }
    jjj <- 0
    iii <- iii + dimension[1L]


  }
  rgl::aspect3d(1, 1, .4)
  rgl::bg3d("black")

  invisible(NULL)
}
# plot(1:nrow(locs), col = cols, pch = 19, cex = 9, axes = F, xlab = "", ylab = "")
# text(1:nrow(locs), lab = locs$address, cex = 2, pos = 4)

