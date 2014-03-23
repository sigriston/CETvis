library(shiny)


shinyUI(

    pageWithSidebar(

        headerPanel("Vítimas por dia - 2011, 2012 e 2013-1S"),

        sidebarPanel(
            selectInput("dataset", "Classificação de vítima:",
                        choices = c("Feridas", "Fatais", "Feridas ou Fatais")),

            selectInput("tipo", "Tipo de veículo:",
                        choices = c("Auto",
                            "Moto",
                            "Ônibus",
                            "Caminhão",
                            "Bicicleta",
                            "Moto Táxi",
                            "Ônibus Fretado/Internmunicipal",
                            "Ônibus Urbano",
                            "Microônibus",
                            "Van",
                            "Vuc",
                            "Caminhonete/Camioneta",
                            "Carreta",
                            "Jipe",
                            "Outros",
                            "Sem Informação",
                            "Carroça"
                            )),
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
