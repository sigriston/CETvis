library(shiny)


shinyUI(

    pageWithSidebar(
       

        headerPanel("Ocorrências por idade - 2011, 2012, 2013-1S"),

        sidebarPanel(
            selectInput("tipo","Idade",
                        choices=c("Condutor","Vítima","Vítima e Condutor")),
            selectInput("estat","Idade Min/Max/Med das vítimas da ocorrência",
                        choices=c("max","min","media")),
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
