library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)


load("dados/Merged.rda")

source("functions/arrange_ggplot2.R")




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
    
    anoInput <- reactive({
        switch(input$ano,
               "2013"=c(2013),
               "2012"=c(2012),
               "2011"=c(2011))
    })

    semestreInput <- reactive({
        switch(input$semestre,
               "Primeiro"=c(1),
               "Segundo"=c(2),
               "Ambos"=c(1,2))
    })

    vitcondInput <- reactive({
        switch(input$vitcond,
               "da vítima"="x",
               "do condutor"="y")
    })
     
    output$countPlot <- renderPlot({

        var1 <- datasetInput()
        var2 <- varInput()
        var3 <- anoInput()
        var4 <- semestreInput()
        var5 <- vitcondInput()

        escol=paste0("escolaridade.",var5)

        

# numero de vitimas feridas por dia, por escolaridade (1 a 8)
        tmp1 <- merged[merged$ano %in% var3 & merged$semestre %in% var4,]
        
        dataN <- aggregate(tmp1$classificacao, by=list(tmp1$diasem,tmp1$dia,tmp1[,escol]),
                          function(x) sum(x %in% var1, na.rm=TRUE))

        
        dataN0 <- aggregate(merged$classificacao, by=list(merged$diasem,merged$dia,merged[,escol]),
                          function(x) sum(x %in% var1, na.rm=TRUE))



        if (sum(var2==c(1:8))==8) {

            tmp <- aggregate(dataN[,4],by=list(dataN[,1],dataN[,2]),function(x) sum(x))
            dataN <- data.frame(tmp[,1],tmp[,2],"Todas",tmp[,3])
            
            tmp0 <- aggregate(dataN0[,4],by=list(dataN0[,1],dataN0[,2]),function(x) sum(x))
            dataN0 <- data.frame(tmp0[,1],tmp0[,2],"Todas",tmp0[,3])
            

        } else {

            dataN <- dataN[dataN[,3]%in% var2,]
            dataN0 <- dataN0[dataN0[,3]%in% var2,]

        }

        smooth_vals = predict(loess(dataN0[,4]~as.numeric(dataN0[,2]),dataN0,span=.1), as.numeric(dataN0[,2]))

        #plot(x=dataN0[,2],y=dataN0[,4],col="blue",pch=20,ylab="Total de Vítimas (por dia)",xlab="Data",
         #    cex.axis=1.5,cex.lab=1.5)
        #lines(y=smooth_vals,x=dataN0[,2],col="blue")

        # loess

        rr <- ggplot(data=dataN0,group=dataN[,4],environment=environment())
        rr <- rr + geom_point(aes(x=dataN0[,2], y=dataN0[,4], color=2), stat="identity", size=1)
        rr <- rr + geom_path(aes(x=dataN0[,2], y=smooth_vals), size=1)

        rr <- rr + scale_y_continuous(limits=c(0, max(dataN0[,4])),
                                      labels=comma)
        
        rr <- rr + labs(x="", y="# vítimas", title="Total de Vítimas (por dia) - 2011 a 2013")
        rr <- rr + theme_bw()
        rr <- rr + theme(legend.position="none")
      
                              
        

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

        arrange_ggplot2(gg, gg2, rr, ncol=1)
        #print(grid.arrange(rr,gg, gg2, ncol=1))
    })
  
    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
         var1 <- datasetInput()
         var2 <- varInput()
         var3 <- anoInput()
         var4 <- semestreInput()

         var5 <- vitcondInput()

        

# numero de vitimas feridas por dia, por escolaridade (1 a 8)
        tmp1 <- merged[merged$ano %in% var3 & merged$semestre %in% var4,]
        
        dataN <- aggregate(tmp1$classificacao, by=list(tmp1$diasem,tmp1$dia,tmp1$escolaridade.y),
                          function(x) sum(x %in% var1, na.rm=TRUE))


        if (sum(var2==c(1:8))==8) {

            tmp <- aggregate(dataN[,4],by=list(dataN[,1],dataN[,2]),function(x) sum(x))
            dataN <- data.frame(tmp[,1],tmp[,2],"Todas",tmp[,3])

        } else {

            dataN <- dataN[dataN[,3]%in% var2,]
        }
        colnames(dataN) <- c("Dia da Semana", "Dia", "Escolaridade da Vitima", "Total de Vítimas")
        return(dataN)
 
    })

    output$Teste <- renderPrint({

        # Teste Kruskal-Wallis para testar se medianas do total de vítimas por dia são iguais para cada dia da semana
        # p-value <0.05 indica que há diferença estatística entre os dias de semana
        var1 <- datasetInput()
        var2 <- varInput()
        var3 <- anoInput()
        var4 <- semestreInput()
        var5 <- vitcondInput()


        

# numero de vitimas feridas por dia, por escolaridade (1 a 8)
        tmp1 <- merged[merged$ano %in% var3 & merged$semestre %in% var4,]
        
        dataN <- aggregate(tmp1$classificacao, by=list(tmp1$diasem,tmp1$dia,tmp1$escolaridade.y),
                          function(x) sum(x %in% var1, na.rm=TRUE))


        if (sum(var2==c(1:8))==8) {

            tmp <- aggregate(dataN[,4],by=list(dataN[,1],dataN[,2]),function(x) sum(x))
            dataN <- data.frame(tmp[,1],tmp[,2],"Todas",tmp[,3])

        } else {

            dataN <- dataN[dataN[,3]%in% var2,]
        }
        print(kruskal.test(dataN[,4]~dataN[,1]))
    })
})
