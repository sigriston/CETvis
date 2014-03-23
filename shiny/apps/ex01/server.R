library(shiny)

# Server logic
shinyServer(function(input, output) {

    # Expression generating plot of the distribution
    output$distPlot <- renderPlot({
        dist <- rnorm(input$obs)
        hist(dist)
    })
})
