# mandelExplorer

R package allowing some exploration of the Mandelbrot fractal set using

1.  A Shiny app for exploring the Mandelbrot set interactively (function `mandel()`)

2.  A function to create particular views at given resolution (function `mandelbrot()`)

3.  A function to create animated real-time zooms to a given location (function `zoom()`)

4.  A function to create animated Christmas cards, zooming in to one of 96 pre-set locations, playing an accompanying Christmas song (function `xmascard(i)` with `i` between 1 and 96) and saving each as a Christmas card to be printed if desired

5.  A function to play all 96 animated Christmas cards in a row in random order, accompanied by selected gems like Feliz Navidad by Jose Feliciano, All I Want for Christmas Is You by Mariah Carey or We Wish You a Merry Christmas by The Chipmunks or The Smurfs (function `jukebox()`). Yes, Belgium doesn't have many famous people, but the little blue guys are among them, in case you didn't know!

## Installation

To run within an R session :

```{r}
install.packages("remotes")
library(remotes)
remotes::install_github("tomwenseleers/mandelExplorer", upgrade="never")
library(mandelExplorer)
```

To start interactive Shiny-powered Mandelbrot explorer:

```{r}
mandel()
```

![](inst/png/shiny_app.png)

For particular view at given resolution:

```{r}
mandelbrot(xlims=c(-0.74877,-0.74872),
           ylims=c(0.065053,0.065103), 
           res=1920L,
           pal=2)
```

![](inst/png/mandelbrot.png)

For a real-time animated zoom to a particular region (using fast `nativeRaster` graphics)

```{r}
zoom(xlims=c(-0.766032578179731,-0.766032578179529),     
     ylims=c(0.10086220543088,0.10086220543102),      
     pal=1, # palette: 1 to 10     
     gamma=1/8, # gamma value - choose value between ca. 1/20 and 1.5    
     res=640L)
```

Real-time animated zoom to one of 73 pre-defined locations `p`, using the Lava palette nr. 1 (click to view video):

```{r}
for (p in 1:73) { print(p);zoom(xlims=x[[p]], ylims=y[[p]], pal=1) }
```

