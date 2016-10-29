library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  title = "Naturale Lingo Processingo",
  dashboardHeader(title = "Sentiment Analysis"),
  dashboardSidebar(sidebarMenu(
    menuItem("Show Text", tabName = "showText", icon = icon("dashboard"))
  )),
  dashboardBody(tabItems(tabItem(
    tabName = "showText",
    fluidRow(column(12,
                    #box(plotOutput("showTextBox")),
                    box(
                      width = "100%",
                      wellPanel(textOutput("bookText"), style = "overflow-y:scroll; max-height: 500px")
                    )
                    #width=100%
                    #box(textOutput("showText"), height=300, width="100%")
                    #includeText("Ben_Franklin_Autobiography_full_noTOC_noIntro.txt")))))
    )))
  )))

  #TODO:
  # Make textbox scrollable - DONE 
  # Increase width of the box - DONE
  # 
  
  
  # Define server logic required to draw a histogram
  server <- shinyServer(function(input, output) {
    output$bookText <- renderText({
      bfaRawText <-
        readLines('Ben_Franklin_Autobiography_full_noTOC_noIntro.txt')
      # The free version t1.micro instance has 1GB RAM limit. To avoid problems with memory
      # allocation when runnign the NLP, we can limit the analysis
      # to first 100 lines.
      bfaRawText100 <- bfaRawText[1:50]
      #bio <- as.String(bfaRawText790)
      #bio <- paste(bio, collapse = " ")
      #return(bio)
    })
    
    output$showTextBox <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = 20 + 1)
      
      # draw the histogram with the specified number of bins
      hist(x,
           breaks = bins,
           col = 'darkgray',
           border = 'white')
    })
  })
  
  # Run the application
  shinyApp(ui = ui, server = server)
  