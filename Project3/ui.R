

library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Project 3"),
  tabsetPanel(
    #about tab
      tabPanel("About",
               textOutput("about"),
               imageOutput("image")
               ),
      
      #data exploration tab
      tabPanel("Data Exploration",
               #conditional panels for responses and graphs/tables of interest
               selectInput("var",label = "Variable",choices=list("pop"="pop","emp"="emp","hc"="hc","ccon"="ccon")),
               selectInput("type","What would you like to see?",choices=list("Graph"="g","Table"="t")),
               conditionalPanel("input.type == 't'",selectInput("to1","Limiting Variable",list("none","option2"))),
               conditionalPanel("input.type == 'g'",selectInput("go1","Which type of graph",
                  list("scatter","histogram","boxplot")), conditionalPanel("input.go1 == 'scatter'",
                    selectInput("var.int","y variable of interest",choices=list("pop"="pop","emp"="emp","hc"="hc","ccon"="ccon"))),
                  conditionalPanel("input.go1 == 'boxplot'",
                    selectInput("var.box","grouping variable",choices=list("none","op1")))),
               
               #plot based upon input                 
               plotOutput("Plot")),
      
      #modeling tab
      tabPanel("Modeling",
               tabsetPanel(
                 tabPanel("Modeling Info"),
                 tabPanel("Model Fitting"),
                 tabPanel("Prediction")
               )),
      
      #data tab
      tabPanel("Data")
    )
  )
)
