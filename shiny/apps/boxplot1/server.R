library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)


load("../dados/Acidentes00.rda")

# total de vitimas feridas por data, coluna dia da semana incluída
dadosFeridas <- aggregate(acidentes$vit_ferida,by=list(acidentes$diasem,acidentes$dia),function(x) sum(x))

# total de vitimas mortas por data, coluna dia da semana incluída
dadosMortas <- aggregate(acidentes$vit_morta,by=list(acidentes$diasem,acidentes$dia),function(x) sum(x))

# total de vitimas feridas ou mortas por data, coluna dia da semana incluída
FM <- acidentes$vit_morta+acidentes$vit_ferida
dadosFM <- aggregate(FM,by=list(acidentes$diasem,acidentes$dia),function(x) sum(x))


shinyServer(function(input, output) {

    # seleciona conjunto de dados baseado no input do usuario
    datasetInput <- reactive({
        switch(input$dataset,
               "Feridas" = dadosFeridas,
               "Fatais" = dadosMortas,
               "Feridas ou Fatais"=dadosFM)
    })

    output$countPlot <- renderPlot({

        dataN <- datasetInput()

        # gráfico com número total de vítmas por dia
        gg <- ggplot(data=dataN, group=dataN[,3], environment=environment())
        gg <- gg + geom_path(aes(x=dataN[,2], y=dataN[,3]), size=0.5)
        gg <- gg + geom_point(aes(x=dataN[,2], y=dataN[,3], color=dataN[,1]), stat="identity", size=2)
        gg <- gg + scale_y_continuous(limits=c(0, max(dataN[,3])),
                                      labels=comma)
        gg <- gg + labs(x="", y="# vítimas", title="Total de Vítimas (por dia)", color="Dia da Semana")
        gg <- gg + theme_bw()

        # boxplots mostrando a distribuição do total de vítimas por dia, separadamente para cada dia da semana
        gg2 <- ggplot(data=dataN, aes(dataN[,1], dataN[,3]), environment=environment())
        gg2 <- gg2 + geom_boxplot(aes(fill=dataN[,1]))
        gg2 <- gg2 + scale_y_continuous(limits=c(0, max(dataN[,3])),
                                        labels=comma)
        gg2 <- gg2 + labs(x="", y="# vítimas/dia", title="Distribuição do Total de Vítimas (por dia), para cada dia  da Semana",color="Dia da Semana")
        gg2 <- gg2 + theme_bw()
        gg2 <- gg2 + theme(legend.position="none")

        print(grid.arrange(gg, gg2, ncol=1))
    })

    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        dataN <- datasetInput()
        colnames(dataN) <- c("Dia da Semana", "Dia", "Total de Vítimas")
        return(dataN)
    })

    output$Teste <- renderPrint({

        # Teste Kruskal-Wallis para testar se medianas do total de vítimas por dia são iguais para cada dia da semana
        # p-value <0.05 indica que há diferença estatística entre os dias de semana
        dataN <- datasetInput()
        print(kruskal.test(dataN[,3]~dataN[,1]))
    })
})
