library(shiny)


shinyUI(

    pageWithSidebar(

        headerPanel("Vítimas por dia - 2011, 2012 e 2013-1S"),

        sidebarPanel(
            selectInput("dataset", "Classificação de vítima:",
                        choices = c("Feridas", "Fatais", "Feridas ou Fatais")),

            selectInput("tipo", "Tipo de acidente:",
                        choices = c("Colisão",
               "Colisão frontal",
               "Colisão traseira",
               "Colisão lateral",
               "Colisão transversal",
               "Capotamento",
               "Tombamento",
               "Atropelamento",
               "Atropelamento animal",
               "Choque",
               "Queda moto/bicicleta",
               "Queda veículo",
               "Queda ocupante dentro",
               "Queda ocupante fora",
               "Outros",
               "Sem informações")),
            HTML("<label><a href='../../'>Voltar para página inicial.</a></label>")
            ),

        mainPanel(
            tabsetPanel(
                tabPanel("Vis",plotOutput("countPlot")),
                tabPanel("Data",dataTableOutput("guardianTable"))
            )
        )
    )
)
