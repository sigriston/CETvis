library(ggplot2)
library(scales)
library(grid)
library(gridExtra)



load("dados/Acidentes00.rda")



    
shinyServer(function(input, output) {

    # seleciona o tipo de veiculo envolvido na ocorrencia
    

    varInput <- reactive({
        switch(input$tipo,
               "Todos os tipos de veículos"="todos",
               "Automóvel"="automovel",
               "Moto"="moto",
               "Ônibus"="onibus",
               "Caminhão"="caminhao",
               "Bicicleta"="bicicleta",
               "Moto Táxi"="moto_taxi",
               "Ônibus Fretado"="onibus_fretado",
               "Ônibus Urbano"="onibus_urbano",
               "Microonibus"="microonibus",
               "Van"="van",
               "VUC"="vuc",
               "Caminhonete"="caminhonete",
               "Carreta"="carreta",
               "Jipe"="jipe",
               "Outros"="outros",
               "Sem Informação"="sem_informacao")

 

    })


    output$countPlot <- renderPlot({

        var1 <- varInput()

          if (var1=="todos")
            {
                dataN <- aggregate(acidentes$id_acidente,
                       by=list(acidentes$diasem,
                           acidentes$dia),length)
            }
        else
            {
                dataN <- aggregate(acidentes$id_acidente[acidentes[,var1]==1],
                       by=list(acidentes$diasem[acidentes[,var1]==1],
                           acidentes$dia[acidentes[,var1]==1]),length)
            }

        

        
        p <- ggplot(dataN, aes(x = dataN[,2], y = dataN[,3]), environment=environment()) + geom_point()

        p <- p + stat_smooth(method = "loess", formula = y ~ x, size = 1,se=FALSE)

        p <- p + labs(x="", y="Ocorrências por dia", title=" ")

        p <- p + theme_bw()

        p <- p+theme(axis.text=element_text(size=15),
                     axis.title=element_text(size=15))

        print(p)

       

       
    })

    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        var1 <- varInput()
        
        if (var1=="todos")
            {
                dataN <- aggregate(acidentes$id_acidente,
                       by=list(acidentes$diasem,
                           acidentes$dia),length)
            }
        else
            {
                dataN <- aggregate(acidentes$id_acidente[acidentes[,var1]==1],
                       by=list(acidentes$diasem[acidentes[,var1]==1],
                           acidentes$dia[acidentes[,var1]==1]),length)
            }
        
        colnames(dataN) <- c("Dia da Semana","Data","# de ocorrências")

        return(dataN)
    })

   
})
