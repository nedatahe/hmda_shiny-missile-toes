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
library(shinyhttr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("HMDA Data Exploration"),
  
  #Sidebar panel with filter controls for geography
  sidebarLayout(
    sidebarPanel(
      
      # state, msa/md and census tract selector code
      
      selectizeGroupUI(
        id = "geography",
        params = list(
          state = list(inputId = "state_code", title = "State:"),
          msa = list(inputId = "derived_msa-md", title = "MSA/MD:"),
          tract = list(inputId = "census_tract", title = "Census Tract:"),
          lei = list(inputId = "lei", title = "LEI:")
        ),
        inline = FALSE
      )
    ), 
    
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("test")
    )
  )
))
