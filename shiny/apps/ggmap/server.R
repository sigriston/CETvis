library(shiny)
require(ggmap)

campinasMapData <- get_map(location = c(lon=-47.0573, lat=-22.9009),
                           color="color",
                           source="google",
                           maptype="roadmap",
                           zoom=12)

campinasMap <- ggmap(campinasMapData, extent="device")

saoPauloMapData <- get_map(location = c(lon = -46.6361100, lat = -23.5475000),
                           color="color",
                           source="google",
                           maptype="roadmap",
                           zoom=12)

saoPauloMap <- ggmap(saoPauloMapData, extent="device")

# Server logic
shinyServer(function(input, output) {

    cityMap <- reactive({
        switch(input$city,
               "Campinas" = campinasMap,
               "São Paulo" = saoPauloMap)
    })

    # Expression generating plot of the distribution
    output$mapPlot <- renderPlot({
        thisMap <- cityMap()

        print(thisMap)
    },
        height=800,
        width=800
    )
})
