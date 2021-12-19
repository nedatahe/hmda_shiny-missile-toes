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
    vars = c("state_code", "derived_msa-md", "census_tract")
  )
  
  filtered_lei <- callModule(
    module = selectizeGroupServer,
    id = "primary_lei",
    data = filtered_loans(),
    vars = c("lei")
  )

  
  
  output$test <- renderPlot({
    filtered_loans() %>% 
      group_by(derived_race) %>% 
      ggplot(aes(x = derived_race, fill = derived_sex)) +
      geom_bar()
  })
  
  output$table <- renderDataTable({
    race <- table(filtered_loans()$derived_race)
    prop <- as.data.frame(prop.table(race))
    colnames(prop) = c("derived_race", "percentage")
    prop$percentage <- round(prop$percentage * 100, 2)
    datatable(prop)
  })
  
  output$sex <- renderPlotly({
    
    p <- filtered_loans() %>% 
      mutate(action_taken = as.factor(action_taken)) %>% 
      ggplot(aes_string(fill = "action_taken", x = input$x_axis)) +
      geom_bar(position='fill') +
      scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +
      coord_flip() +
      xlab("")
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
                                                                       "Preapproval request approved but not accepted")) +
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
    
    ggplotly(p)
    
  })
  
})
