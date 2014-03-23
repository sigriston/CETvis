library(shiny)


shinyUI(

    pageWithSidebar(
       

        headerPanel("Ocorrências por dia - 2011, 2012, 2013-1S"),

        sidebarPanel(
            selectInput("tipo","Tipo de Veículo",
                        choices=c("Todos os tipos de veículos","Automóvel","Moto","Ônibus","Caminhão","Bicicleta",
                            "Moto Táxi","Ônibus Fretado","Ônibus Urbano","Microonibus",
                            "Van","VUC","Caminhonete","Carreta",
                            "Jipe","Outros","Sem Informação")),
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
