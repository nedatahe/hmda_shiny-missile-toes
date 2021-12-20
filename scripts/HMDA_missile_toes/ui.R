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
          tract = list(inputId = "census_tract", title = "Census Tract:")
        ),
        inline = FALSE
      ),
      
      # primary LEI selector code, not currently working - does not change plots
      
      selectizeGroupUI(
        id = "primary_lei",
        params = list(
          lei = list(inputId = "name_lei", title = "Select LEI:")
        ),
        inline = FALSE
      ),
      
      # peer selector code - not currently plotted on the app
      # need to decide on how to present this
      
      selectizeGroupUI(
        id = "peers",
        params = list(
          lei = list(inputId = "lei", title = "Deselect peer LEIs as needed:")
        ),
        inline = FALSE
      ),
      
      # code to change the axis of the bar plot
      
      selectInput("x_axis",
                  "Select sex or race",
                  choices = c("derived_sex", "derived_race")
      ),
    ), 
    
    
    mainPanel(
      fluidRow(
        # demographic datatable output
        dataTableOutput("table")
      ),
      fluidRow(
        column(
          #action_taken plot output
          plotlyOutput("sex"),
          width = 12
        )
        # column(
        #   plotlyOutput("race"),
        #   width = 7
        # )
      )
      
    )
  )
))
