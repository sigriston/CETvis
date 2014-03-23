# This code imports 2013_acidentes-1o_Semestre.csv into R


setwd("../dados")


acidentes <- read.csv(file="./acidentes/2013_acidentes-1o_Semestre.csv",sep=";",
                      fileEncoding="windows-1252")

# exclude occurrences without precise location information
acidentes <- acidentes[-which(acidentes$alt_num==0 & acidentes$logradouroB==""),] 


acidentes$local <- ifelse(acidentes$alt_num>0,
                          paste(acidentes$logradouroA,acidentes$alt_num,"SAO PAULO SP",sep=" "),
                          paste(acidentes$logradouroA,"SAO PAULO SP & ",acidentes$logradouroB,"SAO PAULO SP",sep=" "))

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




# Adding two columns: latitude and longitude, using the info from variables
# logradouroA, alt_num, logradouroA, logradouroB

library(ggmap)

acidentes$lat <- NA
acidentes$lon <- NA

# Google API has a limit of 2500 requests per day, change this code accordingly
for (i in 1:dim(acidentes)[1]) 
    {
        tmp <- geocode(acidentes$local[i])
        acidentes$lat[i] <- tmp$lat
        acidentes$lon[i] <- tmp$lon
    }



# For some locations, we have issues with the lat/long given from GoogleAPI
# We will flag some "outliers" lat/long

tmp1 <- boxplot(acidentes$lon)
tmp2 <- boxplot(acidentes$lat)

badlon <- ifelse(acidentes$lon %in% tmp1$out,1,0)
badlat <- ifelse(acidentes$lat %in% tmp2$out,1,0)

tmp3 <- union(x=acidentes$id_acidente[badlon==1],y=acidentes$id_acidente[badlat==1])

# variable "badlatlo" indicates bad geocoded locations: 1=bad 0 =ok

acidentes$badlatlon <- ifelse(acidentes$id_acidente %in% tmp3,1,0)


save(acidentes,file="../acidentes/Acidentes.rda")
