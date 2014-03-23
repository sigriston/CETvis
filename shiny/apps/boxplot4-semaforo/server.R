library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)


load("../dados/talao-local-falha.rda")

talao$data_origem_sem <- weekdays(talao$data_origem)

talao$data_origem_sem[talao$data_origem_sem=="Sunday"] <- "Domingo"
talao$data_origem_sem[talao$data_origem_sem=="Saturday"] <- "Sábado"
talao$data_origem_sem[talao$data_origem_sem=="Friday"] <- "Sexta"
talao$data_origem_sem[talao$data_origem_sem=="Thursday"] <- "Quinta"
talao$data_origem_sem[talao$data_origem_sem=="Wednesday"] <- "Quarta"      
talao$data_origem_sem[talao$data_origem_sem=="Tuesday"] <- "Terça"
talao$data_origem_sem[talao$data_origem_sem=="Monday"] <- "Segunda"
talao$data_origem_sem <- factor(talao$data_origem_sem,levels=c("Segunda", "Terça", "Quarta","Quinta","Sexta","Sábado", "Domingo"))

talao$prioridade=factor(talao$prioridade,levels=c(1,2,3),
    labels=c("1 – corretiva emergencial",
        "2 – corretiva programada",
        "3 – corretiva não programada"))

talao$causa <- as.factor(talao$causa)

talao$falha_familia <- as.factor(talao$falha_familia)
                  

shinyServer(function(input, output) {

    datasetInput <- reactive({
        switch(input$dataset,
               "Prioridade" = c("prioridade"),
               "Família da falha"=c("falha_familia"),
               "Causa da Falha"=c("causa"))
    })

  


    output$countPlot <- renderPlot({

        var0 <- datasetInput()
        
        dataN <- talao[,c(var0,"duracao","data_origem_sem")]

        dataN <- dataN[complete.cases(dataN),]

        aa <- boxplot(dataN[,"duracao"] ~ dataN[,var0] + dataN[,"data_origem_sem"])

        if (var0=="causa")
            {
                tmp=125
            }
        else
            {
                tmp <- max(aa$stat,na.rm=TRUE)+3
            }

    
        # boxplots mostrando a distribuição do total de vítimas por dia, separadamente para cada dia da semana
        gg2 <- ggplot(data=dataN, aes(dataN[,"data_origem_sem"], dataN[,"duracao"]), environment=environment())
        gg2 <- gg2 + geom_boxplot(aes(fill=dataN[,var0]),outlier.shape = NA_integer_)
        gg2 <- gg2+scale_fill_discrete(name=var0)
        gg2 <- gg2 + scale_y_continuous(limits=c(0, tmp),
                                        labels=comma)
        gg2 <- gg2 + labs(x="Dia da Semana - origem", y="Tempo da origem até encerramento (horas)", title=" ")
        gg2 <- gg2 + theme_bw()

        print(grid.arrange(gg2, ncol=1))
    })
  
    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        var0 <- datasetInput()
        
        dataN <- talao[,c(var0,"duracao","data_origem_sem")]

        dataN <- dataN[complete.cases(dataN),]

        colnames(dataN) <- c(var0, "Duração", "Dia da semana")
        return(dataN)
    })

 
})
