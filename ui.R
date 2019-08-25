#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application
shinyUI(fluidPage(
  
  # Application title and byline
  titlePanel("Predict the Cost of College Tuition"),
  h6("by Matt Stetz, 2019"),
  
  # Sidebar 
  sidebarLayout(
          
          sidebarPanel(
                  
                  # Drop Down
                  selectInput("collegetype", "Type of College:",
                              c("All Types" = "All",
                                "All Four Year" = "FourYear",
                                "Public Four Year" = "FourYearPublic",
                                "Private Four Year" = "FourYearPrivate",
                                "All Two Year" = "TwoYear",
                                "Public Two Year" = "TwoYearPublic",
                                "Private Two Year" = "TwoYearPrivate")
                              ),
                  
                  # Slider
                  sliderInput("sliderYear", "Enrollment Year:", 2000, 2035, value=20),
                  
                  # References
                  h3("Documentation"),
                  h6("This web app will allow you to predict the cost of college tuition in the future. Click the drop down menu to select the type of college. Use the slider to select the year. Click on the legend labels to toggle what to display."),
                  h3("Data Source"),
                  h6("All data used to build this app were obtained from the United States Federal Government's Department of Education, National Center for Education Statistics. (2019). Data were published in the Digest of Education Statistics, 2017 (NCES 2018-070). 
                     Historic Cost represents the average total tuition, fees, and estimated room and board costs charged to full-time undergraduate students. All costs are reported in current USD adjusted for inflation.")
          ),
          
          # Main
          mainPanel(
                  # The Data
                  plotlyOutput("plot1"),
                  h4("Selected Enrollment Year: "),
                  # The Input
                  textOutput("year"),
                  # The Output
                  h4("Predicted Cost of College Tuition: "),
                  textOutput("pred1")
          )
  )
))