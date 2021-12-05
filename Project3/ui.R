

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
               selectInput("var",label = "Variable",choices=list("Population"="pop", "Employment" = "emp", "Human Capital Index" = "hc","Capital Stock" = "rnna","Share of Labor Compensation in GDP" = "labsh", "Exchange Rate" = "xr","Annual Bank of Canada commodity price index  Total" = "total")),
               selectInput("type","What would you like to see?",choices=list("Graph"="g","Table"="t")),
               conditionalPanel("input.type == 't'",selectInput("to1","Limiting Variable",list("none","growthbucket"))),
               conditionalPanel("input.type == 'g'",selectInput("go1","Which type of graph",
                  list("scatter","histogram","boxplot")), conditionalPanel("input.go1 == 'scatter'",
                    selectInput("var.int","y variable of interest",choices=list("Population"="pop", "Employment" = "emp", "Human Capital Index" = "hc","Capital Stock" = "rnna","Share of Labor Compensation in GDP" = "labsh", "Exchange Rate" = "xr","Annual Bank of Canada commodity price index  Total" = "total"))),
                  conditionalPanel("input.go1 == 'boxplot'",
                    selectInput("var.box","grouping variable",choices=list("none","Recession Indicator" = "growthbucket")))),
               
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
                 tabPanel("Model Fitting",
                   numericInput("split","select the size of the testing set",.1,min=.1,max=.9,step = .01),
                   checkboxGroupInput("model.var","Select the variables you would like to use in the model",choices = list("Population"="pop", "Recession Indicator" = "growthbucket", "Human Capital Index" = "hc","Capital Stock" = "rnna","Share of Labor Compensation in GDP" = "labsh", "Exchange Rate" = "xr","Annual Bank of Canada commodity price index  Total" = "total")),
                   actionButton("action",label = "Run Models"),
                   verbatimTextOutput("overresults"),
                   verbatimTextOutput("mlrsummary"),
                   plotOutput("treeresults"),
                   plotOutput("rfmresults")
                 ),
                 #model prediction
                 tabPanel("Prediction",
                   textOutput("note"),
                   radioButtons("pred.model","Choose the model which you will use for prediction",list("Multiple Linear Regression"="mlr","Regression Tree"="rt", "Random Forest"="rf")))
               )),
      
      #data tab
      tabPanel("Data",
               numericInput("start","Starting Point for Rows",1,min=1,max=486),
               numericInput("end","Ending Point for Rows ",486,min=1,max=486),
               checkboxGroupInput("table.var","Select the variables you would like to see",choices = list("Population"="pop", "Employment" = "emp", "Human Capital Index" = "hc","Capital Stock" = "rnna","Share of Labor Compensation in GDP" = "labsh", "Exchange Rate" = "xr","Annual Bank of Canada commodity price index  Total" = "total", "Recession Indicator" = "growthbucket")),
               dataTableOutput("table"))
    )
  )
)
