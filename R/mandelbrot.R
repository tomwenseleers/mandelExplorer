# interactive shiny-powered Mandelbrot explorer
mandel = function() shiny::runApp(appDir = system.file("application", package = "mandelExplorer"))

# to start interactive Shiny-powered Mandelbrot explorer:
# mandel()

if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!require("gpuMagic", quietly = TRUE)) BiocManager::install("gpuMagic", update=FALSE)

# OpenCL Mandelbrot code using float #### 
code_float = function() { 
code = "
kernel void mandelbrotOpenCL(global int* res, 
          global double* width, global double* height, 
          global double* fromX, global double* toX, 
          global double* fromY, global double* toY,
          global double* maxiter) {
    int id = get_global_id(0);
    int px = id % ((int) width[0]);
    int py = id / ((int) width[0]);
    int iteration;
    float x0 = fromX[0] + ((double)px) * (toX[0] - fromX[0]) / width[0];
    float y0 = fromY[0] + ((double)py) * (toY[0] - fromY[0]) / height[0];
    float x = 0;
    float y = 0;
    uint maxit = (uint)maxiter[0];
    for (iteration = 0; iteration < maxit; iteration++) {
      float xn = x * x - y * y + x0;
      y = 2 * x * y + y0;
      x = xn;
      if (x * x + y * y > 4.0) {
        break;
      }
    }
    res[(uint)(width[0] *py  + px)] = iteration;
}
";
return(code)
} 


# provide access to mandelRcpp Rcpp Mandelbrot function, pal=palette=1-4
mandelbrot = function(xlims=c(-0.74877,-0.74872), 
                      ylims=c(0.065053,0.065103), 
                      res=1920L, 
                      nb_iter=nrofiterations(xlims), 
                     plotit=TRUE, pal=2, 
                     equalize=TRUE, gamma=1/8,
                     gpu=FALSE) { # use GPU version at low zooms if NVIDIA Cuda Toolkit (ttps://developer.nvidia.com/cuda-downloads) & gpuMagic is installed?
    asp <- diff(ylims)/diff(xlims)
    width <- as.double(res)
    height <- as.double(res/asp)
    maxiter <- as.double(nb_iter)
    
    if (((xlims[2]-xlims[1])>4E-5)&gpu&require("gpuMagic", quietly = TRUE)) { # use GPU version
      setDevice(1)
      res_dev = gpuEmptMatrix(width, height, type='int')
      .kernel(src = code_float(), 
              kernel='mandelbrotOpenCL',
              parms=list(res_dev, width, height, xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], maxiter),
              .globalThreadNum = c(width*height))
      res_dev <- download(res_dev)
      m <- matrix(res_dev, nrow=width)
      # message("Used GPU version")
      } else { # use Rcpp OpenMP+SIMD CPU version
    m <- matrix(mandelRcpp2(as.double(xlims[[1]]), as.double(xlims[[2]]), # openmp+SIMD version
                            as.double(ylims[[1]]), as.double(ylims[[2]]), 
                            as.integer(res), 
                            as.integer(res/asp), nb_iter), nrow=as.integer(res))
    m[m==0] <- nb_iter
    # m <- mandelRcpp(as.double(xlims[[1]]), as.double(xlims[[2]]), # openmp only version
    #                 as.double(ylims[[1]]), as.double(ylims[[2]]), 
    #                 as.integer(res), 
    #                 as.integer(res/asp), nb_iter)
      }
  
    if (plotit) {
      if (equalize) m <- equalizeman(m, nb_iter, rng = c(0, 0.95), levels = 1E4) # equalize colours
      par(mar=c(0, 0, 0, 0))
      image(m^gamma, col=palettes[[pal]], asp=asp, axes=F, useRaster=TRUE)
    }
    # return(m)
}

