
#Libraries used
library(shiny)
library(tidyverse)
library(ggplot2)
library(DT)
library(caret)
library(tree)

shinyServer(function(input, output,session) {
  #data set
  temp<-read_csv("../africa_recession.csv")[,c(1:2,4,13,17,20,36,50)]
  data <- isolate(temp)
  #about tab objects
  output$about <- renderText({
    c("The purpose of this application is to compare 3 seperate supervised learning models for the African Recession Data. For our analysis we are interested in predicting Employment(in Millions). The data comes from (https://www.kaggle.com/chirin/african-country-recession-dataset-2000-to-2017?select=africa_recession.csv) and contains various indicators of economic preformance for various african countries from 2000 to 2017. The Data Exploration tab allows the user to create summaries, graphs and tables. The Modeling tab shows 3 models,  a multiple linear regression model, regression tree, and a random forest model.The Data tab contains the dataset we used in the analysis")
  })
  output$image <- renderImage({
    list(src ="../AfricaRecessionDatasetDescription.PNG" )
  },deleteFile=FALSE)
  
  #data exploration tab objects
  observeEvent(input$type,{
  if(input$type == "g"){
  #Creates plots from user input
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
      ggplot(data=data)+geom_boxplot(aes_string(input$var,group=input$var.box,fill=input$var.box))
    }
  }
    })
  )
  } else{
    #Creates tables from user input
    observeEvent(input$to1,
      output$tab <- renderTable({
      if(input$to1 == "none"){
        data %>% summarise("mean"=mean(!!sym(input$var)),"sd"=sd(!!sym(input$var)))
      } else{
        data %>% group_by(!!sym(input$to1)) %>% summarise("mean"=mean(!!sym(input$var)),"sd"=sd(!!sym(input$var)))
      }
    }))
  }
  })
  
  #Modeling tab objects
  #modeling info tab

  #model fitting tab
  observeEvent(input$action,{
  newdat <- data[,c(input$model.var,"emp")]
  part <- sample.int(n=nrow(newdat),size=floor(input$split*nrow(newdat)))
  test <- newdat[part,]
  train <- newdat[-part,]
  #Multiple Linear Regression
  mlr<-glm(emp~.,data=train)
  #Classification/Regression Tree
  clt<-train(emp~ ., data = train, method = "rpart", preProcess = c("center", "scale"), trControl = trainControl(method = "cv", number = 5))
  #Random Forest
  rfm<-train(emp ~ ., data = train,method = "rf", preProcess = c("center", "scale"),trControl = trainControl(method = "cv", number = 5),tuneGrid = expand.grid(mtry = c(1:5)) )
  #overall results
  predrf <- predict(rfm,test)
  rf_RMSE <- RMSE(predrf,test$emp)
  predclt <- predict(clt,test)
  clt_RMSE <- RMSE(predclt,test$emp)
  predmlr <- predict(mlr,test)
  mlr_RMSE <- RMSE(predmlr,test$emp)
  
  #
  output$overresults <- renderPrint(data.frame("Regression RMSE"=mlr_RMSE,"Regression Tree RMSE"=clt_RMSE,"Random Forest RMSE"=rf_RMSE))
  #MLR results
  output$mlrsummary<-renderPrint(summary(mlr))
  #Tree results
 output$treeresults <- renderPlot({
    plot(clt$finalModel)
    text(clt$finalModel)
  })
 #RF results
 output$rfmresults <- renderPlot({
   plot(rfm)
 })
  #prediction tab
 observeEvent(input$predmodel,{
   if(input$predmodel == "mlr"){
  output$prediction <- renderPrint({
    predict(mlr,newdata=data.frame(
      "pop" = input$pred.pop,
      "hc" = input$pred.hc,
      "rnna" = input$pred.cs,
      "labsh" = input$pred.lbash,
      "xr" = input$pred.xr,
      "total" = input$pred.total,
      "growthbucket" = input$pred.grow
    ))
  })
   } else if(input$predmodel == "clt"){
     output$prediction <- renderPrint({
       predict(clt,newdata=data.frame(
         "pop" = input$pred.pop,
         "hc" = input$pred.hc,
         "rnna" = input$pred.cs,
         "labsh" = input$pred.lbash,
         "xr" = input$pred.xr,
         "total" = input$pred.total,
         "growthbucket" = input$pred.grow
       )) 
    })
   } else {
     output$prediction <- renderPrint({
       predict(rfm,newdata=data.frame(
         "pop" = input$pred.pop,
         "hc" = input$pred.hc,
         "rnna" = input$pred.cs,
         "labsh" = input$pred.lbash,
         "xr" = input$pred.xr,
         "total" = input$pred.total,
         "growthbucket" = input$pred.grow
       )) 
     })
  }
 })
  
  
  })
  output$note<-renderText({c("NOTE: A model must be created in the Model Fitting tab before prediction can be done. In addition, any variables input not in the model will be ignored")})
  
  #Data tab objects
  output$table<-DT::renderDataTable(DT::datatable({data[input$start:input$end,input$table.var]},extensions = 'Buttons',options = list(
    lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
    pageLength = 15,
    paging = TRUE,
    searching = TRUE,
    fixedColumns = TRUE,
    autoWidth = TRUE,
    ordering = TRUE,
    dom = 'tB',
    buttons = list('csv', 'excel',
      list(
      extend = "collection",
      text = 'Show All',
      action = DT::JS("function ( e, dt, node, config ) {
                                    dt.page.len(-1);
                                    dt.ajax.reload();
                                }")
    ))
    ),
  class = "display"
  ))
})
