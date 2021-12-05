

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
                          withMathJax(),
                            p("We fit 3 seperate models,  a multiple linear regression model, regression tree, and a random forest model"),
                            br(),
                            "The first model we fit is a linear regression model",
                            br(),
                            "Employment = $$\\beta_0 + \\beta_1*Population  + \\beta_2*Human Capital + \\beta_3*Capital Stock + \\beta_4*Labor + \\beta_5*Exchange Rate $$", "$$ + \\beta_6*Commodity Index + \\beta_7*Recession Indicator$$",
                            br(),
                            "The benefits of a linear regression model is that it is not very compulationally intensive and is easy to interpret if we were interested in an interpretation.",
                            br(),
                            "The drawbacks of a linear model is that it requires some statisticial assumptions and there is no built-in variable selection. ",
                            br(),br(),
                            "The second model we fit is a regression tree",
                            br(),
                            "The benefits of a regression tree are that it requires no statisitics assumptions and has a built-in variable selection process.",
                            br(),
                            "The drawbacks of a regression tree are that the algorithm is greed and the tree is sensitive to small data changes.",
                            br(),br(),
                            "The final model we fit is a random forest model",
                            br(),
                            "The benefits of a random forest model are that it improves accuracy of the previous tree model and is highly flexible.",
                            br(),
                            "The drawbacks of a random forest model is that it is computationally intensive and is difficult to interpret."
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
                   radioButtons("predmodel","Choose the model which you will use for prediction",list("Multiple Linear Regression"="mlr","Regression Tree"="clt", "Random Forest"="rfm")),
                   numericInput("pred.pop","Population (Millions)",1,min = 0,step=.01),
                   numericInput("pred.grow","Recssion Indicator",0,min = 0,max=1,step = 1),
                   numericInput("pred.hc","Human Capital Index",1,min = 0,max=3,step = .01),
                   numericInput("pred.cs","Capital Stock",100000,min = 0,step = .1),
                   numericInput("pred.lbash","Share of Labor Compensation in GDP",.5,min = 0,max=1,step=.01),
                   numericInput("pred.xr","Exchange Rate",1,min = 0,step=.1),
                   numericInput("pred.total","Annual Bank of Canada commodity price index Total",500,min = 200,step=.01),
                   verbatimTextOutput("prediction")
                   )
               )),
      
      #data tab
      tabPanel("Data",
               numericInput("start","Starting Point for Rows",1,min=1,max=486),
               numericInput("end","Ending Point for Rows ",486,min=1,max=486),
               checkboxGroupInput("table.var","Select the variables you would like to see",choices = list("Population"="pop", "Employment" = "emp", "Human Capital Index" = "hc","Capital Stock" = "rnna","Share of Labor Compensation in GDP" = "labsh", "Exchange Rate" = "xr","Annual Bank of Canada commodity price index  Total" = "total", "Recession Indicator" = "growthbucket"),selected = "pop"),
               dataTableOutput("table"))
    )
  )
)
