library(shiny)
require(rCharts)


shinyUI(pageWithSidebar(

    headerPanel("rCharts with Leaflet"),

    # Sidebar w/ slider
    sidebarPanel(
        numericInput("timeFrom", "Horário inicial:", 8),
        numericInput("timeTo", "Horário final:", 9)
    ),

    mainPanel(
        mapOutput("myMap")
    )
))
