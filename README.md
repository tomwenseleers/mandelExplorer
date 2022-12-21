# mandelExplorer

Package allowing some exploration of the Mandelbrot fractal set using
1. A Shiny app for exploring the Mandelbrot set interactively
2. A function to create particular views at given resolution
3. A function to create animated real-time zooms to a given location

The actual Mandelbrot fractal is calculated using optimized Rcpp code that uses OpenMP multithreading and SIMD vectorized operations. The animated real-time zooms make use of the nativeRaster format of the R package [`nara`] (https://github.com/coolbutuseless/nara) to achieve decent framerates.


## Installation

To run within an R session with:

```r
install.packages("remotes")
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

For a real-time animated zoom to a particular region (using fast nativeRaster graphics) [as it's Christmas a Merry Christmas png is shown at the end together with a Feliz Navidad song at the end, you can disable these by setting png=NA and wav=NA]:

```r
zoom(xlims=c(-0.766032578179731,-0.766032578179529), 
     ylims=c(0.10086220543088,0.10086220543102), 
    pal=1, # palette: 1 to 4
    gamma=1/8,
    res=640L)
```


## Screenshots

### v1.1
 


## Bugs

* Zooming is eventually limited by numerical accuracy, so only relatively shallow zooms are supported at the moment.
