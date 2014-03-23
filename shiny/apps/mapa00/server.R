library(shiny)
require(rCharts)


load("../dados/Acidentes.rda")

# acha a hora dos acidentes
acidentes$hora <- as.numeric(substr(as.character(acidentes$data), 12, 13))

cityL <- c(-23.5475000, -46.6361100)  # Sao Paulo
map3 <- Leaflet$new()
map3$tileLayer(provider = 'Stamen.TonerLite', detectRetina = T)
map3$set(width=680, height=680)
map3$setView(cityL, zoom = 13)


shinyServer(function(input, output) {

    dd <- reactive({
        temp <- acidentes[acidentes$hora %in% c(input$timeFrom, input$timeTo) & acidentes$diasem=='Segunda', c("lat", "lon")]
        temp
    })

    output$myMap <- renderMap({
        pontos <- dd()
        for (i in 1:dim(pontos)[1]) {
            #map3$circle(LatLng=c(pontos[i,1], pontos[i,2]), radius=4)
            map3$marker(c(pontos[i,1], pontos[i,2]))
        }
        return(map3)
    })
})
