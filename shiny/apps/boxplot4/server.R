library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)


load("dados/Merged.rda")



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

    output$countPlot <- renderPlot({

        var1 <- datasetInput()
        var2 <- varInput()

        escol <- paste0("escolaridade.",var2)

        dataN <- aggregate(merged$classificacao,
                          by=list(merged$diasem,merged$dia,merged[,escol]),
                          function(x) sum(x %in% var1,na.rm=TRUE))

    
        # boxplots mostrando a distribuição do total de vítimas por dia, separadamente para cada dia da semana
        gg2 <- ggplot(data=dataN, aes(dataN[,1], dataN[,4]), environment=environment())
        gg2 <- gg2 + geom_boxplot(aes(fill=dataN[,3]))
        gg2 <- gg2+scale_fill_discrete(name="Escolaridade")
        gg2 <- gg2 + scale_y_continuous(limits=c(0, max(dataN[,4])),
                                        labels=comma)
        gg2 <- gg2 + labs(x="", y="# vítimas/dia", title=" ")
        gg2 <- gg2 + theme_bw()

        print(grid.arrange(gg2, ncol=1))
    })
  
    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        var1 <- datasetInput()
        var2 <- varInput()

        escol <- paste0("escolaridade.",var2)

        dataN <- aggregate(merged$classificacao,
                          by=list(merged$diasem,merged$dia,merged[,escol]),
                          function(x) sum(x %in% var1,na.rm=TRUE))


        colnames(dataN) <- c("Dia da Semana", "Dia", "Escolaridade", "Total de Vítimas")
        
        return(dataN)
    })

 
})
