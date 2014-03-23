library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)


load("../dados/Merged.rda")


# numero de vitimas feridas por dia, por tipo_vitima (CD, PS, PD, OU, SI)
dadosFeridas <- aggregate(merged$classificacao,by=list(merged$diasem,merged$dia,merged$tipo_vitima),function(x) sum(x=="F",na.rm=TRUE))

# numero de vitimas mortas por dia, por tipo_vitima (CD, PS, PD, OU, SI)
dadosMortas <- aggregate(merged$classificacao,by=list(merged$diasem,merged$dia,merged$tipo_vitima),function(x) sum(x=="M",na.rm=TRUE))

# numero de vitimas feridas ou mortas por dia, por tipo_vitima (CD, PS, PD, OU, SI)
dadosFM <- dadosMortas[,1:3]
dadosFM$x <- dadosFeridas$x+dadosMortas$x

    
shinyServer(function(input, output) {

    # seleciona a classificacao da vitima baseado no input do usuario
    datasetInput <- reactive({
        switch(input$dataset,
               "Feridas" = dadosFeridas,
               "Fatais" = dadosMortas,
               "Feridas ou Fatais"=dadosFM)
    })

    varInput <- reactive({
        switch(input$tipo,
               "Condutor"=c("CD"),
               "Pedestre"=c("PD"),
               "Passageiro"=c("PS"),
               "Sem Informação"=c("SI"),
               "Todos"=c("CD","PD","PS","SI")
        )
    })
     
   
    output$countPlot <- renderPlot({

        dataN <- datasetInput()
        var1 <- varInput()

        if (sum(var1==c("CD","PD","PS","SI"))==4) {

            tmp <- aggregate(dataN[,4], by=list(dataN[,1],dataN[,2]), function(x) sum(x))
            dataN <- data.frame(tmp[,1], tmp[,2], "Todos", tmp[,3])

        } else {

            dataN <- dataN[dataN[,3]%in% var1,]
        }

        # gráfico com número total de vitimas por dia
        gg <- ggplot(data=dataN, group=dataN[,4], environment=environment())
        gg <- gg + geom_path(aes(x=dataN[,2], y=dataN[,4]), size=0.5)
        gg <- gg + geom_point(aes(x=dataN[,2], y=dataN[,4], color=dataN[,1]), stat="identity", size=2)
        gg <- gg + scale_y_continuous(limits=c(0, max(dataN[,4])),
                                      labels=comma)
        gg <- gg + labs(x="", y="# vítimas", title="Total de Vítimas (por dia)", color="Dia da Semana")
        gg <- gg + theme_bw()
    
        # boxplots mostrando a distribuição do total de vítimas por dia, separadamente para cada dia da semana
        gg2 <- ggplot(data=dataN, aes(dataN[,1], dataN[,4]), environment=environment())
        gg2 <- gg2 + geom_boxplot(aes(fill=dataN[,1]))
        gg2 <- gg2 + scale_y_continuous(limits=c(0, max(dataN[,4])),
                                        labels=comma)
        gg2 <- gg2 + labs(x="", y="# vítimas/dia",
                          title="Distribuição do Total de Vítimas (por dia), para cada dia da Semana",
                          color="Dia da Semana")
        gg2 <- gg2 + theme_bw()
        gg2 <- gg2 + theme(legend.position="none")

        print(grid.arrange(gg, gg2, ncol=1))
    })
   
    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        dataN <- datasetInput()
        var1 <- varInput()

        dataN <- dataN[dataN[,3]==var1,]
        colnames(dataN) <- c("Dia da Semana", "Dia", "Tipo de Vitima", "Total de Vítimas")
        return(dataN)
    })

    output$Teste <- renderPrint({

        # Teste Kruskal-Wallis para testar se medianas do total de vítimas por dia são iguais para cada dia da semana
        # p-value <0.05 indica que há diferença estatística entre os dias de semana
        dataN <- datasetInput()
        var1 <- varInput()
        dataN <- dataN[dataN[,3]==var1,]
        print(kruskal.test(dataN[,3]~dataN[,1]))
    })
})
