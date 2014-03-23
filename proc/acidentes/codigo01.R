# This code imports 2013_veiculos-1o_Semestre.csv into R
# This code imports 2013_vitimas-1o_Semestre.csv into R


setwd("../dados")




veiculos20131S <- read.csv(file="./acidentes/2013_veiculos-1o_Semestre.csv",sep=";",stringsAsFactors=FALSE)

vitimas20131S <- read.csv(file="./acidentes/2013_vitimas-1o_Semestre.csv",sep=";",stringsAsFactors=FALSE)



veiculos20112012 <- read.csv(file="./acidentes/2011-2012_veiculos.csv",sep=";",stringsAsFactors=FALSE)

vitimas20112012 <- read.csv(file="./acidentes/2011-2012_vitimas.csv",sep=";",stringsAsFactors=FALSE)

vitimas <- rbind(vitimas20112012,vitimas20131S)

veiculos <- rbind(veiculos20112012,veiculos20131S)


# excluir linhas que estão repetidas
vitimas <- unique(vitimas)
veiculos <- unique(veiculos)



# excluir ocorrencias que só estão listadas no banco vitimas, mas nao no veiculo
vitimas <- vitimas[vitimas$id_acidente %in% veiculos$id_acidente,]

merged <- merge(veiculos,vitimas,by=c("id_acidente","id_veiculo"),all=TRUE)

merged <- unique(merged)


# incluir data (usar info do conjunto de dados "acidentes")

load("../acidentes/Acidentes00.rda")

aa <- match(merged$id_acidente,acidentes$id_acidente)

merged$dia <- acidentes$dia[aa]

merged$diasem <- acidentes$diasem[aa]

merged$ano <- acidentes$ano[aa]

merged$semestre <- acidentes$semestre[aa]


# incluir sentido e tipo de acidente (usar info do conjunto de dados "acidentes")


merged$sentido <- as.character(acidentes$sentido[aa])

merged$tipo_acidente <- as.character(acidentes$tipo_acidente[aa])


save(merged,file="../acidentes/Merged.rda")


