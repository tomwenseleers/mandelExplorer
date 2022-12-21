library(shiny)
options(shiny.usecairo=TRUE) # make sure antialiasing is used

shinyServer(function(input, output, session) {

  limits <- reactiveValues(xlim = c(-2.0, 2.0)*aspect_ratio, ylim = c(-2.0, 2.0))
  cols <- reactiveValues(cols = palettes$Lava)

  # parse and set url params
  observe({
    query <- parseQueryString(session$clientData$url_search)

    if ('x' %in% names(query) & 'y' %in% names(query)) {
      limits$xlim <- as.numeric(unlist(strsplit(query$x, ",")))
      limits$ylim <- as.numeric(unlist(strsplit(query$y, ",")))
    }

    if ('pal' %in% names(query)) {
      updateRadioButtons(session, "palette",
        selected = names(palettes)[as.numeric(query$pal)]
      )
    }

    if ('res' %in% names(query)) {
      updateSliderInput(session, "res",
        value = as.numeric(query$res))
    }

    if ('iter' %in% names(query)) {
      updateSliderInput(session, "iter",
        value = as.numeric(query$iter))
    }

  })

  # generate uri with limits and other params
  output$qurl <- renderUI({

    uri <- paste0(
      session$clientData$url_protocol, "//",
      session$clientData$url_hostname,
      session$clientData$url_pathname,
      "?x=",
      paste(limits$xlim, collapse = ","),
      "&y=",
      paste(limits$ylim, collapse = ",")
    )

      uri <- paste0(uri, '&pal=', which(names(palettes) == input$palette))
      uri <- paste0(uri, '&res=', input$res)
      uri <- paste0(uri, '&iter=', input$iter)

    updateQueryString(sub(".*\\?", "?", uri),
      mode = "push",
      session = session)

    tags$a(href = uri,
      "Direct link to this view")

  })

  # main plot view
  output$mandelbrot <- renderPlot({
    
    if (!is.null(limits$xlim)) {
      if ((oldxlims[[1]]!=limits$xlim[[1]])) { # then recalculate
      nb_iter <- as.integer(nrofiterations(limits$xlim)*input$iter) # zoom-adapted nr of iterations
      man <- matrix(mandelRcpp2(as.double(limits$xlim[[1]]), as.double(limits$xlim[[2]]), # openmp+SIMD version
                              as.double(limits$ylim[[1]]), as.double(limits$ylim[[2]]), 
                              as.integer(input$res), 
                              as.integer(input$res/aspect_ratio), nb_iter), nrow=as.integer(input$res))
      gamma <- 1/8 # adgamma(man, nb_iter, subsamp=10, intens=0.25)
      man_norm <- equalizeman(man, as.integer(nrofiterations(limits$xlim)), rng = c(0, 0.90), levels = 1E4) # still a bit slow 
      }
      par(mar=c(0, 0, 0, 0))
      image(x=seq(limits$xlim[[1]], limits$xlim[[2]], length.out=as.integer(input$res)),
             y=seq(limits$ylim[[1]], limits$ylim[[2]], length.out=as.integer(input$res/aspect_ratio)),
              # x=seq(1,nrow(man)),
              # y=seq(1,ncol(man)),
              man_norm^gamma, 
              useRaster=TRUE, axes=FALSE, asp=NA, col=cols$cols, zlim=c(0,1)) # asp=1/aspect_ratio
      # change this to 
      # grid::grid.newpage()
      # grid::pushViewport(grid::viewport(x=0, y=0, 
      #                                  width=1, 
      #                                  height=1, 
      #                                  just=c("left", "bottom")))
      # vp <- grid::viewport(x=0, y=0, 
      #                          width=1, 
      #                          height=1, 
      #                          just=c("left", "bottom"))
      # grid::grid.raster(nara::raster_to_nr(mat2rast(man_norm^gamma, cols$cols)), vp=vp, interpolate = FALSE) 
      
      # oldman <- man
      oldxlims <- limits$xlim
}

  }, height=function() { session$clientData$output_mandelbrot_width / aspect_ratio }) 

  # interactive zoom
  observe({
    brush <- input$zoom_brush

    if (!is.null(brush)) {
      xlims <- c(brush$xmin, brush$xmax) # seq(limits$xlim[[1]], limits$xlim[[2]], length.out=as.integer(input$res))[c(brush$xmin, brush$xmax)]
      ylims <- c(brush$ymin, brush$ymax) # seq(limits$ylim[[1]], limits$ylim[[2]], length.out=as.integer(input$res/aspect_ratio))[c(brush$ymin, brush$ymax)]
      if ((abs(diff(xlims)))<((abs(diff(ylims)))*aspect_ratio)) { xmid = mean(xlims); ymid = mean(ylims); 
                                                                  xlims = c(xmid-(ylims[[2]]-ymid)*aspect_ratio,
                                                                            xmid+(ylims[[2]]-ymid)*aspect_ratio) }
      if ((abs(diff(xlims)))>((abs(diff(ylims)))*aspect_ratio)) { xmid = mean(xlims); ymid = mean(ylims); 
                                                                  ylims = c(ymid-(xlims[[2]]-xmid)/aspect_ratio,
                                                                            ymid+(xlims[[2]]-xmid)/aspect_ratio) }
      limits$xlim <- xlims
      limits$ylim <- ylims
      
    }

  })

  # reset view by action button
  observeEvent(input$reset, {
    updateSliderInput(session, "iter", value = 1)
    # updateRadioButtons(session, "palette", selected="Lava")
    # cols$cols <- palettes$Lava
    xlims <- c(-2.0, 2.0)*aspect_ratio
    ylims <- c(-2.0, 2.0)
    limits$xlim <- xlims
    limits$ylim <- ylims
  })

  # palettes radio select
  observe({
    cols$cols <- palettes[[input$palette]]
  })

})
