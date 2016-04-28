library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input,output,session){
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  output$text1 <- renderText({ 
    paste("You have selected", input$radio)
  })
  #reactive(input$bins,{updateNumericInput(session,"fogCov",value=input$bins)})
})