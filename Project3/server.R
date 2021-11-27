

library(shiny)
library(tidyverse)
library(ggplot2)

shinyServer(function(input, output,session) {
  #data set
  temp<-read_csv("../africa_recession.csv")[,1:5]
  data <- isolate(temp)
  #about objects
  output$about <- renderText({
    c("The purpose of this application is to compare 3 seperate supervised learning models for the African Recession Data. The data comes from (https://www.kaggle.com/chirin/african-country-recession-dataset-2000-to-2017?select=africa_recession.csv) and contains various indicators of economic preformance for various african countries from 2000 to 2017. The Data Exploration tab allows the user to create summaries, graphs and tables. The Modeling tab shows 3 models,  a multiple linear regression model, regression tree, and a random forest model.The Data tab contains the dataset we used in the analysis")
  })
  output$image <- renderImage({
    list(src ="../AfricaRecessionDatasetDescription.PNG" )
  })
  
  #data exploration objects
  observeEvent(input$type,
  if(input$type == "g"){
  observeEvent(input$go1,  
  output$Plot <- renderPlot({
    if(input$go1 == "histogram"){
    ggplot(data=data)+geom_histogram(aes_string(input$var))
    
  }else if(input$go1 == "scatter"){
    
    ggplot(data=data)+geom_point(aes_string(input$var,input$var.int))
    
  }else{
    if(input$var.box == "none"){
      ggplot(data=data)+geom_boxplot(aes_string(input$var))}
    else{
      ggplot(data=data)+geom_boxplot(aes_string(input$var,input$var.box))
    }
  }
    })
  )
    })
  #Modeling objects
  
  #Data objects
  
})
