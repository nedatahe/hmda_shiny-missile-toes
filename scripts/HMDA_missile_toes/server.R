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
  
  slider_loans <- reactive({

     loans %>%
        filter(between(loans$count, input$peers[1], input$peers[2]))
    })
  
  # this filters based off of the geographic selections
  
  filtered_loans <- callModule(
    module = selectizeGroupServer,
    id = "geography",
    data = slider_loans,
    vars = c("state_code", "msa_number_title", "census_tract")
  )
  
  #filters geographic output for main lei to study
  
  filtered_lei <- callModule(
    module = selectizeGroupServer,
    id = "primary_lei",
    data = filtered_loans,
    vars = c("name_lei")
  )
  
  
  
  # attempting to build filter to deselct peers
  
  # 
  
  # output written to test app - not plotted currently
  
  output$test <- renderPlot({
    filtered_loans() %>% 
      group_by(derived_race) %>% 
      ggplot(aes(x = derived_race, fill = derived_sex)) +
      geom_bar()
  })
  
  # output datatable for demographic breakdown based on race
  
  
  
  # output$table_lei <- renderDataTable({
  #   race <- table(filtered_lei()$derived_race)
  #   prop <- as.data.frame(prop.table(race))
  #   colnames(prop) = c("derived_race", "percentage")
  #   prop$percentage <- round(prop$percentage * 100, 2)
  #   datatable(prop,
  #             caption = "Selected Lender Breakdown of Race for Area")
  # })
  
  output$table_lei <- renderDataTable({
    lei_prop <- filtered_lei() %>%
      count(derived_race) %>%
      mutate(prop = prop.table(n))

    as.data.frame(lei_prop)

    lei_prop$prop <- round(lei_prop$prop * 100, 2)

    datatable(lei_prop,
              caption = "Selected Lender Breakdown of Race for Area")
  })

 output$table_geo <- renderDataTable({
   loans_prop <- filtered_loans() %>%
     count(derived_race) %>%
     mutate(prop = prop.table(n))

   as.data.frame(loans_prop)

   loans_prop$prop <- round(loans_prop$prop * 100, 2)

   datatable(loans_prop,
             caption = "Geographic Breakdown of Race for Area")
 })
  
  # output$table_geo <- renderDataTable({
  #   race <- table(filtered_loans()$derived_race)
  #   prop <- as.data.frame(prop.table(race))
  #   colnames(prop) = c("derived_race", "percentage")
  #   prop$percentage <- round(prop$percentage * 100, 2)
  #   datatable(prop,
  #             caption = "Geographic Breakdown of Race for Area")
  # })
  
  # output bar plot that can change axis between derived_sex and derived_race
  
  output$lei_demo <- renderPlotly({
    
    p <- filtered_lei() %>% 
      mutate(action_taken = as.factor(action_taken)) %>% 
      ggplot(aes_string(fill = "action_taken", x = input$x_axis)) +
      geom_bar(position='fill') +
      scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +
      coord_flip() +
      xlab("") + 
      ylab("proportion") +
      ggtitle(paste("Selected Lender - Action Taken Versus ",  input$x_axis))
    ggplotly(p)
    
  })
  
  output$loans_demo <- renderPlotly({
    
    p <- filtered_loans() %>% 
      mutate(action_taken = as.factor(action_taken)) %>% 
      ggplot(aes_string(fill = "action_taken", x = input$x_axis)) +
      geom_bar(position='fill') +
      scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +
      coord_flip() +
      xlab("") + 
      ylab("proportion") +
      ggtitle(paste("Geographic - Action Taken Versus ",  input$x_axis))
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
