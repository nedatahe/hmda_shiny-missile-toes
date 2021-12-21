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
      
      # peer selector code
      
      sliderInput("peers",
                  "Select a range of loans by peers:",
                  min = min_count,
                  max = max_count,
                  value = c(min_count, max_count)),
      
      # state, msa/md and census tract selector code
      
      selectizeGroupUI(
        id = "geography",
        params = list(
          state = list(inputId = "state_code", title = "Select State:"),
          msa = list(inputId = "msa_number_title", title = "Select MSA/MD:"),
          tract = list(inputId = "census_tract", title = "Select Census Tract:")
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
      
      
      
      # code to change the axis of the bar plot
      
      selectInput("x_axis",
                  "Select sex or race:",
                  choices = c("derived_sex", "derived_race", "applicant_age")
      ),
      
      width = 3
    ), 
    
    
    mainPanel(
      fluidRow(
        column(
          # demographic datatable output
          dataTableOutput("table_geo"),
          width = 6
        ),
        column(
          dataTableOutput("table_lei"),
          width = 6
        )
      ),
      fluidRow(
        
        #action_taken plot output
        plotlyOutput("loans_demo"),
        width = 12
      ),
      fluidRow(
        plotlyOutput("lei_demo"),
        width = 12
      )
    )
    
  )
)
)
