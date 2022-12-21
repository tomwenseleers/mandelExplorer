
library(shiny)

shinyUI(
  
  fluidPage(
    
    tags$head(
      includeCSS("www/styles.css")
    ),
    
    tags$style(
      type="text/css", ".recalculating { opacity: 1.0; }"
    ),
    
    
    fluidRow(
      column(
        width = 9,
        plotOutput("mandelbrot", height="auto", width = "100%", # height = "1080px", width = "100%",
          brush = brushOpts(id = "zoom_brush", resetOnNew = TRUE, delay = 600)) 
      ),
      
      column(width = 3,
        titlePanel("Mandelbrot Explorer"),
        wellPanel(
          
          p("A Mandelbrot set explorer written in R + Rcpp/OpenMP + shiny. "),
          
          tags$hr(),
          
          tags$label(
            class="control-label",
            "Link:"),
          uiOutput("qurl"),
          tags$br(),
          
          radioButtons("palette",
            "Colours:",
            choices = c("Lava", "Heat", "Rainbow", "Spectral"),
            width = "100%",
            inline = TRUE),
          
          sliderInput("res",
            "X resolution:",
            min = 100,
            max = 4000,
            value = 1200,
            step = 100),
          
          sliderInput("iter",
            "Iterations multiplier:",
            min = 0.25,
            max = 4,
            value = 1,
            step = 0.25),
          
          tags$hr(),
          
          actionButton("reset", "Reset", class="pull-right")
          
        )
      )
    ) # end fluidRow
  )
)
