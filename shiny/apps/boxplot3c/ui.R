library(shiny)


shinyUI(

    pageWithSidebar(

        headerPanel("Vítimas por dia - 2011, 2012 e 2013-1S"),

        sidebarPanel(
            selectInput("dataset", "Classificação de vítima:",
                        choices = c("Feridas", "Fatais", "Feridas ou Fatais")),
            selectInput("tipo", "Escolaridade do condutor:",
                        choices = c( "Todas","Analfabeto", "Primeiro Grau Incompleto", "Primeiro Grau Completo",
                                    "Segundo Grau Incompleto", "Segundo Grau Completo", "Superior Incompleto",
                                    "Superior Completo", "Sem informações")),
            HTML("<label><a href='../../'>Voltar para página inicial.</a></label>")
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Vis", plotOutput("countPlot")),
                tabPanel("Data", dataTableOutput("guardianTable")),
                tabPanel("Teste Kruskal-Walis", verbatimTextOutput("Teste"))
            )
        )
    )
)
