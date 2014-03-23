library(shiny)
require(rCharts)


shinyServer(function(input, output) {

    cityLatLng <- reactive({
        switch(input$city,
               "Campinas" = c(-22.9009, -47.0573),
               "São Paulo" = c(-23.5475000, -46.6361100))
    })

    output$myMap <- renderMap({
        cityL <- cityLatLng()
        map3 <- Leaflet$new()
        map3$set(width=680, height=680)
        map3$setView(cityL, zoom = 13)
        return(map3)
    })
})
