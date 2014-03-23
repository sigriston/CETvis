library(shiny)

# UI definition
shinyUI(pageWithSidebar(

    # App title
    headerPanel("Hello Shiny!"),

    # Sidebar w/ slider
    sidebarPanel(
        sliderInput("obs",
                    "Number of observations:",
                    min = 1,
                    max = 2000,
                    value = 500)
    ),

    mainPanel(
        plotOutput("distPlot")
    )
))
