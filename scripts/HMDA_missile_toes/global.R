library(tidyverse)
library(httr)
library(DT)
library(plotly)

#reading in state names for the selector dropdown

state_names <- read_csv('../../data/states.csv') %>% 
  drop_na()

#reading in initial dataset for Pacific Northwest

loans <- read_csv('../../data/state_WA-OR-ID.csv')


#function for API call for additional state data

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

