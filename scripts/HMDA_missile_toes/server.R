#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


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
  
  # output$table <- renderDataTable({
  #   filtered_loans() %>% 
  #     mutate(derived_race = as.factor(derived_race)) %>% 
  #     table(derived_race) %>% 
  #     as.data.frame(prop.table(n))
  #   #datatable(prop)
  #})
  
  output$sex <- renderPlotly({
    p <- filtered_loans() %>% 
      #mutate(action_taken = )
      ggplot(aes(fill = as_factor(action_taken), x = derived_sex)) +
      geom_bar(position='fill') +
      scale_y_continuous(labels = function(x) format(x, scientific = FALSE))
    ggplotly(p)
    
  })
  
  output$race <- renderPlotly({
    p <- filtered_loans() %>% 
      #mutate(action_taken = )
      ggplot(aes(fill = as_factor(action_taken), x = derived_race)) +
      geom_bar(position='fill') +
      scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) + 
      scale_color_manual(name = "as_factor(action_taken)", labels = c("Loan originated", "Application approved but not accepted",
                                                                       "Application denied", "Application withdrawn by applicant",
                                                                       "File closed for incompleteness", "Purchased loan",
                                                                       "Preapproval request denied",
                                                                       "Preapproval request approved but not accepted"))
    ggplotly(p)
    
  })
  
})
