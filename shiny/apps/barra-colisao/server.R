library(shiny)
library(rCharts)
library(scales)


load("dados/Merged.rda")


merged$tipo_acidente <- factor(merged$tipo_acidente,levels=c("AA","AT","CF","CH",
                                                          "CL","CO","CP","CT","CV",
                                                          "OU","QD","QF","QM","QV",
                                                          "SI","TB"),
                                labels=c("Atropelamento de animal",
                                    "Atropelamento",
                                    "Colisão frontal",
                                    "Choque",
                                    "Colisão lateral",
                                    "Colisão",
                                    "Capotamento",
                                    "Colisão traseira",
                                    "Colisão transversal",
                                    "Outros",
                                    "Queda ocupante dentro",
                                    "Queda ocupante fora",
                                    "Queda moto/bicicleta",
                                    "Queda veículo",
                                    "Sem informações",
                                    "Tombamento"
                                    ))



merged$sentido <- factor(merged$sentido,levels=c("B","C","I","A","R"),
                                labels=c("Bairro",
                                         "Centro",
                                         "Interlagos",
                                         "Airton Senna",
                                         "Castelo Branco"
                                    ))



    
shinyServer(function(input, output) {

    # seleciona a classificacao da vitima baseado no input do usuario
    datasetInput <- reactive({
        switch(input$dataset,
               "Feridas" = c("F"),
               "Fatais" = c("M"),
               "Feridas ou Fatais"=c("M","F"))
    })


    estInput <- reactive({
        switch(input$estat,
               "Frequência"=1,
               "Proporção"=0)
    })

    output$countPlot <- renderChart({

        var1 <- datasetInput()
        var3 <- estInput()


        dataN<-table(merged$diasem[merged$classificacao %in% var1],
                     merged[merged$classificacao %in% var1,"tipo_acidente"])

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
        var3 <- estInput()


        dataN<-table(merged$diasem[merged$classificacao %in% var1],
                     merged[merged$classificacao %in% var1,"tipo_acidente"])

         if (var3==1)
            {
                tab <- as.data.frame(dataN)
                colnames(tab) <- c("Dia da Semana","Tipo de Acidente","Frequência")

            }

        else
            {
                tab <-  as.data.frame(prop.table(dataN,1))
                colnames(tab) <- c("Dia da Semana","Tipo de Acidente","Proporção")

            }

        return(tab)
    })

   
})
