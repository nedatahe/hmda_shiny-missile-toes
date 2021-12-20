library(tidyverse)
library(httr)
library(DT)
library(plotly)

#reading in state names for the selector dropdown

# state_names <- read_csv('../../data/states.csv') %>% 
#   drop_na()

#reading in initial dataset for Pacific Northwest

loans <- read_csv('../../data/state_WA-OR-ID.csv')

# code from James ro re-code numeric columns to categories

loans$action_taken <-recode(loans$action_taken,
                               '1'= 'loan originated',
                               '2'= 'application approved but not accepted',
                               '3'= 'application denied',
                               '4'= 'application withdrawn by applicant',
                               '5'= 'file closed for incompleteness',
                               '6'= 'purchased loan',
                               '7'= 'preapproval request denied',
                               '8'= 'preapproval request approved but not accepted'
)

loans$loan_type <-recode(loans$loan_type,
                            '1' = 'Conventional (not insured or guaranteed by FHA, VA, RHS, or FSA)',
                            '2' = 'Federal Housing Administration insured (FHA)',
                            '3' = 'Veterans Affairs guaranteed (VA)',
                            '4' = 'USDA Rural Housing Service or Farm Service Agency guaranteed (RHS or FSA)'
)
loans$construction_method <- recode(loans$construction_method,
                                       '1' = 'Site-built',
                                       '2' = 'Manufactured home'
)

loans$reverse_mortgage <- recode(loans$reverse_mortgage,
                                    '1' = 'Reverse mortgage',
                                    '2' = 'Not a reverse mortgage',
                                    '1111' = 'Exempt'
)

loans$occupancy_type <- recode(loans$occupancy_type,
                                  '1' = 'Principal residence',
                                  '2' = 'Second residence',
                                  '3' = 'Investment property'
)

loans$purchaser_type <-recode(loans$purchaser_type,
                                 '0' = 'Not applicable',
                                 '1' = 'Fannie Mae',
                                 '2' = 'Ginnie Mae',
                                 '3' = 'Freddie Mac',
                                 '4' = 'Farmer Mac',
                                 '5' = 'Private securitizer',
                                 '6' = 'Commercial bank, savings bank, or savings association',
                                 '71' ='Credit union, mortgage company, or finance company',
                                 '72' = 'Life insurance company',
                                 '8' = 'Affiliate institution',
                                 '9' = 'Other type of purchaser'                                
)

loans$loan_purpose <- recode(loans$loan_purpose,
                                '1' = 'Home purchase',
                                '2' = 'Home improvement',
                                '31'= 'Refinancing',
                                '32'= 'Cash-out refinancing',
                                '4' = 'Other purpose',
                                '5' = 'Not applicable'
)

loans$`denial_reason-1`<- recode(loans$`denial_reason-1`,
                                    '1' = 'Debt-to-income ratio',
                                    '2' = 'Employment history',
                                    '3' = 'Credit history',
                                    '4' = 'Collateral',
                                    '5' = 'Insufficient cash (downpayment, closing costs)',
                                    '6' = 'Unverifiable information',
                                    '7' = 'Credit application incomplete',
                                    '8' = 'Mortgage insurance denied',
                                    '9' = 'Other'
)

loans$`denial_reason-2`<- recode(loans$`denial_reason-2`,
                                    '1' = 'Debt-to-income ratio',
                                    '2' = 'Employment history',
                                    '3' = 'Credit history',
                                    '4' = 'Collateral',
                                    '5' = 'Insufficient cash (downpayment, closing costs)',
                                    '6' = 'Unverifiable information',
                                    '7' = 'Credit application incomplete',
                                    '8' = 'Mortgage insurance denied',
                                    '9' = 'Other'
)

loans$`denial_reason-3`<- recode(loans$`denial_reason-3`,
                                    '1' = 'Debt-to-income ratio',
                                    '2' = 'Employment history',
                                    '3' = 'Credit history',
                                    '4' = 'Collateral',
                                    '5' = 'Insufficient cash (downpayment, closing costs)',
                                    '6' = 'Unverifiable information',
                                    '7' = 'Credit application incomplete',
                                    '8' = 'Mortgage insurance denied',
                                    '9' = 'Other'
)

loans$`denial_reason-4`<- recode(as.numeric(loans$`denial_reason-4`),
                                    '1' = 'Debt-to-income ratio',
                                    '2' = 'Employment history',
                                    '3' = 'Credit history',
                                    '4' = 'Collateral',
                                    '5' = 'Insufficient cash (downpayment, closing costs)',
                                    '6' = 'Unverifiable information',
                                    '7' = 'Credit application incomplete',
                                    '8' = 'Mortgage insurance denied',
                                    '9' = 'Other'
)


# API call for LEI information

url_LEI <- 'https://ffiec.cfpb.gov/v2/data-browser-api/view/filers?states=WA,MT,ID,OR&years=2020'
response_PNW_LEI <- GET(url_LEI) 
lei_PNW <- content(response_PNW_LEI, type = 'text') %>% 
  jsonlite::fromJSON() %>% 
  .[[1]] %>%                      # Select the first element of the resulting list
  as_tibble()

# merge from James to add LEI names to data

loans<- loans %>%
  left_join(x=loans, y =lei_PNW, by = 'lei')

loans <- loans %>% 
  mutate(name_lei = paste(name, "-", lei))

#function for API call for additional state data - not currently used

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

