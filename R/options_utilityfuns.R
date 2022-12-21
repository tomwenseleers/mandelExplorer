## DEFINE SOME OPTIONS

# screen aspect ratio & initial X & Y limits
aspect_ratio = as.double(13/9) # first had 16/9 but take into account window on the right that needs space too
xlims <- c(-2.0, 2.0)*aspect_ratio
ylims <- c(-2.0, 2.0)
oldxlims <- c(0,0)

# pre-generated palettes
mandelbrot_palette=function(palette, fold = TRUE,
                            reps = 1L, in_set = "black") {
  
  if (!fold %in% c(TRUE, FALSE)) {
    stop("Fold must be TRUE or FALSE")
  }
  
  if (length(palette) < 1000) {
    palette <- grDevices::colorRampPalette(palette)(1000)
  }
  
  if (fold) {
    palette <- c(palette, rev(palette))
  }
  
  c(rep(palette, reps), in_set)
}

rainbow=c(rgb(0.47,0.11,0.53),rgb(0.27,0.18,0.73),rgb(0.25,0.39,0.81),rgb(0.30,0.57,0.75),rgb(0.39,0.67,0.60),rgb(0.51,0.73,0.44),rgb(0.67,0.74,0.32),rgb(0.81,0.71,0.26),rgb(0.89,0.60,0.22),rgb(0.89,0.39,0.18),rgb(0.86,0.13,0.13))

palettes <- list( 
  Lava = c(
    grey.colors(1000, start = .3, end = 1),
    colorRampPalette(RColorBrewer::brewer.pal(9, "YlOrRd"), bias=1)(1000), 
    "black"),
  Heat =  mandelbrot_palette(rev(RColorBrewer::brewer.pal(11, "RdYlBu"))),
  Rainbow = c(colorRampPalette(rainbow)(1000),rev(colorRampPalette(rainbow)(1000)),"black"),
  Spectral = mandelbrot_palette(RColorBrewer::brewer.pal(11, "Spectral"))
)


## COUPLE OF UTILITY FUNCTIONS

# auto setting for nr of iterations
nrofiterations = function (xlims) min(round(500+log10(((4/abs(diff(xlims)))))^5),1E4) # attempt at setting sensible nr of iterations based on zoom level

# scale vector between 0 and 1
range01 <- function(x){(x - min(x)) / (max(x) - min(x))}

# function to equalize vector y
.equalize = function(y, rng= c(0, 0.90), levels = 256, breaks) {
  h = tabulate(findInterval(y, vec=breaks)) 
  cdf = cumsum(h)
  cdf_min = min(cdf[cdf>0])
  
  equalized = ( (cdf - cdf_min) / (prod(dim(y)) - cdf_min) * (rng[2L] - rng[1L]) ) + rng[1L]
  bins = round( (y - rng[1L]) / (rng[2L] - rng[1L]) * (levels-1L) ) + 1L
  
  return(equalized[bins])
}

# function to equalize matrix m
equalize <- function(m, rng = c(0, 0.90), levels = 256){
  if (!is.null(dim(m))) { ordims = dim(m); m = as.vector(m) } else { ordims = NULL }
  m = range01(m)*rng[[2L]]
  r = range(m)
  if ( r[1L] != r[2L] ) {
    levels = as.integer(levels)
    breaks = seq(rng[1L], rng[2L], length.out = levels + 1L)
    m = .equalize(m, rng, levels, breaks) 
    m = range01(m)*rng[[2L]]
    if (!is.null(ordims)) dim(m) = ordims
  }
  return(m)
}

# function to equalize all values that are not in the M-set - works but a bit slow
equalizeman <- function(m, nb_iter, rng = c(0, 0.90), levels = 256) {
  if (!is.null(dim(m))) { ordims = dim(m); m = as.vector(m) } else { ordims = NULL }
  inmandel = (m==nb_iter)
  m[!inmandel] = equalize(m[!inmandel], rng, levels)
  m[inmandel] = 1
  if (!is.null(ordims)) dim(m) = ordims
  return(m)
}

# estimate adaptive gamma value so that median of 0-1 scaled intensity values becomes = intens - fast but doesn't always work
adgamma = function (m, nb_iter, subsamp=10, intens=0.4) { 
  subs_rows=seq(1,nrow(m),length.out=round(nrow(m)/subsamp))
  subs_cols=seq(1,ncol(m),length.out=round(nrow(m)/subsamp))
  subsm=as.vector(m[subs_rows,subs_cols])
  subsm=subsm/nb_iter
  subsm_notinM=subsm[subsm!=1]
  #hist(subsm_notinM)
  adgamma = -log(1/intens)/log(median(subsm_notinM)) # ensures that median of 0-1 scaled values will become = intens
  return(adgamma)
}

# function to convert matrix to colour raster
mat2rast = function(mat, col) {
  idx = findInterval(mat, seq(0, 1, length.out = length(col)))
  colors = col[idx]
  rastmat = t(matrix(colors, ncol = ncol(mat), nrow = nrow(mat), byrow = TRUE))
  class(rastmat) = "raster"
  return(rastmat)
}
