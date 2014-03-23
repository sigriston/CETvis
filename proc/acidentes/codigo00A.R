# This code imports 2013_acidentes-1o_Semestre.csv into R


setwd("../dados")


acidentes20131S <- read.csv(file="./acidentes/2013_acidentes-1o_Semestre.csv",sep=";",stringsAsFactors=FALSE)

acidentes20112012 <- read.csv(file="./acidentes/2011-2012_acidentes.csv",sep=";",stringsAsFactors=FALSE)


acidentes <- rbind(acidentes20112012,acidentes20131S)

tmp <- as.character(acidentes$data)
dia <- substr(tmp, start=1, stop=10)
hora <- substr(tmp, start=12, stop=16)
acidentes$dianum <- as.numeric(as.Date(dia,format="%d/%m/%Y"))
acidentes$dia <- as.Date(dia,format="%d/%m/%Y")
acidentes$diasem <- weekdays(as.Date(dia,format="%d/%m/%Y"))
acidentes$diasem[acidentes$diasem=="Sunday"] <- "Domingo"
acidentes$diasem[acidentes$diasem=="Saturday"] <- "Sábado"
acidentes$diasem[acidentes$diasem=="Friday"] <- "Sexta"
acidentes$diasem[acidentes$diasem=="Thursday"] <- "Quinta"
acidentes$diasem[acidentes$diasem=="Wednesday"] <- "Quarta"      
acidentes$diasem[acidentes$diasem=="Tuesday"] <- "Terça"
acidentes$diasem[acidentes$diasem=="Monday"] <- "Segunda"
acidentes$diasem <- factor(acidentes$diasem,levels=c("Segunda", "Terça", "Quarta","Quinta","Sexta","Sábado", "Domingo"))


acidentes$dataformato = strptime(acidentes$data,format='%d/%m/%Y %H:%M')

acidentes$semestre <- ifelse(acidentes$dataformato$mon<6,1,2)

acidentes$ano <- acidentes$dataformato$year

acidentes$ano[acidentes$ano==111] <- 2011

acidentes$ano[acidentes$ano==112] <- 2012

acidentes$ano[acidentes$ano==113] <- 2013



save(acidentes,file="../acidentes/Acidentes00.rda")