# example
# mandelbrot(xlims=c(-0.74877,-0.74872),ylims=c(0.065053,0.065103), pal=2, gpu=FALSE) # using Rcpp OpenMP+SIMD CPU version
# mandelbrot(xlims=c(-0.74877,-0.74872),ylims=c(0.065053,0.065103), pal=2, gpu=TRUE) # using GPU version
# random mandelbrot from 1 of 16 predefined locations with random palette
# r=sample.int(16,1);mandelbrot(xlims=x[[r]], ylims=y[[r]], pal=sample.int(4,1))


# to show animation zooming to particular region of Mandelbrot fractal set
# xlims & ylims = target final region to zoom in on
# pal=palette=1-4
zoom = function(xlims=c(-0.766032578179731,-0.766032578179529),  # c(-0.769411694947082,-0.769411694946128),
                ylims=c(0.10086220543088,0.10086220543102),  # c(0.11523600047931,0.11523600047997),  
                pal=1, # palette: 1 to 4
                gamma=1/8, # gamma value
                res=640L, # resolution
                gpu=FALSE # use GPU version at low zooms if NVIDIA Cuda Toolkit (ttps://developer.nvidia.com/cuda-downloads) & gpuMagic is installed?
                ) {
  require(pacman)
  pacman::p_load_gh("coolbutuseless/nara") # for fast nativeRaster format
  pacman::p_load_gh("coolbutuseless/audio") # to play sound at the end
  pacman::p_load("grid")
  require(grid)
  width <- height <- as.double(res)
  if (gpu&!require("gpuMagic", quietly = TRUE)) gpu <- FALSE
  if (gpu) setDevice(1)
  
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
  
  # GPU OpenCL code
  code <- code_float()
  
  # Setup a fast graphics device that can render quickly
  x11(type = 'dbcairo', antialias = 'none', width = 8, height = 8)
  
  # Loop through the zoom-in animation
  for (i in 1:n_steps) {
    dev.hold()
    
    # Set the maximum number of iterations using some heuristic rule
    nb_iter = nrofiterations(xlims)
    maxiter = as.double(nb_iter)
    
    # print(nb_iter)
    
    # Calculate the new x and y limits for this step
    xlims = xlims + (target_xlims - xlims) * (i / n_steps) * speed
    ylims = ylims + (target_ylims - ylims) * (i / n_steps) * speed
    
    # Calculate the Mandelbrot set for these limits
    if (((xlims[2]-xlims[1])>4E-5)&gpu) { # use GPU version at low zoom
      res_dev = gpuEmptMatrix(width, height, type='int')
      .kernel(src = code, 
              kernel='mandelbrotOpenCL',
              parms=list(res_dev, width, height, xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], maxiter),
              .globalThreadNum = c(width*height))
      res_dev <- download(res_dev)
      m <- matrix(res_dev, nrow=width)
      # message("Used GPU version")
    } else { # use Rcpp OpenMP+SIMD CPU version
    m = matrix(mandelRcpp2(xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], 
                           x_res, y_res, 
                           nb_iter), ncol=x_res)
    m[m==0] <- nb_iter
    }
    
    # histogram equalization (could be optimized in Rcpp) & custom gamma
    m = equalizeman(m, nb_iter, rng = c(0, 0.95), levels = 1E5)^gamma 
    grid::grid.raster(mat2natrast(mat=m, col=palettes[[pal]]), interpolate = FALSE) # 0.03s, see https://github.com/coolbutuseless/nara/blob/main/vignettes/conversion.Rmd
    # grid::grid.raster(mat2natrast2(mat=m, col=palettes[[pal]]), interpolate = FALSE) # 0.07s - this was slower
    dev.flush()
  }
  
  # Calculate the Mandelbrot set for these limits at higher resolution for final frames
  highres=4.25*600
  m = matrix(mandelRcpp2(xlims[[1]], xlims[[2]], ylims[[1]], ylims[[2]], 
                         highres, highres, 
                         nb_iter), ncol=highres)
  m = equalizeman(m, nb_iter, rng = c(0, 0.95), levels = 1E5)^gamma
  grid::grid.raster(mat2natrast(mat=m, col=palettes[[pal]]), interpolate = FALSE) # 0.01s, see https://github.com/coolbutuseless/nara/blob/main/vignettes/conversion.Rmd
  dev.flush()
  return(list(xlims=xlims, ylims=ylims))
}
  
