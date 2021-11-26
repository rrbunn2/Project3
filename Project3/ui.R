

library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Project 3"),
  tabsetPanel(
      tabPanel("About"),
      tabPanel("Data Exploration",
               plotOutput("Plot")),
      tabPanel("Modeling",
               tabsetPanel(
                 tabPanel("Modeling Info"),
                 tabPanel("Model Fitting"),
                 tabPanel("Prediction")
               )),
      tabPanel("Data")
    )
  )
)
