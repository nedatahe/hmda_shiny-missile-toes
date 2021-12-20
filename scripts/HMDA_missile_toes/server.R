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
  
  # this filters based off of the geographic selections
  
  filtered_loans <- callModule(
    module = selectizeGroupServer,
    id = "geography",
    data = loans,
    vars = c("state_code", "derived_msa-md", "census_tract")
  )
  
  #filters geographic output for main lei to study
  
  filtered_lei <- callModule(
    module = selectizeGroupServer,
    id = "primary_lei",
    data = filtered_loans(),
    vars = c("lei")
  )
  
  # attempting to build filter to deselct peers
  
  # peers <- reactive({
  #   if (is.na(input$lei)){
  #     filtered_loans()
  #   } else {
  #     filtered_loans() %>% 
  #       filter(lei != input$lei)
  #   }
  # })
  # 
  # filtered_peers <- callModule(
  #   module = selectizeGroupServer,
  #   id = "peers",
  #   data = peers(),
  #   vars = c("lei")
  # )
  
  # output written to test app - not plotted currently
  
  output$test <- renderPlot({
    filtered_loans() %>% 
      group_by(derived_race) %>% 
      ggplot(aes(x = derived_race, fill = derived_sex)) +
      geom_bar()
  })
  
  # output datatable for demographic breakdown based on race
  
  output$table <- renderDataTable({
    race <- table(filtered_loans()$derived_race)
    prop <- as.data.frame(prop.table(race))
    colnames(prop) = c("derived_race", "percentage")
    prop$percentage <- round(prop$percentage * 100, 2)
    datatable(prop)
  })
  
  # output bar plot that can change axis between derived_sex and derived_race
  
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
  
  # seperate plot for derived_race - not currently in app - don't need because of reactive axis in above plot
  
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
