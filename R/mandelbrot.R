# interactive shiny-powered Mandelbrot explorer
mandel = function() shiny::runApp(appDir = system.file("application", package = "mandelExplorer"))

# to start interactive Shiny-powered Mandelbrot explorer:
# mandel()

# provide access to mandelRcpp Rcpp Mandelbrot function, pal=palette=1-4
mandelbrot = function(xlims=c(-0.74877,-0.74872), 
                      ylims=c(0.065053,0.065103), 
                      res=1920L, 
                      nb_iter=nrofiterations(xlims), 
                     plotit=TRUE, pal=2, 
                     equalize=TRUE, gamma=1/8) {
    asp <- diff(ylims)/diff(xlims)
    m <- matrix(mandelRcpp2(as.double(xlims[[1]]), as.double(xlims[[2]]), # openmp+SIMD version
                            as.double(ylims[[1]]), as.double(ylims[[2]]), 
                            as.integer(res), 
                            as.integer(res/asp), nb_iter), nrow=as.integer(res))
    # m <- mandelRcpp(as.double(xlims[[1]]), as.double(xlims[[2]]), # openmp version
    #                 as.double(ylims[[1]]), as.double(ylims[[2]]), 
    #                 as.integer(res), 
    #                 as.integer(res/asp), nb_iter)
    if (plotit) {
      if (equalize) m <- equalizeman(m, nb_iter, rng = c(0, 0.95), levels = 1E4) # equalize colours
      par(mar=c(0, 0, 0, 0))
      image(m^gamma, col=palettes[[pal]], asp=asp, axes=F, useRaster=TRUE)
    }
    return(m)
}

# example
# mandelbrot(xlims=c(-0.74877,-0.74872),ylims=c(0.065053,0.065103), pal=2)
# random mandelbrot from 1 of 16 predefined locations with random palette
# r=sample.int(16,1);mandelbrot(xlims=x[[r]], ylims=y[[r]], pal=sample.int(4,1))


# to show animation zooming to particular region
# xlims & ylims = target final region to zoom in on
# pal=palette=1-4
# png & wav: png to show at the end & WAV song to play
zoom = function(xlims=c(-0.766032578179731,-0.766032578179529), 
                ylims=c(0.10086220543088,0.10086220543102), 
                # xlims = c(-0.74877, -0.74872),
                # ylims = c(0.065053, 0.065103),
                # xlims = c(0.366371018274633,0.366371033044207),
                # ylims = c(0.59154553072585,0.59154554095094),
                pal=1, # palette: 1 to 4
                gamma=1/8, # gamma value
                res=640L, # resolution
                png=system.file("png", "merry_xmas.png", package = "mandelExplorer"),
                wav=system.file("audio", "feliz_navidad.wav", package = "mandelExplorer")) {

  pacman::p_load_gh("coolbutuseless/nara") # for fast nativeRaster format
  pacman::p_load_gh("coolbutuseless/audio") # to play sound at the end
  pacman::p_load("grid")
  require(grid)
  
  # Set the target x and y limits, which is the region you want to zoom in on
  target_xlims = xlims
  target_ylims = ylims
  
  # Set the initial x and y limits
  xlims = c(-2, 1)
  ylims = c(-1.5, 1.5)
  
  # Screen aspect ratio (still to implement, now use square window)
  asp = diff(ylims)/diff(xlims)
  
  # Set speed of zoom
  speed = 0.3
  
  # Set the number of steps in the zoom-in animation
  n_steps = 180
  
  # Set the resolution of the plot
  x_res <- y_res <- res
  
  # Setup a fast graphics device that can render quickly
  x11(type = 'dbcairo', antialias = 'none', width = 8, height = 8)
  
  # Loop through the zoom-in animation
  for (i in 1:n_steps) {
    dev.hold()
    
    # Set the maximum number of iterations using some heuristic rule
    nb_iter = nrofiterations(xlims)
    
    # Calculate the new x and y limits for this step
    xlims = xlims + (target_xlims - xlims) * (i / n_steps) * speed
    ylims = ylims + (target_ylims - ylims) * (i / n_steps) * speed
    
    # Calculate the Mandelbrot set for these limits
    m = matrix(mandelRcpp2(xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], 
                           x_res, y_res, 
                           nb_iter), ncol=x_res)
    # m = mandelsmoothRcpp(xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], 
    #                     x_res, x_res, 
    #                     nb_iter) 
    m = equalizeman(m, nb_iter, rng = c(0, 0.95), levels = 1E5) # histogram equalization
    m = m^gamma
    m = mat2rast(m, col=palettes[[pal]]) # convert numeric matrix to raster
    grid::grid.raster(nara::raster_to_nr(m), interpolate = FALSE) # 0.01s, see https://github.com/coolbutuseless/nara/blob/main/vignettes/conversion.Rmd
    dev.flush()
  }
  
  # Calculate the Mandelbrot set for these limits at higher resolution for final frames
  m = matrix(mandelRcpp2(xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], 
                         x_res*2, x_res*2, 
                         nb_iter), ncol=x_res*2)
  # m = mandelsmoothRcpp(xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], 
  #                     x_res*2, x_res*2, 
  #                     nb_iter)
  m = equalizeman(m, nb_iter, rng = c(0, 0.95), levels = 1E5)
  m = m^gamma
  m = mat2rast(m, col=palettes[[pal]])
  grid::grid.raster(nara::raster_to_nr(m), interpolate = FALSE) # 0.01s, see https://github.com/coolbutuseless/nara/blob/main/vignettes/conversion.Rmd
  dev.flush()
  
  # SHOW PNG AT THE END IF DESIRED
  if (!is.na(png)) {
    suppressWarnings(img <- png::readPNG(png))
    grid::grid.raster(img) }
  
  # PLAY FELIZ NAVIDAD
  if (!is.na(wav)) {
    song = audio::load.wave(wav)
    audio::play(song)
  }
}
  
# example
# zoom()
# random zoom to 1 of 16 predefined locations & use given palette
# r=sample.int(16,1);zoom(xlims=x[[r]], ylims=y[[r]], pal=1)
  
  
  
