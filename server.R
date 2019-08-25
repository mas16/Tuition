#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(broom)

# Define server logic
shinyServer(function(input, output) {
        # Set working directory for getting the data
        #setwd("./Tuition/")
        
        # Read college tuition data
        tuition <- read.csv("./tuition.csv", header=TRUE, colClasses=rep("numeric",8))
        
        # Convert to data frame
        tuition <- data.frame(tuition)
        
        # Fit separate models to ALL data
        test <- list(NA)
        for (i in seq(ncol(tuition[, -1]))) {
                test[[i]] <- lm(tuition[, i+1] ~ Date, data=tuition)
        }
        
        # Use reactive statement for ui
        model1pred <- reactive({
                yearInput <- input$sliderYear
                collegeInput <- input$collegetype
                modelNum <-  match(collegeInput, colnames(tuition[-1]))
                predict(test[[modelNum]], newdata=data.frame(Date=yearInput))
        })
        
        # Use reactive statement for ui
        yearOut <- reactive({
                yearInput <- input$sliderYear
        })

        # All Output
        output$plot1 <- renderPlotly({
                
                # Data
                yearInput <- input$sliderYear
                collegeInput <- input$collegetype
                modelNum <-  match(collegeInput, colnames(tuition[-1]))
                prediction <- predict(test[[modelNum]], newdata=data.frame(Date=yearInput))
                
                # Add new data point to historic data
                x_vals <-  c(tuition[, "Date"], yearInput)
                y_vals <- c(tuition[, collegeInput], prediction)
                
                # Add new data point to modeled data
                predfit <- c(fitted(test[[modelNum]]), prediction)

                # Fetch residual standard error of model
                error <- summary(test[[modelNum]])$sigma
                
                # Generate plot
                p <- plot_ly(x=x_vals) %>%
                
                        add_markers(y=y_vals,
                                    marker=list(size=16),
                                    name="Historic Cost (USD)") %>%
                      
                        # Add prediction
                        add_markers(x=yearInput, y=prediction,
                                    marker=list(size=16, color='red'),
                                    name="Predicted Cost (USD)") %>%
                        
                        # Add model
                        add_lines(x=x_vals, y=predfit,
                                  line=list(color = 'rgba(255, 127, 14, 1.0)'),
                                  name="Linear Model") %>%
                        
                        # Add residual standard error
                        add_ribbons(data=augment(test[[modelNum]]),
                                    ymin=predfit - 1.96 * error,
                                    ymax=predfit + 1.96 * error,
                                    line=list(color='rgba(255, 127, 14, 0.05)'),
                                    fillcolor='rgba(255, 127, 14, 0.3)',
                                    name="Residual Standard Error") %>%
                       
                         # Adjust layout
                        layout(xaxis=list(title="<b>Year"),
                               yaxis=list(title="<b>Cost (USD)"))
        })
        
        # Output from model
        output$pred1 <- renderText({
                model1pred()
        })
        # Input year sent to output for display
        output$year <- renderText({
                yearOut()
        })
})