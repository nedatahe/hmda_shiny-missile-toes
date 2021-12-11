library(tidyverse)
library(httr)

state_names <- read_csv('../../data/states.csv') %>% 
  drop_na()


hmda <- function(selected_states, selected_years) {
  url <- 'https://ffiec.cfpb.gov/v2/data-browser-api/view/csv'
  query = list(
    'states' = selected_states,
    'years' = selected_years
  )
  
  response <- GET(url,
                  query = query)
  loans <- content(response, as = "text") %>% 
    read_csv()
}

# loans <- hmda("WA", "2020")