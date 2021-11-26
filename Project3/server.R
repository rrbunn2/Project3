

library(shiny)
library(tidyverse)

shinyServer(function(input, output) {
  data<-read_csv("../africa_recession.csv") 
  output$Plot <- renderPlot({
    
    hist(data$pop)
    
  })
  
})
