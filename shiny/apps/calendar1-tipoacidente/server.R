library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)


source("functions/calendarHeat2.R")

load("dados/Merged.rda")





shinyServer(function(input, output) {

    # seleciona a classificacao da vitima baseado no input do usuario
     datasetInput <- reactive({
        switch(input$dataset,
               "Feridas" = c("F"),
               "Fatais" = c("M"),
               "Feridas ou Fatais"=c("M","F"))
    })


    varInput <- reactive({
        switch(input$tipo,
               "Colisão"=c("CO"),
               "Colisão frontal"=c("CF"),
               "Colisão traseira"=c("CT"),
               "Colisão lateral"=c("CL"),
               "Colisão transversal"=c("CV"),
               "Capotamento"=c("CP"),
               "Tombamento"=c("TB"),
               "Atropelamento"=c("AT"),
               "Atropelamento animal"=c("AA"),
               "Choque"=c("CH"),
               "Queda moto/bicicleta"=c("QM"),
               "Queda veículo"=c("QV"),
               "Queda ocupante dentro"=c("QD"),
               "Queda ocupante fora"=c("QF"),
               "Outros"=c("OU"),
               "Sem informações"=c("SI"))              
    })


    

  
    output$countPlot <- renderPlot({

        var0 <- datasetInput()
        var1 <- varInput()


        # numero de vitimas feridas por dia, por tipo de acidente
        dataN <- aggregate(merged$classificacao,
                                  by=list(merged$diasem,merged$dia,merged[,"tipo_acidente"]),
                                  function(x) sum(x %in% var0,na.rm=TRUE))


      
        dataN <- dataN[dataN[,3]%in% var1,]
        

        calendarHeat2(dataN[,2], dataN[,4], ncolors = 99, color = "r2gback",
                      varname = "Total de Vítimas", date.form = "%Y-%m-%d")
    })

    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
       var0 <- datasetInput()
        var1 <- varInput()


        # numero de vitimas feridas por dia, por tipo de acidente
        dataN <- aggregate(merged$classificacao,
                                  by=list(merged$diasem,merged$dia,merged[,"tipo_acidente"]),
                                  function(x) sum(x %in% var0,na.rm=TRUE))


      
        dataN <- dataN[dataN[,3]%in% var1,]
        
      
        colnames(dataN) <- c("Dia da Semana", "Dia", "Tipo de acidente", "Total de Vítimas")
        return(dataN)
    })
})