# example
# zoom(gpu=FALSE) # using Rcpp OpenMP+SIMD version
# zoom(gpu=TRUE) # using GPU version for low zooms
# zoom to 1 of 73 predefined locations, using 1 of 4 randomly chosen palettes
# for (r in 1:73) { print(r);zoom(xlims=x[[r]], ylims=y[[r]], pal=sample.int(4,1)) }


# function that displays an animated Christmas card consisting of a 
# Mandelbrot zoom to one of 96 predefined locations followed by the
# popping up of a Merry Christmas message with accompanying Christmas song
# n = 1 preset between 1 and 96
# 1 to 7 have a reddish Christmas palette, 8 to 14 have a more icey snowflakey look 
# and 15 and 16 are more colourful psychedelic options
# In addition, there is
# xmascard()s 17-32: 16 colourful presets with pal=3=Rainbow with gamma=1.5 & random songs
# xmascard()s 33-64: 32 reddish presets with pal=1=Lava with gamma=0.1 & random songs
# xmascard()s 65-96: 32 blueish  presets with pal=2=Ice with gamma=0.1 & random songs
# see presets[[n]] to see what presets are
# xlims and ylims = custom x & y ranges to override preset values (NA uses presets)
# pal = if not NA will override preset palette (pal = 1 to 4)
# res = to override default resolution, e.g. 900L (640x640 if NA)
# png = png file to show as message at the end (uses Merry Christmas preset if NA)
# wav = songs[[s]] with s between 1 and 13, to override preset song (uses preset if NA)
# wav = "random" to select random song
# Song selection (WAV files from https://www.thewavsite.com/)
# 1 = Feliz Navidad - Jose Feliciano
# 2 = We Wish You A Merry Christmas - The Chipmunks
# 3 = We Wish You A Merry Christmas - Smurfs
# 4 = We Wish You a Merry Christmas - Sesame Street
# 5 = Jingle Bells - Winnie the Pooh
# 6 = Jingle Bells (techno)
# 7 = All I Want for Christmas for Is You - Mariah Carey
# 8 = Do They Know It's Christmas - Band Aid
# 9 = Happy Christmas (The War is Over) - John Lennon
# 10 = Last Christmas - Wham
# 11 = Auld Lang Syne - Scottish bagpipes
# 12 = Here Comes Santa Claus - Elvis
# 13 = Rockin Around the Christmas Tree - Brenda Lee

