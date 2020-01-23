
fluidPage(
  tags$head(includeCSS("www/style.css"), 
            includeScript("www/moveSnake.js")), 
  
  useShinyjs(), 
  useShinyalert(), 
  navbarPage("SssNAKE", 
             tabPanel("Play", 
                      tags$div(id = "everything", 
                        tags$div(id = "punctation", "Score: 0"), 
                        tags$div(id = "field", 
                                 style = sprintf("width: %spx; height: %spx;", 
                                                 pointWidth * (width + 0.5), pointWidth * (height+ 0.5)), 
                                 createField(n = height, m = width, pointWidth = pointWidth)), 
                        tags$div(id = "control", 
                                 actionBttn(inputId = "start_stop", label = "start", 
                                            style = "minimal", color = "primary"
                                 ), 
                                 actionBttn(inputId = "reset", label = "reset", 
                                            style = "minimal", color = "primary"
                                 ), 
                                 sliderTextInput(inputId = "level", label = NULL, 
                                                 grid = TRUE, force_edges = TRUE, 
                                                 choices = names(level), width = '150px'
                                 )
                        )
                      )
             )
  ) 
)