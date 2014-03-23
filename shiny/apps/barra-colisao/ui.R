library(shiny)


shinyUI(

    pageWithSidebar(


        headerPanel("Vítimas por dia - 2011, 2012, 2013-1S"),

        sidebarPanel(
            selectInput("dataset", "Classificação de vítima:",
                        choices = c("Feridas", "Fatais","Feridas ou Fatais")),
            selectInput("estat","Estatística",
                        choices=c("Frequência","Proporção")),
            HTML("<label><a href='../../'>Voltar para página inicial.</a></label>")
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Vis",showOutput("countPlot", "nvd3")),
                tabPanel("Data",dataTableOutput("guardianTable"))
            )
        )
    )
)
