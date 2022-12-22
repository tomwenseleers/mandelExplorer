# mandelExplorer

R package allowing some exploration of the Mandelbrot fractal set using
1. A Shiny app for exploring the Mandelbrot set interactively (function `mandel()`)
2. A function to create particular views at given resolution (function `zoom()`)
3. A function to create animated real-time zooms to a given location (function `mandelbrot()`)

The actual [Mandelbrot set](https://en.wikipedia.org/wiki/Mandelbrot_set "Mandelbrot set") is calculated using optimized Rcpp code that uses OpenMP multithreading and SIMD vectorized operations (SIMD optimizations provided by (https://stackoverflow.com/users/2542702/z-boson "Z boson")). The animated real-time zooms make use of the nativeRaster format of the R package [`nara`] (https://github.com/coolbutuseless/nara) to achieve decent framerates. So this package forms a good demonstration to illustrate the use of OpenMP in Rcpp to speed up code and of fast nativeRaster graphics to achieve real-time animation at high framerates.


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

For a real-time animated zoom to a particular region (using fast nativeRaster graphics) [as it's Christmas a Merry Christmas png is shown at the end & a Feliz Navidad song is played, you can disable these by setting ´png=NA´ and ´wav=NA´]:

```r
zoom(xlims=c(-0.766032578179731,-0.766032578179529), 
     ylims=c(0.10086220543088,0.10086220543102), 
    pal=1, # palette: 1 to 4
    gamma=1/8,
    res=640L)
```

Real-time animated zoom to one of 16 randomly selected pre-defined locations, using given palette:
```r
r=sample.int(16,1);zoom(xlims=x[[r]], ylims=y[[r]], pal=1);print(r)
```

## Demo

### v1.1

Interactive Shiny Mandelbrot Explorer app :
```r
`mandel()`
```
![Mandelbrot Shiny app](./inst/png/shiny_app.png?raw=true) 


Real-time zooms using fast nativeRaster graphics (click to watch video) :
```r
zoom() # with default options, equivalent to
r=1;zoom(xlims=x[[r]], ylims=y[[r]], pal=1) # change r between 1 and 16 to select one of 16 pre-defined target coordinates and use palette pal with nrs between 1 and 4
# some other examples of zooms to a selection of specific pre-defined targets, with particular palettes & gamma values
r=2;zoom(xlims=x[[r]], ylims=y[[r]], pal=2, gamma=1/15) # mandelbrot with some spirals, with icey palette
r=3;zoom(xlims=x[[r]], ylims=y[[r]], pal=2, gamma=1/15) # snowflakey example
r=4;zoom(xlims=x[[r]], ylims=y[[r]], pal=2, gamma=1/15) # snowflakey example
r=5;zoom(xlims=x[[r]], ylims=y[[r]], pal=2, gamma=1/15) # snowflakey example
r=6;zoom(xlims=x[[r]], ylims=y[[r]], pal=2, gamma=1/15) # snowflakey example
r=7;zoom(xlims=x[[r]], ylims=y[[r]], pal=2, gamma=1/15) # snowflakey example
r=8;zoom(xlims=x[[r]], ylims=y[[r]], pal=3, gamma=0.1) # colourful example
r=9;zoom(xlims=x[[r]], ylims=y[[r]], pal=4, gamma=1/20) # other palette still
r=10;zoom(xlims=x[[r]], ylims=y[[r]], pal=4, gamma=1/20) # other palette still
r=11;zoom(xlims=x[[r]], ylims=y[[r]], pal=4, gamma=1/20) # other palette still
r=12;zoom(xlims=x[[r]], ylims=y[[r]], pal=1, gamma=1/10) # other cool one with reddish Christmas palette
r=12;zoom(xlims=x[[r]], ylims=y[[r]], pal=2, gamma=1/20) # same with snowflakey palette
r=13;zoom(xlims=x[[r]], ylims=y[[r]], pal=3) # reminiscent of spider web or worm hole
r=14;zoom(xlims=x[[r]], ylims=y[[r]], pal=1, gamma=1/20) # other cool one with reddish Christmas palette
r=15;zoom(xlims=x[[r]], ylims=y[[r]], pal=1, gamma=1/20) # other cool one with reddish Christmas palette
r=16;zoom(xlims=x[[r]], ylims=y[[r]], pal=1, gamma=1/20) # other cool one with reddish Christmas palette
```
[![Fast real-time zooms](./inst/png/feliz_navidad.png?raw=true)](https://vimeo.com/783419550 "Fast real-time zooms - click to watch!")


Fixed view at given magnification, location & resolution (here showing specific location & a selection of pre-defined target zooms) :
```r
mandelbrot(xlims=c(-0.74877,-0.74872),ylims=c(0.065053,0.065103), res=1920L, pal=2)
# equivalent to (change r to number between 1 and 16 to get different views and choose palette pal between 1 and 4)
r=2;mandelbrot(xlims=x[[r]],ylims=y[[r]], res=1920L, pal=2)
# with other targets, palette and gamma value
r=2;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=2, gamma=1/15) # mandelbrot with some spirals, with icey palette
r=3;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=2, gamma=1/15) # snowflakey example
r=4;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=2, gamma=1/15) # snowflakey example
r=5;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=2, gamma=1/15) # snowflakey example
r=6;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=2, gamma=1/15) # snowflakey example
r=7;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=2, gamma=1/15) # snowflakey example
r=8;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=3, gamma=0.1) # colourful example
r=9;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=4, gamma=1/20) # other palette still
r=10;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=4, gamma=1/20) # other palette still
r=11;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=4, gamma=1/20) # other palette still
r=12;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=1, gamma=1/10) # other cool one with reddish Christmas palette
r=12;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=2, gamma=1/20) # same with snowflakey palette
r=13;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=3) # reminiscent of spider web or worm hole
r=14;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=1, gamma=1/20) # other cool one with reddish Christmas palette
r=15;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=1, gamma=1/20) # other cool one with reddish Christmas palette
r=16;mandelbrot(xlims=x[[r]], ylims=y[[r]], res=1920L, pal=1, gamma=1/20) # other cool one with reddish Christmas palette
```
![Mandelbrot](./inst/png/mandelbrot.png?raw=true)


## Bugs

* Zooming is eventually limited by numerical accuracy, so only relatively shallow zooms are supported at the moment.
