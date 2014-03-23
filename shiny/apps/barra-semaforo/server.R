library(shiny)
library(rCharts)
library(scales)

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


    estInput <- reactive({
        switch(input$estat,
               "Frequência"=1,
               "Proporção"=0)
    })

    output$countPlot <- renderChart({

        var1 <- datasetInput()
        var3 <- estInput()


        dataN<-table(talao$data_origem_sem,talao[,var1])

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


       
        dataN<-table(talao$data_origem_sem,talao[,var1])

        if (var3==1)
            {
                tab <- as.data.frame(dataN)
                colnames(tab) <- c("Dia da semana", var1,"Frequência")

            }
        else
            {
                tab <-  as.data.frame(prop.table(dataN,1))
                colnames(tab) <- c("Dia da semana", var1,"Proporção")
            }

        return(tab)
    })

   
})
