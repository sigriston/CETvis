library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)


source("../functions/calendarHeat2.R")

load("../dados/Merged.rda")





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
               "Auto"=c("AU"),
               "Moto"=c("MO"),
               "Ônibus"=c("ON"),
               "Caminhão"=c("CA"),
               "Bicicleta"=c("BI"),
               "Moto Táxi"=c("MT"),
               "Ônibus Fretado/Internmunicipal"=c("OF"),
               "Ônibus Urbano"=c("OU"),
               "Microônibus"=c("MC"),
               "Van"=c("VA"),
               "Vuc"=c("VC"),
               "Caminhonete/Camioneta"=c("CM"),
               "Carreta"=c("CR"),
               "Jipe"=c("JI"),
               "Outros"=c("OT"),
               "Sem informação"=c("SI"),
               "Carroça"=c("CO"))              
    })


    

  
    output$countPlot <- renderPlot({

        var0 <- datasetInput()
        var1 <- varInput()


        # numero de vitimas feridas por dia, por tipo de acidente
        dataN <- aggregate(merged$classificacao,
                                  by=list(merged$diasem,merged$dia,merged[,"tipo_veiculo.x"]),
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
                                  by=list(merged$diasem,merged$dia,merged[,"tipo_veiculo.x"]),
                                  function(x) sum(x %in% var0,na.rm=TRUE))


      
        dataN <- dataN[dataN[,3]%in% var1,]
        
      
        colnames(dataN) <- c("Dia da Semana", "Dia", "Tipo de veículo", "Total de Vítimas")
        return(dataN)
    })
})
