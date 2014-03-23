library(shiny)
library(rCharts)
library(scales)


load("../dados/Merged.rda")


merged$escolaridade.y <- factor(merged$escolaridade.y,
                                labels=c("Analfabeto",
                                         "Primeiro Grau Incompleto",
                                         "Primeiro Grau Completo",
                                         "Segundo Grau Incompleto",
                                         "Segundo Grau Completo",
                                         "Superior Incompleto",
                                         "Superior Completo",
                                         "Sem Informações"))



merged$escolaridade.x <- factor(merged$escolaridade.x,
                                labels=c("Analfabeto",
                                         "Primeiro Grau Incompleto",
                                         "Primeiro Grau Completo",
                                         "Segundo Grau Incompleto",
                                         "Segundo Grau Completo",
                                         "Superior Incompleto",
                                         "Superior Completo",
                                         "Sem Informações"))



    
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
               "Condutor"="x",
               "Vítima"="y")
    })

    estInput <- reactive({
        switch(input$estat,
               "Frequência"=1,
               "Proporção"=0)
    })

    output$countPlot <- renderChart({

        var1 <- datasetInput()
        var2 <- varInput()
        var3 <- estInput()

        escol <- paste0("escolaridade.",var2)

        dataN<-table(merged$diasem[merged$classificacao %in% var1],
                     merged[merged$classificacao %in% var1,escol])

        if (var3==1)
            {
                tab <- as.data.frame(dataN)
            }
        else
            {
                tab <-  as.data.frame(prop.table(dataN,1))
            }
            
        n2 <- nPlot(Freq ~ Var1, group='Var2', data=tab,
                    type='multiBarChart', dom='countPlot', width=700)
        n2$chart(stacked=TRUE)

        return(n2)
    })

    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        var1 <- datasetInput()
        var2 <- varInput()
        var3 <- estInput()

        escol <- paste0("escolaridade.",var2)

        dataN<-table(merged$diasem[merged$classificacao %in% var1],
                     merged[merged$classificacao %in% var1,escol])

        if (var3==1)
            {
                tab <- as.data.frame(dataN)
                colnames(tab) <- c("Dia da Semana","Escolaridade","Frequência")

            }
        else
            {
                tab <-  as.data.frame(prop.table(dataN,1))
                colnames(tab) <- c("Dia da Semana","Escolaridade","Proporção")

            }

        return(tab)
    })

   
})
