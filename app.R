library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  title = "Naturale Lingo Processingo",
  dashboardHeader(title = "Sentiment Analysis"),
  dashboardSidebar(sidebarMenu(
    menuItem("Text Content", tabName = "showText", icon = icon("file-text"))
    #sliderInput("textAmountSlider", label = "Text starting and ending lines (% lines)", min = 0, 
    #            max = 100, value = c(0, 100))
  )),
  dashboardBody(tabItems(tabItem(
    tabName = "showText",
    fluidRow(valueBoxOutput("totalSentencesValueBox"),
             valueBoxOutput("totalWordsValueBox"),
             valueBoxOutput("totalCharactersValueBox")
    ),
    fluidRow(column(8,
                    #box(plotOutput("showTextBox")),
                    box(
                      title="Autobiography of Benjamin Franklin",
                      width = "100%",
                      solidHeader = TRUE, 
                      status="primary",
                      wellPanel(pre(textOutput("bookText"), style = "overflow-y:scroll; max-height: 400px"))
                      )
                    ),
              column(4,
                  box(title="Select text length", 
                      width = "100%",
                      solidHeader = TRUE, 
                      status="primary",
                      #plotOutput("showDummyPlot"), 
                      selectizeInput("selectTextTitle", "Select text to analyze", choices="Autobiography"), 
                      sliderInput("textAmountSlider", label = "Starting and ending line of text (%)", min = 0, 
                                  max = 100, value = c(0, 10)), 
                      submitButton("  Go  ")
                      )
              )
                      #verbatimTextOutput("bookText"), # Wrapper arount textOutput. Same as pre(texttOutput)
                      #tags$head(tags$style("overflow-y:scroll;max-height: 500px"))
    ))
  )))

  #TODO:
  # Make wellPanel scrollable - DONE 
  # Increase width of the box - DONE
  # Format text such that carret returns are properly shown - DONE
  # Make textBox scrollable - DONE. Used wellPanel's style variable
  # 
  # Reactive function to compute number of characters, words, and sentences. \
  #   Should be reactive on text length selectro
  # Add text length selector - DONE
  # Add Text (book) selector, so people can select Ben Franklin or another book to analyse
  # 
  
  
  # Define server logic requimaroon to draw a histogram
  server <- shinyServer(function(input, output) {
    
    ReadTextFile <- function(fileName) {
      rawText <-
        readLines(fileName)
    }
    
    # Compute text elements, such as number of 
    # characters, words, and sentences
    GetTextCounts <- function(text, countWhat=c("characters", "words", "sentences")) {
      
    } 
    
    
    output$bookText <- renderText({
      # Read the book
      theText <- ReadTextFile('Ben_Franklin_Autobiography_full_noTOC_noIntro.txt')
      # The free version t1.micro instance has 1GB RAM limit. To avoid problems with memory
      # allocation when runnign the NLP, we can limit the analysis
      # to first 100 lines.
      bfaRawText100 <- theText
      #bfaRawText100 <- bfaRawText[1:100]
      htmltools:::paste8(bfaRawText100, collapse="\r\n")
      #pre(bfaRawText100)
      #bio <- as.String(bfaRawText790)
      #bio <- paste(bio, collapse = " ")
      #return(bio)
    })
    
    output$totalSentencesValueBox <- renderValueBox({
      valueBox("100", "Number of Sentences", icon=icon("align-justify"), color="light-blue")
    })

    output$totalWordsValueBox <- renderValueBox({
      valueBox("300", "Number of Words", icon=icon("align-center"), color="light-blue")
    })
    
    output$totalCharactersValueBox <- renderValueBox({
      valueBox("500", "Number of Characters", icon=icon("th"), color="light-blue")
    })
    
    output$showDummyPlot <- renderPlot({
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
  