[![Fast real-time zooms](./inst/png/preset1.png?raw=true)](https://vimeo.com/783419550)

Animated Christmas card showing a real-time Mandelbrot fractal zoom to one of 96 pre-set locations (`p` = number between 1 and 96) & show "Merry Christmas" at the end, whilst playing a fitting Christmas song; the Christmas card is also exported as a PNG image, so you can print it as a Christmas card if desired :

`p=8; xmascard(p)`

![](inst/png/preset8.png)

Play all 96 pre-set Christmas cards in a row in random order using :

`jukebox()`

The first 16 presets look like in the image below :

![](inst/png/xmascard_presets.png)

Presets 17 to 32 use a more psychedelic rainbow palette (`pal=3`) and a higher `gamma` value of `1.5`, and are accompanied by a randomly selected Christmas song (`wav='random'`) :

![](inst/png/xmascard_presets_17_to_32.png)

Presets 33 to 64 use the reddish Lava palette (`pal=1`) and a `gamma` value of `0.1`, and are accompanied by a randomly selected Christmas song (`wav='random'`) :

![](inst/png/xmascard_presets_33_to_64.png)

Finally, presets 65 to 96 use the blueish Heat palette (`pal=2`) and a `gamma` value of `0.1`, and are accompanied by a randomly selected Christmas song (`wav='random'`) :

![](inst/png/xmascard_presets_65_to_96.png)

You can modify the song played with each Christmas card using argument `wav`, which allows you to choose one of 13 provided songs `i`, or point to the `wav` file of your choice (`wav='random'` selects a random song and `wav=""` leaves out the song) :

`p=1; i=1; xmascard(p, wav=songs[[i]])`

The available songs are `i=`

1 = Feliz Navidad - Jose Feliciano\
2 = We Wish You A Merry Christmas - The Chipmunks\
3 = We Wish You A Merry Christmas - Smurfs\
4 = We Wish You a Merry Christmas - Sesame Street\
5 = Jingle Bells - Winnie the Pooh\
6 = Jingle Bells (techno version)\
7 = All I Want for Christmas for Is You - Mariah Carey\
8 = Do They Know It's Christmas - Band Aid\
9 = Happy Christmas (The War is Over) - John Lennon\
10 = Last Christmas - Wham\
11 = Auld Lang Syne - Scottish bagpipes\
12 = Here Comes Santa Claus - Elvis\
13 = Rockin Around the Christmas Tree - Brenda Lee

Press escape and type `close(s)` to stop the music. Analogously, you can use argument `png` to point to your custom `png` file with the Christmas or New Year's message of your choice, change `pal` to the colour palette of your liking (choice from `1` to `10`, sometimes the `gamma` parameter also needs some tweaking - use values between `1/20` and `2`), you can change `res` to change the resolution (e.g. `500L` or `1000L`) and you can change `xlims` and `ylims` (each vectors of 2 numbers) to specify the location you would like to zoom in to. The WAV files are reproduced from <https://www.thewavsite.com/> under the noncommercial use clause of the [Digital Millennium Copyright Act of 1998](http://www.copyright.gov/legislation/dmca.pdf)]. If any artist believes their work has been included in error and would like to see it removed, I will do so upon request.

## Technical details

The actual [Mandelbrot set](https://en.wikipedia.org/wiki/Mandelbrot_set "Mandelbrot set") is calculated using optimized Rcpp code that uses [OpenMP multithreading and SIMD vectorized operations](https://stackoverflow.com/questions/48069990/multithreaded-simd-vectorized-mandelbrot-in-r-using-rcpp-openmp) (SIMD optimizations were provided by [Z boson](https://stackoverflow.com/users/2542702/z-boson)). In addition, if option `gpu=TRUE` is used and if you have an NVIDIA graphics card and if have the [NVIDIA CUDA toolkit](https://developer.nvidia.com/cuda-downloads) and the [gpuMagic package](https://www.bioconductor.org/packages/release/bioc/html/gpuMagic.html) installed, an OpenCL GPU version can be used at low zooms (except at high resolutions the performance gain is quite marginal though).

The animated real-time zooms make use of the `nativeRaster` format of the R package `nara` (<https://github.com/coolbutuseless/nara>) to achieve decent framerates. Hence, this package forms a good demonstration to illustrate the use of OpenMP in Rcpp and OpenCL GPU code to speed up code and of fast `nativeRaster` graphics to achieve real-time animation at high framerates in R.

Some further speedups could be gained from also coding the colour histogram equalization in Rcpp or OpenCL, and making the Rcpp or OpenCL routines directly return the `nativeRaster` format, but I didn't want to push things too far.

## Bugs

-   Zooming is eventually limited by numerical accuracy, so only relatively shallow zooms are supported at the moment ([deep zooms](https://www.youtube.com/watch?v=pCpLWbHVNhk) would require calculating the Mandelbrot set using perturbation methods, see [article here](http://www.science.eclipse.co.uk/sft_maths.pdf), [post with some corrections of typos in that article here](https://math.stackexchange.com/questions/939270/perturbation-of-mandelbrot-set-fractal) & [article here](https://gbillotey.github.io/Fractalshades-doc/math.html), implemented e.g. in [Fractalshades](https://gbillotey.github.io/Fractalshades-doc/overview.html)).

-   File any major bugs under issues & give your `sessionInfo()` and details on your system. Currenlty, I only tested this package on Windows. I am not 100% sure about performance on Mac or Ubuntu, as the default clang compiler doesn't support OpenMP very well. On Mac, OpenMP can be made to work with [some effort](https://mac.r-project.org/openmp/) though, on [Ubuntu first install OpenMP](https://askubuntu.com/questions/900702/how-to-compiler-openmp-program-using-clang/903982#903982) using

    ```{bash}
    sudo apt install libomp-dev
    ```

    It's possible the `Makevars` file under `/src` still needs to be modified a bit to get best performance on Mac or Linux systems. Feedback on this is welcome!
