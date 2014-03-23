library(shiny)


shinyUI(

    pageWithSidebar(

        headerPanel("Vítimas por dia - 2011, 2012 e 2013-1S"),

        sidebarPanel(
            selectInput("dataset", "Tipo de vítima:",
                        choices = c("Feridas", "Fatais","Feridas ou Fatais"))
            ),


        mainPanel(
            tabsetPanel(
                tabPanel("Vis",plotOutput("countPlot")),
                tabPanel("Data",dataTableOutput("guardianTable")),
                tabPanel("Teste Kruskal-Walis",verbatimTextOutput("Teste"))
            )
        )
    )
)
