library(shiny)
require(rCharts)


shinyUI(pageWithSidebar(

    headerPanel("rCharts with Leaflet"),

    # Sidebar w/ slider
    sidebarPanel(
        selectInput("city", "Escolha uma cidade:",
                    choices=c("Campinas", "São Paulo"))
    ),

    mainPanel(
        mapOutput("myMap")
    )
))
