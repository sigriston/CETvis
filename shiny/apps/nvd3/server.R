library(shiny)
require(rCharts)


shinyServer(function(input, output) {

    output$myChart <- renderChart({

        hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
        n2 <- nPlot(Freq ~ Hair, group = 'Eye', data = hair_eye_male,
                    type = 'multiBarChart', dom='myChart', width=700)
        return(n2)
    })
})
