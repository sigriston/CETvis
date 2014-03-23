# This code imports Infracoes de Transito.csv into R


setwd("../dados")


infracoes <- read.csv(file="./InfracaoTransito/Infracoes de Transito.csv",sep=";",
                      fileEncoding="windows-1252",stringsAsFactors=FALSE)

infracoes$datahora <- strptime(paste(infracoes$Data_infracao,infracoes$Hora_infracao,sep=" "),
                               format='%d/%m/%Y %H:%M')

infracoes <- infracoes[-which(infracoes[,1]==""),]


save(infracoes,file="../infracoes/infracoes.rda")