xmascard = function (n=1, 
                     xlims=NA, ylims=NA, 
                     pal=NA, gamma=NA, res=NA, png=NA, wav=NA,
                     save=TRUE, # save last frame as PNG "xmascard_n.png" in working directory or desired path?
                     path=getwd(),
                     gpu=FALSE) { # use GPU version at low zooms if NVIDIA Cuda Toolkit (ttps://developer.nvidia.com/cuda-downloads) & gpuMagic is installed?
  require(export)
  require(pacman)
  pacman::p_load_gh("coolbutuseless/nara") # for fast nativeRaster format
  pacman::p_load_gh("coolbutuseless/audio") # to play sound at the end
  pacman::p_load("grid")
  require(grid)
  require(audio)
  if (gpu&!require("gpuMagic", quietly = TRUE)) gpu <- FALSE
  
  if (exists("s")) { if (class(s)=="audioInstance") { close(s) }}
  p = presets[[n]]
  if (!is.na(xlims[[1]])) p$xlims=xlims
  if (!is.na(ylims[[1]])) p$ylims=ylims
  if (!is.na(pal)) p$pal=pal
  if (!is.na(gamma)) p$gamma=gamma
  if (!is.na(res)) p$res=res else p$res=640L
  if (!is.na(png)) p$png=png else p$png=system.file("png", "merry_xmas.png", package = "mandelExplorer")
  if (!is.na(wav)) p$wav=wav
  if (p$wav=="random") { p$wav=songs[[sample.int(length(songs), 1)]] } 
  
  # Do animated Mandelbrot zoom
  zoom(xlims=p$xlims, 
       ylims=p$ylims, 
       pal=p$pal, 
       gamma=p$gamma,
       res=p$res,
       gpu=gpu)
  
  # PLAY SONG
  if (!(is.na(p$wav)|p$wav=="")) {
    song = audio::load.wave(p$wav)
    s <<- audio::play(song)
  }
  
  # SHOW PNG AT THE END
  if (!is.na(p$png)) {
    suppressWarnings(img <- png::readPNG(p$png))
    grid::grid.raster(img)
    dev.flush() }
  
  # EXPORT CHRISTMAS CARD TO FILE
  if (save) { 
    graph2png(file=file.path(path, paste0("xmascard_",n,".png")),
              width=4.25, height=4.25, dpi=600)
  }
  
  if (!(is.na(p$wav)|p$wav=="")) { audio::wait(s) # wait until song is finished
                                   close(s) } else { Sys.sleep(5) }
  # dev.off() # close graphics window
}
  
# examples
# xmascard(1) # with Feliz Navidad by Jose Feliciano at the end
# xmascard(2) # with We Wish You A Merry Christmas by The Chipmunks at the end
# xmascard(3) # romantic option, with All I Want for Christmas for Is You by Mariah Carey at the end
# xmascard(6) # with Last Christmas by Wham at the end
# xmascard(8) # snowflakey option with We Wish You A Merry Christmas by The Chipmunks at the end
# xmascard(8, wav=songs[[7]]) # romantic snowflakey option with All I Want for Christmas for Is You by Mariah Carey at the end
# xmascard(9) # romantic snowy Mandelbrot option with All I Want for Christmas for Is You by Mariah Carey at the end
# xmascard(9, wav=songs[[3]]) # snowy Mandelbrot option with We Wish You A Merry Christmas by The Smurfs at the end (fits with the blue background)
# xmascard(10) # other snowflakey option with Jingle Bells by Winnie the Pooh at the end
# xmascard(11) # other snowflakey option with techno Jingle Bells version at the end
# xmascard(12) # other snowflakey option with Do They Know It's Christmas by Band Aid at the end
# xmascard(13) # other snowflakey option with Feliz Navidad by Jose Feliciano at the end
# xmascard(14) # other snowflakey option with Feliz Navidad by Jose Feliciano at the end
# xmascard(15) # colourful option with Feliz Navidad by Jose Feliciano at the end
# xmascard(16) # colourful "into the wormhole" option with techno version of Jingle Bells at the end
# xmascard()s 17-32: 16 colourful presets with pal=3=Rainbow with gamma=1.5 & random songs
# xmascard()s 33-64: 32 reddish presets with pal=1=Lava with gamma=0.1 & random songs
# xmascard()s 65-96: 32 blueish  presets with pal=2=Ice with gamma=0.1 & random songs

# to stop the music at the end execute close(s)


# function to play all 96 preset Christmas cards in a row in randomly permuted order
jukebox = function(n=1:96, wav=NA, gpu=FALSE) { 
  rand_perm = sample(1:96, 96, replace=F) # random permutation of 96 presets
  p = presets[rand_perm]
  rand_perm_songs = songs[sample(1:13, 13, replace=F)] # random permutation of 13 songs
  wavs = character(length(n))
  if (is.na(wav)) suppressWarnings(wavs[1:length(n)] <- rand_perm_songs) else suppressWarnings(wavs[1:length(n)] <- wav)
  for (i in (1:length(rand_perm))) xmascard(rand_perm[i], wav=wavs[[i]], save=FALSE, gpu=gpu)
}

