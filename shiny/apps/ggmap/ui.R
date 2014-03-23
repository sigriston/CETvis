library(shiny)

# UI definition
shinyUI(pageWithSidebar(

    # App title
    headerPanel("Hello ggmap!"),

    # Sidebar w/ slider
    sidebarPanel(
        selectInput("city", "Escolha uma cidade:",
                    choices=c("Campinas", "São Paulo"))
    ),

    mainPanel(
        plotOutput("mapPlot", width="100%")
    )
))
