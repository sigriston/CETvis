library(shiny)


shinyUI(

    pageWithSidebar(

        headerPanel("Manutenção de equipamentos de sinalização de trânsito"),

        sidebarPanel(
            selectInput("dataset", "Variável",
                        choices = c( "Prioridade",
               "Família da falha",
               "Causa da Falha")),
            HTML("<label><a href='http://sigriston.github.io/CETvis/'>Voltar para página inicial.</a></label>")
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Vis",plotOutput("countPlot")),
                tabPanel("Data",dataTableOutput("guardianTable"))
            )
        )
    )
)
