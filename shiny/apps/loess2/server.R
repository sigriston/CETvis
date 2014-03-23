library(ggplot2)
library(scales)
library(grid)
library(gridExtra)



load("../dados/Merged.rda")

merged$idadec <- ifelse(merged$idade_condutor=="SI",NA,merged$idade_condutor)

merged$idadev <- ifelse(merged$idade=="SI",NA,merged$idade)

dataNc <- list()

dataNv <- list()

dataNa <- list()


tmp <- aggregate(as.numeric(merged[,"idadec"]),by=list(merged$id_acidente),max)
dataNc[["max"]] <- aggregate(tmp[,1],by=list(tmp[,2]),length)


tmp <- aggregate(as.numeric(merged[,"idadec"]),by=list(merged$id_acidente),min)
dataNc[["min"]] <- aggregate(tmp[,1],by=list(tmp[,2]),length)


tmp <- aggregate(as.numeric(merged[,"idadec"]),by=list(merged$id_acidente),function(x) round(mean(x),0))
dataNc[["media"]] <- aggregate(tmp[,1],by=list(tmp[,2]),length)


tmp <- aggregate(as.numeric(merged[,"idadev"]),by=list(merged$id_acidente),max)
dataNv[["max"]] <- aggregate(tmp[,1],by=list(tmp[,2]),length)


tmp <- aggregate(as.numeric(merged[,"idadev"]),by=list(merged$id_acidente),min)
dataNv[["min"]] <- aggregate(tmp[,1],by=list(tmp[,2]),length)


tmp <- aggregate(as.numeric(merged[,"idadev"]),by=list(merged$id_acidente),function(x) round(mean(x),0))
dataNv[["media"]] <- aggregate(tmp[,1],by=list(tmp[,2]),length)


dataNa[["max"]] <- merge(dataNv[["max"]],dataNc[["max"]],by="Group.1")
dataNa[["min"]] <- merge(dataNv[["min"]],dataNc[["min"]],by="Group.1")
dataNa[["media"]] <- merge(dataNv[["media"]],dataNc[["media"]],by="Group.1")

    
shinyServer(function(input, output) {

    # seleciona o tipo de veiculo envolvido na ocorrencia
    

    varInput <- reactive({
        switch(input$tipo,
               "Vítima"="idadev",
               "Condutor"="idadec",
               "Vítima e Condutor"="ambos"
               )
    })

    estatInput <- reactive({
        switch(input$estat,
               "max"="max",
               "min"="min",
               "media"="media"
               )
    })


    output$countPlot <- renderPlot({

        var1 <- varInput()
        var2 <- estatInput()

        if (var1=="idadev")
            {
                dataN <- dataNv[[var2]]

                smooth_vals3 = predict(loess(dataN[,2]~dataN[,1],dataN,span=.3), dataN[,1])

                plot(x=dataN[,1],y=dataN[,2],col="red",pch=20,ylab="Ocorrências",xlab="Idade",
                     cex.axis=1.5,cex.lab=1.5)
                lines(y=smooth_vals3,x=dataN[,1],col="red")

        
                #p <- ggplot(dataN, aes(x = dataN[,1], y = dataN[,2]), environment=environment()) + geom_point(colour="red")

                #p <- p + stat_smooth(method = "loess", span=.3, formula = y ~ x, size = 1,se=FALSE,colour="red")

                #p <- p + labs(x="", y="Ocorrências", title=" ")

                #p <- p + theme_bw()
                
                #p <- p+theme(axis.text=element_text(size=15), axis.title=element_text(size=15))

                #print(p)
            }
        else if (var1=="idadec")
            {
                dataN <- dataNc[[var2]]

                smooth_vals2 = predict(loess(dataN[,2]~dataN[,1],dataN,span=.3), dataN[,1])

                plot(x=dataN[,1],y=dataN[,2],col="blue",pch=20,ylab="Ocorrências",xlab="Idade",
                     cex.axis=1.5,cex.lab=1.5)
                lines(y=smooth_vals2,x=dataN[,1],col="blue")

                
                
                #p <- ggplot(dataN, aes(x = dataN[,1],  y = dataN[,2]), environment=environment()) + geom_point(colour="blue")

                #p <- p + stat_smooth(method = "loess",span=.3 , formula = y ~ x, size = 1,se=FALSE,colour="blue")

                #p <- p + labs(x="", y="Ocorrências", title=" ")

                #p <- p + theme_bw()
                
                #p <- p+theme(axis.text=element_text(size=15), axis.title=element_text(size=15))

                #print(p)
            }

        else
            {
                dataN <- dataNa[[var2]]

                smooth_vals2 = predict(loess(dataN[,2]~dataN[,1],dataN,span=.3), dataN[,1])
                smooth_vals3 = predict(loess(dataN[,3]~dataN[,1],dataN,span=.3), dataN[,1])

                plot(x=dataN[,1],y=dataN[,3],col="blue",pch=20,ylab="Ocorrências",xlab="Idade",
                     cex.axis=1.5,cex.lab=1.5)
                points(x=dataN[,1],y=dataN[,2],col="red",pch=20)
                lines(y=smooth_vals3,x=dataN[,1],col="blue")
                lines(y=smooth_vals2,x=dataN[,1],col="red")
                legend("topright",legend=c("Vítima","Condutor"),col=c("red","blue"),pch=20)

                
                #p <- ggplot(dataN, aes(x = dataN[,1], y = dataN[,2]), environment=environment()) + geom_point(colour="red")

                #p <- p + stat_smooth(method = "loess", span=.5 , formula = dataN[,2] ~  dataN[,1], size = 1,se=FALSE,colour="red")
                
                #p <- p + geom_point(aes(x = dataN[,1], y = dataN[,3]),colour="blue")
                
                #p <- p + stat_smooth(method = "loess", span=.5, formula = dataN[,3] ~ dataN[,1], size = 1,se=FALSE,colour="blue")

                #p <- p + labs(x="", y="Ocorrências", title=" ")

                

                #p <- p + theme_bw()
                
                #p <- p+theme(axis.text=element_text(size=15),axis.title=element_text(size=15))

                #print(p)
            }
       

       
    })

    output$guardianTable = renderDataTable({

        # planilha com os dados usados nos gráficos
        var1 <- varInput()
        var2 <- estatInput()

        if (var1=="idadev")
            {
                dataN <- dataNv[[var2]]
                colnames(dataN) <- c(paste0("Idade ",var2),"# de ocorrências")

            }
        
        else if (var1=="idadec")
            {
                dataN <- dataNc[[var2]]
                colnames(dataN) <- c(paste0("Idade ",var2),"# de ocorrências")
                
            }
        else
            {
                dataN <- dataNa[[var2]]
                colnames(dataN) <- c(paste0("Idade ",var2),"Condutor","Vítima")

            }
        

        
       

        return(dataN)
    })

   
})
