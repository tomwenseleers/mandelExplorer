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

# a list of 16 cool x and y pairs
x = list(xlims=c(-0.766032578179731,-0.766032578179529),
         xlims = c(-0.74877, -0.74872),
         xlims = c(0.366371018274633,0.366371033044207),
         xlims=c(0.143556213026305,0.143556215953355),
         xlims=c(-0.483160552536832,-0.483160552536658),
         xlims=c(0.385137743606138,0.385137743766312),
         xlims=c(-0.732579418321346,-0.732579418320854),
         xlims=c(-1.95362863644824,-1.95362859340036),
         xlims=c(-0.980588241840019,-0.980588236678861),
         xlims=c(0.372466075032996,0.372466075034454),
         xlims=c(-0.755530652254736,-0.755530652250714),
         xlims=c(0.412790462348917,0.412790462352773),
         xlims=c(-0.749712051314118,-0.749712051313332),
         xlims=c(-0.456302013521041,-0.456302013520289),
         xlims=c(-0.859250587697113,-0.859250587695727),
         xlims=c(-1.26425834686472,-1.26425832633208))
y = list(ylims=c(0.10086220543088,0.10086220543102),
         ylims = c(0.065053, 0.065103),
         ylims = c(0.59154553072585,0.59154554095094),
         ylims=c(-0.65207264826579,-0.65207264623937),
         ylims=c(0.62553682276813,0.62553682276825),
         ylims=c(-0.60086512632271,-0.60086512621182),
         ylims=c(-0.24114758845057,-0.24114758845023),
         ylims=c(-1.48843098340569e-08,1.49180707293249e-08),
         ylims=c(0.29981877588193,0.29981877945504),
         ylims=c(0.58549696897045,0.58549696897146),
         ylims=c(0.061562474436316,0.0615624744391),
         ylims=c(-0.60805517438862,-0.60805517438595),
         ylims=c(0.089109539985339,0.089109539985883),
         ylims=c(0.58330139353672,0.58330139353724),
         ylims=c(0.23497573912032,0.23497573912128),
         ylims=c(0.044190272396513,0.044190286611419))


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
