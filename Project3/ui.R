

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
               conditionalPanel("input.type == 't'",selectInput("to1","Limiting Variable",list("none","growthbucket"))),
               conditionalPanel("input.type == 'g'",selectInput("go1","Which type of graph",
                  list("scatter","histogram","boxplot")), conditionalPanel("input.go1 == 'scatter'",
                    selectInput("var.int","y variable of interest",choices=list("pop"="pop","emp"="emp","hc"="hc","ccon"="ccon"))),
                  conditionalPanel("input.go1 == 'boxplot'",
                    selectInput("var.box","grouping variable",choices=list("none","growthbucket")))),
               
               #plot based upon input                 
               conditionalPanel("input.type == 'g'",{plotOutput("Plot")}),
               conditionalPanel("input.type == 't'",{tableOutput("tab")})
               
               
               ),
      
      #modeling tab
      tabPanel("Modeling",
               tabsetPanel(
                 #modeling info
                 tabPanel("Modeling Info",
                   textOutput("info")
                   #withMathJax()
                 ),
                 #model fitting
                 tabPanel("Model Fitting"),
                 #model prediction
                 tabPanel("Prediction")
               )),
      
      #data tab
      tabPanel("Data",
               numericInput("start","Starting Point for Rows",1,min=1,max=486),
               numericInput("end","Ending Point for Rows ",486,min=1,max=486),
               checkboxGroupInput("table.var","Select the variables you would like to see",choices = list("pop"="pop","emp"="emp","hc"="hc","ccon"="ccon")),
               dataTableOutput("table"))
    )
  )
)
