#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  filtered_loans <- callModule(
    module = selectizeGroupServer,
    id = "geography",
    data = loans,
    vars = c("state_code", "derived_msa-md", "census_tract", "lei")
  )
  
 
  
  output$test <- renderPlot({
    filtered_loans() %>% 
      group_by(derived_race) %>% 
      ggplot(aes(x = derived_race, fill = derived_sex)) +
      geom_bar()
  })

})
