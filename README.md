# mandelExplorer

R package allowing some exploration of the Mandelbrot fractal set using
1. A Shiny app for exploring the Mandelbrot set interactively (function `mandel()`)
2. A function to create particular views at given resolution (function `zoom()`)
3. A function to create animated real-time zooms to a given location (function `mandelbrot()`)

The actual [`Mandelbrot set`] (https://en.wikipedia.org/wiki/Mandelbrot_set) is calculated using optimized Rcpp code that uses OpenMP multithreading and SIMD vectorized operations. The animated real-time zooms make use of the nativeRaster format of the R package [`nara`] (https://github.com/coolbutuseless/nara) to achieve decent framerates.


## Installation

To run within an R session :

```r
install.packages("remotes")
library(remotes)
remotes::install_github("tomwenseleers/mandelExplorer")
library(mandelExplorer)
```

To start interactive Shiny-powered Mandelbrot explorer:
```r
mandel()
```

For particular view at given resolution:
```r
mandelbrot(xlims=c(-0.74877,-0.74872),
           ylims=c(0.065053,0.065103), 
           res=1920L,
           pal=2)
```

For a real-time animated zoom to a particular region (using fast nativeRaster graphics) [as it's Christmas a Merry Christmas png is shown at the end & a Feliz Navidad song is played, you can disable these by setting �png=NA� and �wav=NA�]:

```r
zoom(xlims=c(-0.766032578179731,-0.766032578179529), 
     ylims=c(0.10086220543088,0.10086220543102), 
    pal=1, # palette: 1 to 4
    gamma=1/8,
    res=640L)
```


## Screenshots

### v1.1

Interactive Shiny Mandelbrot Explorer app (function `mandel()`) :

![Mandelbrot Shiny app](./inst/png/shiny_app.png?raw=true) 

Real-time zooms using fast nativeRaster graphics (click to watch video) (function `zoom()`) :

[![Fast real-time zooms](./inst/png/feliz_navidad.png?raw=true)](https://vimeo.com/783419550 "Fast real-time zooms - click to watch!")

Fixed view at given magnification, location & resolution (here call `mandelbrot(xlims=c(-0.74877,-0.74872),ylims=c(0.065053,0.065103), res=1920L, pal=2)`) :

![Mandelbrot](./inst/png/mandelbrot.png?raw=true)


## Bugs

* Zooming is eventually limited by numerical accuracy, so only relatively shallow zooms are supported at the moment.
