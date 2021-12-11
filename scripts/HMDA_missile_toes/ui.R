#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("HMDA Data Exploration"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          
          checkboxGroupButtons(
            inputId = "geo_level",
            label = "Select geographic levels:",
            choices = c("State", "MSA", "Census Tract"),
            selected = "State",
            individual = TRUE,
            checkIcon = list(
              yes = tags$i(class = "fa fa-circle", 
                           style = "color: steelblue"),
              no = tags$i(class = "fa fa-circle-o", 
                          style = "color: steelblue"))
          ),
          
            multiInput(
              inputId = "states",
              label = "Select states:",
              choices = NULL,
              selected = "WA",
              choiceNames = state_names$State,
              choiceValues = state_names$Abbreviation,
              width = '400px'
            ),

            awesomeCheckboxGroup(
              inputId = "years",
              label = "Select years:",
              choices = c("2018", "2019", "2020"),
              selected = "2020",
              inline = TRUE,
              status = "success"
            )
          
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
