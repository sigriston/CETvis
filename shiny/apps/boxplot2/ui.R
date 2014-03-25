library(shiny)


shinyUI(

    pageWithSidebar(

        headerPanel("Vítimas por dia - 2011, 2012 e 2013-1S"),

        sidebarPanel(
            selectInput("dataset", "Classificação de vítima:",
                        choices = c("Feridas", "Fatais","Feridas ou Fatais")),
            selectInput("tipo", "Tipo de vítima:",
                        choices = c("Todos","Condutor", "Passageiro","Pedestre","Sem Informação")),
            HTML("<label><a href='http://sigriston.github.io/CETvis/'>Voltar para página inicial.</a></label>")
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
