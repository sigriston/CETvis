# This code imports Falha.csv into R
# This code imports Local.csv into R
# This code imports Falha_Talao.csv into R


setwd("../dados")




falha <- read.csv(file="./ManutencaoSemaforica/Falha.csv",sep=";",stringsAsFactors=FALSE,
                  fileEncoding="windows-1252")

local <- read.csv(file="./ManutencaoSemaforica/Local.csv",sep=";",stringsAsFactors=FALSE,
                  fileEncoding="windows-1252")

talao <- read.csv(file="./ManutencaoSemaforica/Talao_Falha.csv",sep=";",stringsAsFactors=FALSE,
                  fileEncoding="windows-1252")




talao$data_abertura = strptime(talao$data_abertura,format='%d/%m/%Y %H:%M')
talao$data_informacao = strptime(talao$data_informacao,format='%d/%m/%Y %H:%M')
talao$data_acionamento = strptime(talao$data_acionamento,format='%d/%m/%Y %H:%M')
talao$data_chegada = strptime(talao$data_chegada,format='%d/%m/%Y %H:%M')
talao$data_confirmacao = strptime(talao$data_confirmacao,format='%d/%m/%Y %H:%M')
talao$data_acionamento_eletro = strptime(talao$data_acionamento_eletro,format='%d/%m/%Y %H:%M')
talao$data_cancelamento_eletro = strptime(talao$data_cancelamento_eletro,format='%d/%m/%Y %H:%M')

talao$data_origem = strptime(talao$data_origem,format='%d/%m/%Y %H:%M')
talao$data_encerramento = strptime(talao$data_encerramento,format='%d/%m/%Y %H:%M')

# tempo até encerramento (dias)
talao$duracao <- as.numeric(talao$data_encerramento-talao$data_origem)/(60*60)


##### adicionando info de Falha.csv nos dados do Talão
tmp <- match(talao$id_falha,falha$id_falha)

talao$falha_nome <- falha$nome[tmp]

talao$falha_prioridade <- falha$prioridade[tmp]

talao$falha_familia <- falha$familia[tmp]

table(talao$falha_prioridade,talao$prioridade)



##### adicionando info de Local.csv nos dados do Talão
tmp <- match(talao$id_local,local$id_local)

talao$local <- local$local[tmp]

talao$local_subprefeitura <- local$subprefeitura[tmp]

talao$local_distrito <- local$distrito[tmp]

talao$lat <- local$latitude[tmp]

talao$lon <- local$lon[tmp]

talao <- talao[!is.na(talao$duracao),]

save(talao,file="../semaforos/talao-local-falha.rda")

write.csv(talao,file="../semaforos/talao-local-falha.csv")


