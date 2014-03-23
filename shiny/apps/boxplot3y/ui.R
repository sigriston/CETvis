library(shiny)


shinyUI(

    pageWithSidebar(

        headerPanel("Vítimas por dia - 2011, 2012, 2013-1S"),

        sidebarPanel(
            selectInput("dataset", "Classificação de vítima:",
                        choices = c("Feridas", "Fatais", "Feridas ou Fatais")),
            selectInput("vitcond","Escolaridade:",
                        choices=c("da vítima","do condutor")),
            selectInput("tipo", "Nível de Escolaridade:",
                        choices = c( "Todas","Analfabeto", "Primeiro Grau Incompleto", "Primeiro Grau Completo",
                            "Segundo Grau Incompleto", "Segundo Grau Completo", "Superior Incompleto",
                            "Superior Completo", "Sem informações")),
            selectInput("ano","Ano:",
                        choices=c("2011","2012","2013")),
            selectInput("semestre","Semestre:",
                        choices=c("Primeiro","Segundo","Ambos")),
            HTML("<label><a href='../../'>Voltar para página inicial.</a></label>")
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Vis", plotOutput("countPlot",height="1200px")),
                tabPanel("Data", dataTableOutput("guardianTable")),
                tabPanel("Teste Kruskal-Walis", verbatimTextOutput("Teste"))
            )
        )
    )
)
