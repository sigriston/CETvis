library(shiny)
require(rCharts)


shinyUI(pageWithSidebar(

    headerPanel("rCharts: Interactive Charts from R using nvd3.js"),

    sidebarPanel(
    ),
    mainPanel(
        showOutput("myChart", "nvd3")
    )
))
