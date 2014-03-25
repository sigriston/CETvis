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
               "Analfabeto"=c(1),
               "Primeiro Grau Incompleto"=c(2),
               "Primeiro Grau Completo"=c(3),
               "Segundo Grau Incompleto"=c(4),
               "Segundo Grau Completo"=c(5),
               "Superior Incompleto"=c(6),
               "Superior Completo"=c(7),
               "Sem informações"=c(8),
               "Todas"=c(1:8))
    })

     vitcondInput <- reactive({
        switch(input$vitcond,
               "da vítima"="x",
               "do condutor"="y")
    })

    

  
    output$countPlot <- renderPlot({

        var0 <- datasetInput()
        var1 <- varInput()
        var5 <- vitcondInput()

        escol=paste0("escolaridade.",var5)

        # numero de vitimas feridas por dia, por escolaridade (1 a 8)
        dataN <- aggregate(merged$classificacao,
                                  by=list(merged$diasem,merged$dia,merged[,escol]),
                                  function(x) sum(x %in% var0,na.rm=TRUE))


        if (sum(var1==c(1:8))==8) {

            tmp <- aggregate(dataN[,4],by=list(dataN[,1],dataN[,2]),function(x) sum(x))
            dataN <- data.frame(tmp[,1],tmp[,2],"Todas",tmp[,3])

        } else {

            dataN <- dataN[dataN[,3]%in% var1,]
        }

        calendarHeat2(dataN[,2], dataN[,4], ncolors = 99, color = "r2gback",
                      varname = "Total de Vítimas", date.form = "%Y-%m-%d")
    })

    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        var0 <- datasetInput()
        var1 <- varInput()
        var5 <- vitcondInput()

        escol=paste0("escolaridade.",var5)

        # numero de vitimas feridas por dia, por escolaridade (1 a 8)
        dataN <- aggregate(merged$classificacao,
                                  by=list(merged$diasem,merged$dia,merged[,escol]),
                                  function(x) sum(x %in% var0,na.rm=TRUE))


        if (sum(var1==c(1:8))==8) {

            tmp <- aggregate(dataN[,4],by=list(dataN[,1],dataN[,2]),function(x) sum(x))
            dataN <- data.frame(tmp[,1],tmp[,2],"Todas",tmp[,3])

        } else {

            dataN <- dataN[dataN[,3]%in% var1,]
        }
      
        colnames(dataN) <- c("Dia da Semana", "Dia", "Escolaridade", "Total de Vítimas")
        return(dataN)
    })
})
